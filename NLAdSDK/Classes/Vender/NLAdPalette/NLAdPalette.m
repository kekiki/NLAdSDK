//
//  NLAdPalette.m
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "NLAdPalette.h"
#import "NlAdPaletteSwatch.h"
#import "NLAdPaletteColorUtils.h"
#import "NLAdPriorityBoxArray.h"

typedef NS_ENUM(NSInteger,NLADSDK_COMPONENT_COLOR){
    NLADSDK_COMPONENT_RED = 0,
    NLADSDK_COMPONENT_GREEN = 1,
    NLADSDK_COMPONENT_BLUE = 2
};

const NSInteger NLADSDK_QUANTIZE_WORD_WIDTH = 5;
const NSInteger NLADSDK_QUANTIZE_WORD_MASK = (1 << NLADSDK_QUANTIZE_WORD_WIDTH) - 1;
const CGFloat nladsdk_resizeArea = 160 * 160;

int nladsdk_hist[32768];

@interface NLAdVBox()

@property (nonatomic,assign) NSInteger lowerIndex;

@property (nonatomic,assign) NSInteger upperIndex;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger population;

@property (nonatomic,assign) NSInteger minRed;

@property (nonatomic,assign) NSInteger maxRed;

@property (nonatomic,assign) NSInteger minGreen;

@property (nonatomic,assign) NSInteger maxGreen;

@property (nonatomic,assign) NSInteger minBlue;

@property (nonatomic,assign) NSInteger maxBlue;

@end

@implementation NLAdVBox

- (instancetype)initWithLowerIndex:(NSInteger)lowerIndex upperIndex:(NSInteger)upperIndex colorArray:(NSMutableArray*)colorArray{
    self = [super init];
    if (self){
        
        _lowerIndex = lowerIndex;
        _upperIndex = upperIndex;
        _distinctColors = colorArray;
    
        [self fitBox];
        
    }
    return self;
}

- (NSInteger)getBoxVolume{
    NSInteger volume = (_maxRed - _minRed + 1) * (_maxGreen - _minGreen + 1) *
    (_maxBlue - _minBlue + 1);
    return volume;
}

/**
 * Split this color box at the mid-point along it's longest dimension
 *
 * @return the new ColorBox
 */
- (NLAdVBox*)splitBox{
    if (![self canSplit]) {
        return nil;
    }
    
    // find median along the longest dimension
    NSInteger splitPoint = [self findSplitPoint];
    
    NLAdVBox *newBox = [[NLAdVBox alloc]initWithLowerIndex:splitPoint+1 upperIndex:_upperIndex colorArray:_distinctColors];
    
    // Now change this box's upperIndex and recompute the color boundaries
    _upperIndex = splitPoint;
    [self fitBox];
    
    return newBox;
}

- (NSInteger)findSplitPoint{
    NSInteger longestDimension = [self getLongestColorDimension];
    
    // We need to sort the colors in this box based on the longest color dimension.
    // As we can't use a Comparator to define the sort logic, we modify each color so that
    // it's most significant is the desired dimension
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    [self sortColorArray];
    
    // Now revert all of the colors so that they are packed as RGB again
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];

//    modifySignificantOctet(colors, longestDimension, mLowerIndex, mUpperIndex);
    
    NSInteger midPoint = _population / 2;
    for (NSInteger i = _lowerIndex, count = 0; i <= _upperIndex; i++)  {
        NSInteger population = nladsdk_hist[[_distinctColors[i] intValue]];
        count += population;
        if (count >= midPoint) {
            return i;
        }
    }
    
    return _lowerIndex;
}

