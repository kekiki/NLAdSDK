//
//  UIView+NLAdSDK.h
//  FBSDKCoreKit
//
//  Created by Ke Jie on 2020/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NLAdSDK)

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(nullable NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
