//
//  NLAdReadAdView.h
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAdDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

/// 阅读广告视图
@interface NLAdReadAdView : UIView

/// 设置广告数据
/// @param adObject 广告数据对象
- (void)setupObject:(__kindof NSObject *)adObject;

/// 设置广告属性
/// @param attributes 属性配置
/// @param placeCode 广告位
- (void)setAttributes:(NLAdAttribute *)attributes;

@end

NS_ASSUME_NONNULL_END
