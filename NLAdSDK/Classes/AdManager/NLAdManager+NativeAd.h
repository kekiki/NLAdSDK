//
//  NLAdManager+NativeAd.h
//  Novel
//
//  Created by Ke Jie on 2020/9/11.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager.h"
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

/// 原生广告
@interface NLAdManager (NativeAd)

/// 加载原生广告
/// @param placeCode 广告位
/// @param completion 加载完成回调
- (void)loadNativeAdWithPlaceCode:(NLNativeAdPlaceCode)placeCode
                       completion:(nullable void(^)(BOOL successed))completion;

/// 判断当前是否有成功加载的开屏广告视图
/// @param placeCode 广告位
- (BOOL)hasNativeAdWithPlaceCode:(NLNativeAdPlaceCode)placeCode;

/// 获取阅读广告视图
/// @param placeCode 广告位
- (UIView *)nativeAdViewWithPlaceCode:(NLNativeAdPlaceCode)placeCode;

/// 设置广告属性
/// @param attributes 属性配置
/// @param placeCode 广告位
- (void)setNativeAdAttributes:(NLAdAttribute *)attributes placeCode:(NLNativeAdPlaceCode)placeCode;

@end

NS_ASSUME_NONNULL_END
