//
//  NLAdManager+RewardAd.h
//  Novel
//
//  Created by Ke Jie on 2020/9/11.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager.h"
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 激励广告
@interface NLAdManager (RewardAd)

/// 加载激励广告
/// @param placeCode 广告位
/// @param completion 加载结束回调
- (void)loadRewardAdWithPlaceCode:(NLRewardAdPlaceCode)placeCode
                       completion:(nullable void(^)(BOOL successed))completion;

/// 是否有激励广告正在播放
- (BOOL)isRewardAdPlaying;

/// 显示激励广告
/// @param viewController 激励广告下面的视图控制器
/// @param placeCode 广告位
/// @param block 用户看完激励视频回调
/// @return 是否present成功开始播放，返回false正常情况是激励视频加载失败了，会重新加载
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController
                              placeCode:(NLRewardAdPlaceCode)placeCode
                 userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block;

- (BOOL)presentDebugRewardAdInViewController:(UIViewController *)viewController
                                   placeCode:(NLRewardAdPlaceCode)placeCode
                      userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block;

@end

NS_ASSUME_NONNULL_END
