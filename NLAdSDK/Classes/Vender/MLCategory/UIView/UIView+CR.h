//
//  UIView+CR.h
//  jdApp
//
//  Created by Allen on 2019/4/1.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//IB_DESIGNABLE
@interface UIView (CR)
/**
 设置圆角和阴影
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadiu;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, assign) IBInspectable CGFloat shadowCornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *shadowColor;

- (void)setRoundedCorner:(CGSize)radii top:(BOOL)isTop;

@end

NS_ASSUME_NONNULL_END
