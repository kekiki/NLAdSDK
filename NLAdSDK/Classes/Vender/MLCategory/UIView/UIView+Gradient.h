//
//  UIVibrancyEffect+AZGradient.h
//  Touch 'n Go
//
//  Created by Allen on 2019/1/30.
//  Copyright © 2019年 orangenat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 渐变色
@interface UIView (Gradient)

+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

// [view setGradientBackgroundWithColors:@[WhiteColor,[UIColor colorWithHex:0xF7FAFE]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
