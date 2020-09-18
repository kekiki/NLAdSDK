//
//  NLAdManager+NativeAd.m
//  Novel
//
//  Created by Ke Jie on 2020/9/11.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager+NativeAd.h"
#import "NLAdDispatchManager.h"

@implementation NLAdManager (NativeAd)

/// 加载原生广告
/// @param placeCode广告位
/// @param completion 加载完成回调
- (void)loadNativeAdWithPlaceCode:(NLNativeAdPlaceCode)placeCode
                       completion:(nullable void(^)(BOOL successed))completion {
    [[NLAdDispatchManager sharedManager] loadNativeAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:completion];
}

/// 判断当前是否有成功加载的开屏广告视图
/// @param placeCode广告位
- (BOOL)hasNativeAdWithPlaceCode:(NLNativeAdPlaceCode)placeCode {
    return [[NLAdDispatchManager sharedManager] hasNativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode];
}

/// 获取开屏广告视图
/// @param placeCode广告位
- (UIView *)nativeAdViewWithPlaceCode:(NLNativeAdPlaceCode)placeCode {
    return [[NLAdDispatchManager sharedManager] nativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode];
}

/// 设置广告属性
/// @param attributes 属性配置
/// @param placeCode 广告位
- (void)setNativeAdAttributes:(NLAdAttribute *)attributes placeCode:(NLNativeAdPlaceCode)placeCode {
    [[NLAdDispatchManager sharedManager] setNativeAdAttributes:attributes placeCode:(NLAdPlaceCode)placeCode];
}

@end