- (void)sortColorArray{
    
    // Now sort... Arrays.sort uses a exclusive toIndex so we need to add 1
    
    NSInteger sortCount = (_upperIndex - _lowerIndex) + 1;
    NSInteger sortArray[sortCount];
    NSInteger sortIndex = 0;
    
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        sortArray[sortIndex] = [_distinctColors[index] integerValue];
        sortIndex++;
    }
    
    NSInteger arrayLength = sortIndex;
    
    //bubble sort
    for(NSInteger i = 0; i < arrayLength-1; i++)
    {
        BOOL isSorted = YES;
        for(NSInteger j=0; j<arrayLength-1-i; j++)
        {
            if(sortArray[j] > sortArray[j+1])
            {
                isSorted = NO;
                NSInteger temp = sortArray[j];
                sortArray[j] = sortArray[j+1];
                sortArray[j+1]=temp;
            }
        }
        if(isSorted)
            break;
    }
    
    sortIndex = 0;
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        _distinctColors[index] = [NSNumber numberWithInteger:sortArray[sortIndex]];
        sortIndex++;
    }
}

/**
 * @return the dimension which this box is largest in
 */
- (NSInteger) getLongestColorDimension{
    NSInteger redLength = _maxRed - _minRed;
    NSInteger greenLength = _maxGreen - _minGreen;
    NSInteger blueLength = _maxBlue - _minBlue;
    
    if (redLength >= greenLength && redLength >= blueLength) {
        return NLADSDK_COMPONENT_RED;
    } else if (greenLength >= redLength && greenLength >= blueLength) {
        return NLADSDK_COMPONENT_GREEN;
    } else {
        return NLADSDK_COMPONENT_BLUE;
    }
}

/**
 * Modify the significant octet in a packed color int. Allows sorting based on the value of a
 * single color component. This relies on all components being the same word size.
 *
 * @see Vbox#findSplitPoint()
 */
- (void) modifySignificantOctetWithDismension:(NSInteger)dimension lowerIndex:(NSInteger)lower upperIndex:(NSInteger)upper{
    switch (dimension) {
        case NLADSDK_COMPONENT_RED:
            // Already in RGB, no need to do anything
            break;
        case NLADSDK_COMPONENT_GREEN:
            // We need to do a RGB to GRB swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor = [NLAdPaletteColorUtils quantizedGreen:color] << (NLADSDK_QUANTIZE_WORD_WIDTH + NLADSDK_QUANTIZE_WORD_WIDTH)
                | [NLAdPaletteColorUtils quantizedRed:color]  << NLADSDK_QUANTIZE_WORD_WIDTH | [NLAdPaletteColorUtils quantizedBlue:color];
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
        case NLADSDK_COMPONENT_BLUE:
            // We need to do a RGB to BGR swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor =  [NLAdPaletteColorUtils quantizedBlue:color] << (NLADSDK_QUANTIZE_WORD_WIDTH + NLADSDK_QUANTIZE_WORD_WIDTH)
                | [NLAdPaletteColorUtils quantizedGreen:color]  << NLADSDK_QUANTIZE_WORD_WIDTH
                | [NLAdPaletteColorUtils quantizedRed:color];
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
    }
}

/**
 * @return the average color of this box.
 */
- (NlAdPaletteSwatch*)getAverageColor{
    NSInteger redSum = 0;
    NSInteger greenSum = 0;
    NSInteger blueSum = 0;
    NSInteger totalPopulation = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        NSInteger colorPopulation = nladsdk_hist[color];
        
        totalPopulation += colorPopulation;
        
        redSum += colorPopulation * [NLAdPaletteColorUtils quantizedRed:color];
        greenSum += colorPopulation * [NLAdPaletteColorUtils quantizedGreen:color];
        blueSum += colorPopulation * [NLAdPaletteColorUtils quantizedBlue:color];
    }
    
    //in case of totalPopulation equals to 0
    if (totalPopulation <= 0){
        return nil;
    }
    
    NSInteger redMean = redSum / totalPopulation;
    NSInteger greenMean = greenSum / totalPopulation;
    NSInteger blueMean = blueSum / totalPopulation;
    
    redMean = [NLAdPaletteColorUtils modifyWordWidthWithValue:redMean currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];
    greenMean = [NLAdPaletteColorUtils modifyWordWidthWithValue:greenMean currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];
    blueMean = [NLAdPaletteColorUtils modifyWordWidthWithValue:blueMean currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];

    NSInteger rgb888Color = redMean << 2 * 8 | greenMean << 8 | blueMean;
    
    NlAdPaletteSwatch *swatch = [[NlAdPaletteSwatch alloc]initWithColorInt:rgb888Color population:totalPopulation];
    
    return swatch;
}

