//
// Created by chuchur on 2019-04-15.
// Copyright (c) 2019 MTY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 设置颜色(返回DKColorPicker)
 */
#define DKColorPick(nomal,night) DKColorPickerWithColors(MEXColor(nomal),MEXColor(night))

@interface UIColor (Common)
- (instancetype)sam_colorByInterpolatingToColor:(UIColor *)nextColor progress:(CGFloat)progress;

+ (UIColor *)tfi_chartBlueColor;
+ (UIColor *)tfi_chartYellowColor;
+ (UIColor *)a1a1a1Color;
+ (UIColor *)e6e6e6Color;
+ (UIColor *)fafafaColor;
+ (UIColor *)f4f4f4Color;
+ (UIColor *)f6f6f6Color;
+ (UIColor *)eaeaeaColor;
+ (UIColor *)allThreeColor;
+ (UIColor *)allSixColor;
+ (UIColor *)allNineColor;
+ (UIColor *)allAColor;
+ (UIColor *)allEColor;
+ (UIColor *)tfi_yellowColor;
+ (UIColor *)tfi_textFieldTintColor;

+ (UIColor *)mex_blackColor;
+ (UIColor *)mex_contentBackColor;
+ (UIColor *)mex_hintColor;
+ (UIColor *)mex_textBorderColor;
+ (UIColor *)mex_borderColor;
+ (UIColor *)mex_textBlackColor;
+ (UIColor *)mex_textLightColor;
+ (UIColor *)mex_yellowColor;
+ (UIColor *)mex_shadowColor;
+ (UIColor *)mex_lineColor;
+ (UIColor *)mex_coverColor;
+ (UIColor *)mex_gray;

@end
