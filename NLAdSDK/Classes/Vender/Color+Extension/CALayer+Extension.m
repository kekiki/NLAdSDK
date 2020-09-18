//
//  CALayer+Extension.m
// Novel
//
//  Created by xiaobaizhang on 2019/11/6.
//  Copyright © 2019 fucang. All rights reserved.
//

#import "CALayer+Extension.h"
#import "UIColor+Hex.h"

@implementation CALayer (Extension)

+ (CAGradientLayer *)horizontalGradientColor:(CGRect)frame{
    return [self horizontalGradientColor:frame colors:@[(__bridge id)[UIColor colorWithHexString:@"172A52"].CGColor, (__bridge id)[UIColor colorWithHexString:@"0E1B33"].CGColor]];
}

+ (CAGradientLayer *)horizontalGradientColor:(CGRect)frame colors:(NSArray <NSString *>*)colors{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil) {
        
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"172A52"].CGColor, (__bridge id)[UIColor colorWithHexString:@"0E1B33"].CGColor];
    }else{
        NSMutableArray *graColors = [NSMutableArray array];
        for (NSString *str in colors) {
            [graColors addObject:(__bridge id)[UIColor colorWithHexString:str].CGColor];
        }
        gradientLayer.colors = graColors;
    }
    gradientLayer.locations = @[@0.2, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = frame;
    return gradientLayer;
}

+ (CAGradientLayer *)verticalGradientColor:(CGRect)frame{
    return [self verticalGradientColor:frame colors:@[(__bridge id)[UIColor colorWithHexString:@"172A52"].CGColor, (__bridge id)[UIColor colorWithHexString:@"0E1B33"].CGColor]];
}

+ (CAGradientLayer *)verticalGradientColor:(CGRect)frame colors:(NSArray <NSString *>*)colors{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil) {
        
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"172A52"].CGColor, (__bridge id)[UIColor colorWithHexString:@"0E1B33"].CGColor];
    }else{
        NSMutableArray *graColors = [NSMutableArray array];
        for (NSString *str in colors) {
            [graColors addObject:(__bridge id)[UIColor colorWithHexString:str].CGColor];
        }
        gradientLayer.colors = graColors;
    }
    gradientLayer.locations = @[@0.2, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = frame;
    return gradientLayer;
}

@end