- (BOOL)canSplit{
    if ((_upperIndex - _lowerIndex) <= 0){
        return NO;
    }
    return YES;
}

- (void)fitBox{
    
    // Reset the min and max to opposite values
    NSInteger minRed, minGreen, minBlue;
    minRed = minGreen = minBlue = 32768;
    NSInteger maxRed, maxGreen, maxBlue;
    maxRed = maxGreen = maxBlue = 0;
    NSInteger count = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        count += nladsdk_hist[color];
        
        NSInteger r = [NLAdPaletteColorUtils quantizedRed:color];
        NSInteger g =  [NLAdPaletteColorUtils quantizedGreen:color];
        NSInteger b =  [NLAdPaletteColorUtils quantizedBlue:color];
        
        if (r > maxRed) {
            maxRed = r;
        }
        if (r < minRed) {
            minRed = r;
        }
        if (g > maxGreen) {
            maxGreen = g;
        }
        if (g < minGreen) {
            minGreen = g;
        }
        if (b > maxBlue) {
            maxBlue = b;
        }
        if (b < minBlue) {
            minBlue = b;
        }
    }
    
    _minRed = minRed;
    _maxRed = maxRed;
    _minGreen = minGreen;
    _maxGreen = maxGreen;
    _minBlue = minBlue;
    _maxBlue = maxBlue;
    _population = count;
}

@end

@interface NLAdPalette ()

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NLAdPriorityBoxArray *priorityArray;

@property (nonatomic,strong) NSArray *swatchArray;

@property (nonatomic,strong) NSArray *targetArray;

@property (nonatomic,assign) NSInteger maxPopulation;

@property (nonatomic,strong) NSMutableArray *distinctColors;

/** the pixel count of the image */
@property (nonatomic,assign) NSInteger pixelCount;

/** callback */
@property (nonatomic,copy) NLAdGetColorBlock getColorBlock;

/** specify mode */
@property (nonatomic,assign) NLAdPaletteTargetMode mode;

/** needColorDic */
@property (nonatomic,assign) BOOL isNeedColorDic;

@end

@implementation NLAdPalette

-(instancetype)initWithSourceImage:(UIImage *)image{
    self = [super init];
    if (self){
        _image = image;
    }
    return self;
}

#pragma mark - Core code to analyze the main color of a image

- (void)startToAnalyzeImage:(NLAdGetColorBlock)block{
    [self startToAnalyzeForTargetMode:NLADSDK_DEFAULT_NON_MODE_PALETTE withCallBack:block];
}

- (void)startToAnalyzeForTargetMode:(NLAdPaletteTargetMode)mode withCallBack:(NLAdGetColorBlock)block{
    [self initTargetsWithMode:mode];
    
    //Check the image is nil or not
    if (!_image){
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The image is nill.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the image input please", nil)
                                   };
        NSError *nullImageError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:userInfo];
        block(nil,nil,nullImageError);
        return;
    }
    _getColorBlock = block;
    [self startToAnalyzeImage];
}

