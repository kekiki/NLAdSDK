//
//  NLAdManager+ReadAd.m
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager+ReadAd.h"
#import "NLAdDispatchManager.h"

@implementation NLAdManager (ReadAd)

- (void)loadReadAdWithPlaceCode:(NLReadAdPlaceCode)placeCode
                     completion:(nullable void(^)(BOOL successed))completion {
    [[NLAdDispatchManager sharedManager] loadNativeAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:completion];
}

/// 判断当前是否有成功加载的开屏广告视图
/// @param placeCode广告位
- (BOOL)hasReadAdWithPlaceCode:(NLReadAdPlaceCode)placeCode {
    return [[NLAdDispatchManager sharedManager] hasNativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode];
}

/// 获取广告数据实例
/// 适用于NLAdReadAdView setupAdObject:
- (__kindof NSObject *)readAdObjectWithPlaceCode:(NLReadAdPlaceCode)placeCode {
    return [[NLAdDispatchManager sharedManager] readAdObjectWithPlaceCode:(NLAdPlaceCode)placeCode];
}

@end
