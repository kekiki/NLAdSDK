//
//  UIView+NLAdSDK.m
//  FBSDKCoreKit
//
//  Created by Ke Jie on 2020/9/20.
//

#import "UIView+NLAdSDK.h"

@implementation UIView (NLAdSDK)

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.colors = [colorsM copy];
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
}

@end
