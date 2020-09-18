//
//  NLAdAttribute.h
//  Novel
//
//  Created by Ke Jie on 2020/9/7.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NLAdAttribute : NSObject <NSCopying>

/// 标题颜色，默认黑色
@property (nonatomic, strong, nullable) UIColor *titleColor;

/// 详情/描述颜色，默认灰色
@property (nonatomic, strong, nullable) UIColor *detailColor;

/// icon透明度，默认不透明
@property (nonatomic, assign) CGFloat iconAlpha;

/// 媒体视图透明度，默认不透明
@property (nonatomic, assign) CGFloat mediaAlpha;

/// 按钮文字颜色，默认黑色
@property (nonatomic, strong, nullable) UIColor *buttonTitleColor;

/// 按钮描边颜色，默认灰色
@property (nonatomic, strong, nullable) UIColor *buttonBorderColor;

/// 占位图
@property (nonatomic, strong, nullable) UIImage *placeholderImage;

/// 按钮背景色
@property (nonatomic, strong, nullable) UIColor *buttonBackgroundColor;

/// 默认配置
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