- (void)startToAnalyzeImage{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self clearHistArray];
        
        // Get raw pixel data from image
        unsigned char *rawData = [self rawPixelDataFromImage:_image];
        if (!rawData || self.pixelCount <= 0){
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The image is nill.", nil),
                                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the image input please", nil)
                                           };
            NSError *nullImageError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:userInfo];
            _getColorBlock(nil,nil,nullImageError);
            return;
        }
        
        NSInteger red,green,blue;
        for (int pixelIndex = 0 ; pixelIndex < self.pixelCount; pixelIndex++){
            
            red   = (NSInteger)rawData[pixelIndex*4+0];
            green = (NSInteger)rawData[pixelIndex*4+1];
            blue  = (NSInteger)rawData[pixelIndex*4+2];
            
            //switch RGB888 to RGB555
            red = [NLAdPaletteColorUtils modifyWordWidthWithValue:red currentWidth:8 targetWidth:NLADSDK_QUANTIZE_WORD_WIDTH];
            green = [NLAdPaletteColorUtils modifyWordWidthWithValue:green currentWidth:8 targetWidth:NLADSDK_QUANTIZE_WORD_WIDTH];
            blue = [NLAdPaletteColorUtils modifyWordWidthWithValue:blue currentWidth:8 targetWidth:NLADSDK_QUANTIZE_WORD_WIDTH];
            
            NSInteger quantizedColor = red << 2*NLADSDK_QUANTIZE_WORD_WIDTH | green << NLADSDK_QUANTIZE_WORD_WIDTH | blue;
            nladsdk_hist[quantizedColor] ++;
        }
        
        free(rawData);
        
        NSInteger distinctColorCount = 0;
        NSInteger length = sizeof(nladsdk_hist)/sizeof(nladsdk_hist[0]);
        for (NSInteger color = 0 ; color < length ;color++){
            if (nladsdk_hist[color] > 0 && [self shouldIgnoreColor:color]){
                nladsdk_hist[color] = 0;
            }
            if (nladsdk_hist[color] > 0){
                distinctColorCount ++;
            }
        }
        
        NSInteger distinctColorIndex = 0;
        _distinctColors = [[NSMutableArray alloc]init];
        for (NSInteger color = 0; color < length ;color++){
            if (nladsdk_hist[color] > 0){
                [_distinctColors addObject: [NSNumber numberWithInteger:color]];
                distinctColorIndex++;
            }
        }
        
        // distinctColorIndex should be equal to (length - 1)
        distinctColorIndex--;
        
        if (distinctColorCount <= kMaxColorNum){
            NSMutableArray *swatchs = [[NSMutableArray alloc]init];
            for (NSInteger i = 0;i < distinctColorCount ; i++){
                NSInteger color = [_distinctColors[i] integerValue];
                NSInteger population = nladsdk_hist[color];
                
                NSInteger red = [NLAdPaletteColorUtils quantizedRed:color];
                NSInteger green = [NLAdPaletteColorUtils quantizedGreen:color];
                NSInteger blue = [NLAdPaletteColorUtils quantizedBlue:color];
                
                red = [NLAdPaletteColorUtils modifyWordWidthWithValue:red currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];
                green = [NLAdPaletteColorUtils modifyWordWidthWithValue:green currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];
                blue = [NLAdPaletteColorUtils modifyWordWidthWithValue:blue currentWidth:NLADSDK_QUANTIZE_WORD_WIDTH targetWidth:8];
                
                color = red << 2 * 8 | green << 8 | blue;
                
                NlAdPaletteSwatch *swatch = [[NlAdPaletteSwatch alloc]initWithColorInt:color population:population];
                [swatchs addObject:swatch];
            }
            
            _swatchArray = [swatchs copy];
        }else{
            _priorityArray = [[NLAdPriorityBoxArray alloc]init];
            NLAdVBox *colorVBox = [[NLAdVBox alloc]initWithLowerIndex:0 upperIndex:distinctColorIndex colorArray:_distinctColors];
            [_priorityArray addVBox:colorVBox];
            // split the VBox
            [self splitBoxes:_priorityArray];
            //Switch VBox to Swatch
            self.swatchArray = [self generateAverageColors:_priorityArray];
        }
        
        [self findMaxPopulation];
        
        [self getSwatchForTarget];
    });

}

- (void)splitBoxes:(NLAdPriorityBoxArray*)queue{
    //queue is a priority queue.
    while (queue.count < kMaxColorNum) {
        NLAdVBox *vbox = [queue poll];
        if (vbox != nil && [vbox canSplit]) {
            // First split the box, and offer the result
            [queue addVBox:[vbox splitBox]];
            // Then offer the box back
            [queue addVBox:vbox];
        }else{
            NSLog(@"All boxes split");
            return;
        }
    }
}

