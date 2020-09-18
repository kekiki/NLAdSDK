//
//  NLAdDispatchManager.h
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

@interface NLAdDispatchManager : NSObject

/// 单利
+ (instancetype)sharedManager;

// 原生

/// 设置广告位条目列表
/// 广告的调度分发都是根据条目列表进行的
///
/// @param placeItems 广告位条目列表
- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems;

/// 加载开屏广告
/// @param completion 加载完成回调
/// @param placeCode 广告位
- (void)loadNativeAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:(nullable void(^)(BOOL successed))completion;

/// 当前是否有成功加载的开屏广告视图
/// @param placeCode 广告位
- (BOOL)hasNativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode;

/// 开屏广告视图
/// @param placeCode 广告位
- (UIView *)nativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode;

/// 设置广告属性
/// @param attributes 属性配置
/// @param placeCode 广告位
- (void)setNativeAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode;

// 激励

/// 是否有激励广告正在播放
- (BOOL)isRewardAdPlaying;

/// 加载激励广告
/// @param placeCode 广告位
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:(nullable void(^)(BOOL successed))completion;;

/// 显示激励广告
/// @param viewController 激励广告下面的视图控制器
/// @param placeCode 广告位
/// @param block 用户看完激励视频获取奖励回调
/// @return 是否present成功开始播放，返回false正常情况是激励视频加载失败了，会重新加载
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController
                              placeCode:(NLAdPlaceCode)placeCode
                 userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block;

@end

NS_ASSUME_NONNULL_END
