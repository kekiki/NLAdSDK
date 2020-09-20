//
//  NLAdManager+ReadAd.h
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager.h"

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

@interface NLAdManager (ReadAd)

/// 加载阅读原生广告
/// @param placeCode广告位
/// @param completion 加载完成回调
- (void)loadReadAdWithPlaceCode:(NLReadAdPlaceCode)placeCode
                     completion:(nullable void(^)(BOOL successed))completion;

/// 判断当前是否有成功加载的开屏广告视图
/// @param placeCode广告位
- (BOOL)hasReadAdWithPlaceCode:(NLReadAdPlaceCode)placeCode;

/// 获取广告数据实例
/// 适用于NLAdReadAdView setupAdObject:
- (__kindof NSObject *)readAdObjectWithPlaceCode:(NLReadAdPlaceCode)placeCode;


@end

NS_ASSUME_NONNULL_END