- (NSArray*)generateAverageColors:(NLAdPriorityBoxArray*)array{
    NSMutableArray *swatchs = [[NSMutableArray alloc]init];
    NSMutableArray *vboxArray = [array getVBoxArray];
    for (NLAdVBox *vbox in vboxArray){
        NlAdPaletteSwatch *swatch = [vbox getAverageColor];
        if (swatch){
            [swatchs addObject:swatch];
        }
    }
    return [swatchs copy];
}

#pragma mark - image compress

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image{
    // Get cg image and its size
    
//    image = [self scaleDownImage:image];
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    // Allocate storage for the pixel data
    unsigned char *rawData = (unsigned char *)malloc(height * width * 4);
    
    // If allocation failed, return NULL
    if (!rawData) return NULL;
    
    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Set some metrics
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    // Create context using the storage
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Release the color space
    CGColorSpaceRelease(colorSpace);
    
    // Draw the image into the storage
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // We are done with the context
    CGContextRelease(context);
    
    // Write pixel count to passed pointer
    self.pixelCount = (NSInteger)width * (NSInteger)height;
    
    // Return pixel data (needs to be freed)
    return rawData;
}

- (UIImage*)scaleDownImage:(UIImage*)image{
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    double scaleRatio;
    CGFloat imageSize = width * height;
    if (imageSize > nladsdk_resizeArea){
        scaleRatio = nladsdk_resizeArea / ((double)imageSize);
        CGSize scaleSize = CGSizeMake((CGFloat)(width * scaleRatio),(CGFloat)(height * scaleRatio));
        UIGraphicsBeginImageContext(scaleSize);
        [_image drawInRect:CGRectMake(0.0f, 0.0f, scaleSize.width, scaleSize.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return scaledImage;
    }else{
        return image;
    }
    
}

- (void)initTargetsWithMode:(NLAdPaletteTargetMode)mode{
    NSMutableArray *targets = [[NSMutableArray alloc]init];
    
    if (mode < NLADSDK_VIBRANT_PALETTE || mode > NLADSDK_ALL_MODE_PALETTE || mode == NLADSDK_ALL_MODE_PALETTE){
        
        NLAdPaletteTarget *vibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_VIBRANT_PALETTE];
        [targets addObject:vibrantTarget];
        
        NLAdPaletteTarget *mutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_MUTED_PALETTE];
        [targets addObject:mutedTarget];
        
        NLAdPaletteTarget *lightVibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_LIGHT_VIBRANT_PALETTE];
        [targets addObject:lightVibrantTarget];
        
        NLAdPaletteTarget *lightMutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_LIGHT_MUTED_PALETTE];
        [targets addObject:lightMutedTarget];

        NLAdPaletteTarget *darkVibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_DARK_VIBRANT_PALETTE];
        [targets addObject:darkVibrantTarget];

        NLAdPaletteTarget *darkMutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_DARK_MUTED_PALETTE];
        [targets addObject:darkMutedTarget];
        
    }else{
        if (mode & (1 << 0)){
            NLAdPaletteTarget *vibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_VIBRANT_PALETTE];
            [targets addObject:vibrantTarget];
        }
        if (mode & (1 << 1)){
            NLAdPaletteTarget *lightVibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_LIGHT_VIBRANT_PALETTE];
            [targets addObject:lightVibrantTarget];
        }
        if (mode & (1 << 2)){
            NLAdPaletteTarget *darkVibrantTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_DARK_VIBRANT_PALETTE];
            [targets addObject:darkVibrantTarget];
        }
        if (mode & (1 << 3)){
            NLAdPaletteTarget *lightMutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_LIGHT_MUTED_PALETTE];
            [targets addObject:lightMutedTarget];
        }
        if (mode & (1 << 4)){
            NLAdPaletteTarget *mutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_MUTED_PALETTE];
            [targets addObject:mutedTarget];
        }
        if (mode & (1 << 5)){
            NLAdPaletteTarget *darkMutedTarget = [[NLAdPaletteTarget alloc]initWithTargetMode:NLADSDK_DARK_MUTED_PALETTE];
            [targets addObject:darkMutedTarget];
        }
    }
    _targetArray = [targets copy];
    
    if (mode >= NLADSDK_VIBRANT_PALETTE && mode <= NLADSDK_ALL_MODE_PALETTE){
        _isNeedColorDic = YES;
    }
}

