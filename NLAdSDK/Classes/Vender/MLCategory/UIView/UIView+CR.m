//
//  UIView+CR.m
//  jdApp
//
//  Created by SquRab on 2019/4/1.
//  Copyright © 2019 squrab. All rights reserved.
//

#import "UIView+CR.h"

@implementation UIView (CR)

@dynamic borderColor, borderWidth, cornerRadiu, shadowCornerRadius, shadowRadius, shadowColor, shadowOpacity;

- (void)setCornerRadiu:(CGFloat)cornerRadiu {
    self.layer.cornerRadius= cornerRadiu;
    self.layer.masksToBounds= cornerRadiu >0;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowCornerRadius:(CGFloat)shadowCornerRadius {
    self.layer.cornerRadius = shadowCornerRadius;
}

-(void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setRoundedCorner:(CGSize)radii top:(BOOL)isTop {
    UIRectCorner corner;
    if (isTop) {
        corner = UIRectCornerTopLeft|UIRectCornerTopRight;
    } else {
        corner = UIRectCornerBottomLeft|UIRectCornerBottomRight;
    }
    CGRect frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corner cornerRadii:radii];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = frame;
    masklayer.path = path.CGPath;
    self.layer.mask = masklayer;
}


@end
