//
//  UIVibrancyEffect+AZGradient.m
//  Touch 'n Go
//
//  Created by Allen on 2019/1/30.
//  Copyright © 2019年 orangenat. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

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
