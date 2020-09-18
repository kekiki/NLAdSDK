//
// Created by chuchur on 2019-04-15.
// Copyright (c) 2019 MTY. All rights reserved.
//

#import "UIColor+Common.h"
#import "UIColor+Hex.h"


@implementation UIColor (Common)

+ (UIColor *)mex_gray {
    return [UIColor colorWithHex:0x878C97];
}

+ (UIColor *)mex_coverColor {
    return [UIColor colorWithHex:0xFE9619];
}

+ (UIColor *)mex_blackColor {
    return [UIColor colorWithHex:0x191B24];
}

+ (UIColor *)mex_contentBackColor {
    return [UIColor colorWithHex:0xF4F5F8];
}

+ (UIColor *)mex_hintColor {
    return [UIColor colorWithHex:0xAAB3BD];
}

+ (UIColor *)mex_textBorderColor {
    return [UIColor colorWithHex:0x747F8A];
}

+ (UIColor *)mex_borderColor {
    return [UIColor colorWithHex:0xE6E9F0];
}

+ (UIColor *)mex_textBlackColor {
    return [UIColor colorWithHex:0x1E2C45];
}

+ (UIColor *)mex_textLightColor {
    return [UIColor colorWithHex:0xC5CED6];
}

+ (UIColor *)mex_yellowColor {
    return [UIColor colorWithHex:0xFE9210];
}

+ (UIColor *)mex_shadowColor {
    return [UIColor colorWithHex:0xEDF0F5];
}

+ (UIColor *)mex_lineColor {
    return [UIColor colorWithHex:0xEDF2FC];
}

+ (UIColor *)tfi_chartBlueColor {
    return [UIColor colorWithHex:0x56A4FF];
}

+ (UIColor *)tfi_chartYellowColor {
    return [UIColor colorWithHex:0xFFBB4C];
}

+ (UIColor *)a1a1a1Color {
    return [UIColor colorWithHex:0xa1a1a1];
}

+ (UIColor *)fafafaColor {
    return [UIColor colorWithHex:0xfafafa];
}

+ (UIColor *)f4f4f4Color {
    return [UIColor colorWithHex:0xf4f4f4];
}

+ (UIColor *)f6f6f6Color {
    return [UIColor colorWithHex:0xf6f6f6];
}

+ (UIColor *)eaeaeaColor {
    return [UIColor colorWithHex:0xeaeaea];
}

+ (UIColor *)e6e6e6Color {
    return [UIColor colorWithHex:0XE6E6E6];
}

+ (UIColor *)allNineColor {
    return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)allSixColor {
    return [UIColor colorWithHex:0x666666];
}

+ (UIColor *)allThreeColor {
    return [UIColor colorWithHex:0x333333];
}

+ (UIColor *)allAColor {
    return [UIColor colorWithHex:0xaaaaaa];
}

+ (UIColor *)allEColor {
    return [UIColor colorWithHex:0xeeeeee];
}

+ (UIColor *)tfi_yellowColor {
    return [UIColor colorWithHex:0xFFDB4A];
}

+ (UIColor *)tfi_textFieldTintColor {
    return [UIColor colorWithHex:0xFFAE00];
}

- (instancetype)sam_colorByInterpolatingToColor:(UIColor *)nextColor progress:(CGFloat)progress {
    progress = fminf(1.0f, fmaxf(0.0f, (float) progress));

    CGFloat startRed, startGreen, startBlue, startAlpha;
    [self getRed:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];

    CGFloat endRed, endGreen, endBlue, endAlpha;
    [nextColor getRed:&endRed green:&endGreen blue:&endBlue alpha:&endAlpha];

    return [[self class] colorWithRed:startRed + (endRed - startRed) * progress
                                green:startGreen + (endGreen - startGreen) * progress
                                 blue:startBlue + (endBlue - startBlue) * progress
                                alpha:startAlpha + (endAlpha - startAlpha) * progress];
}

@end