#pragma mark - utils method

- (void)clearHistArray{
    for (NSInteger i = 0;i<32768;i++){
        nladsdk_hist[i] = 0;
    }
}

- (BOOL)shouldIgnoreColor:(NSInteger)color{
    return NO;
}

- (void)findMaxPopulation{
    NSInteger max = 0;
    
    for (NSInteger i = 0; i <_swatchArray.count ; i++){
        NlAdPaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        NSInteger swatchPopulation = [swatch getPopulation];
        max =  MAX(max, swatchPopulation);
    }
    _maxPopulation = max;
}

#pragma mark - generate score

- (void)getSwatchForTarget{
    NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]init];
    NLAdPaletteColorModel *recommendColorModel;
    for (NSInteger i = 0;i<_targetArray.count;i++){
        NLAdPaletteTarget *target = [_targetArray objectAtIndex:i];
        [target normalizeWeights];
        NlAdPaletteSwatch *swatch = [self getMaxScoredSwatchForTarget:target];
        if (swatch){
            NLAdPaletteColorModel *colorModel = [[NLAdPaletteColorModel alloc]init];
            colorModel.imageColorString = [swatch getColorString];
            
            colorModel.percentage = (CGFloat)[swatch getPopulation]/(CGFloat)self.pixelCount;
            
//            colorModel.titleTextColorString = [swatch getTitleTextColorString];
//            colorModel.bodyTextColorString = [swatch getBodyTextColorString];
            
            if (colorModel){
                [finalDic setObject:colorModel forKey:[target getTargetKey]];
            }
            
            if (!recommendColorModel){
                recommendColorModel = colorModel;
                
                if (!_isNeedColorDic){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _getColorBlock(recommendColorModel,nil,nil);
                    });
                    return;
                }
            }
            
        }else{
            [finalDic setObject:@"unrecognized error" forKey:[target getTargetKey]];
        }
    }
    
    
    NSDictionary *finalColorDic = [finalDic copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        _getColorBlock(recommendColorModel,finalColorDic,nil);
    });

}

- (NlAdPaletteSwatch*)getMaxScoredSwatchForTarget:(NLAdPaletteTarget*)target{
    CGFloat maxScore = 0;
    NlAdPaletteSwatch *maxScoreSwatch = nil;
    for (NSInteger i = 0 ; i<_swatchArray.count; i++){
        NlAdPaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        if ([self shouldBeScoredForTarget:swatch target:target]){
            CGFloat score = [self generateScoreForTarget:target swatch:swatch];
            if (maxScore == 0 || score > maxScore){
                maxScoreSwatch = swatch;
                maxScore = score;
            }
        }
    }
    return maxScoreSwatch;
}

- (BOOL)shouldBeScoredForTarget:(NlAdPaletteSwatch*)swatch target:(NLAdPaletteTarget*)target{
    NSArray *hsl = [swatch getHsl];
    return [hsl[1] floatValue] >= [target getMinSaturation] && [hsl[1] floatValue]<= [target getMaxSaturation]
    && [hsl[2] floatValue]>= [target getMinLuma] && [hsl[2] floatValue] <= [target getMaxLuma];
    
}

- (CGFloat)generateScoreForTarget:(NLAdPaletteTarget*)target swatch:(NlAdPaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    
    float saturationScore = 0;
    float luminanceScore = 0;
    float populationScore = 0;
    
    if ([target getSaturationWeight] > 0) {
        saturationScore = [target getSaturationWeight]
        * (1.0f - fabsf([hsl[1] floatValue] - [target getTargetSaturation]));
    }
    if ([target getLumaWeight] > 0) {
        luminanceScore = [target getLumaWeight]
        * (1.0f - fabsf([hsl[2] floatValue] - [target getTargetLuma]));
    }
    if ([target getPopulationWeight] > 0) {
        populationScore = [target getPopulationWeight]
        * ([swatch getPopulation] / (float) _maxPopulation);
    }
    
    return saturationScore + luminanceScore + populationScore;
}

@end
