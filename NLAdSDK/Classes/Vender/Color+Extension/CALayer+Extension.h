//
//  CALayer+Extension.h
// Novel
//
//  Created by xiaobaizhang on 2019/11/6.
//  Copyright © 2019 fucang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Extension)

/// 渐变色图层 水平方向 渐变色值（172A52--0E1B33）
+ (CAGradientLayer *)horizontalGradientColor:(CGRect)frame;

/// 渐变色图层 水平方向
/// @param frame frame
/// @param colors 渐变色值 默认（172A52--0E1B33）
+ (CAGradientLayer *)horizontalGradientColor:(CGRect)frame colors:(NSArray <NSString *>*)colors;

/// 渐变色图层 垂直方向 渐变色值（172A52--0E1B33）
+ (CAGradientLayer *)verticalGradientColor:(CGRect)frame;

/// 渐变色图层 垂直方向
/// @param frame frame
/// @param colors 渐变色值 默认（172A52--0E1B33）
+ (CAGradientLayer *)verticalGradientColor:(CGRect)frame colors:(NSArray <NSString *>*)colors;
@end

NS_ASSUME_NONNULL_END
