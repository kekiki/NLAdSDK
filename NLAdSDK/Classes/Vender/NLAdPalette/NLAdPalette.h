//
//  TRIPPalette.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NLAdPaletteTarget.h"
#import "NLAdPaletteColorModel.h"

static const NSInteger kMaxColorNum = 16;

typedef void(^NLAdGetColorBlock)(NLAdPaletteColorModel *recommendColor,NSDictionary *allModeColorDic,NSError *error);

@interface NLAdPalette : NSObject

- (instancetype)initWithSourceImage:(UIImage*)image;

- (void)startToAnalyzeForTargetMode:(NLAdPaletteTargetMode)mode withCallBack:(NLAdGetColorBlock)block;

@end



@interface NLAdVBox : NSObject

- (NSInteger)getBoxVolume;

@end
