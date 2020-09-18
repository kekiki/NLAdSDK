//
//  NLAdManager+RewardAd.m
//  Novel
//
//  Created by Ke Jie on 2020/9/11.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager+RewardAd.h"
#import "NLAdDispatchManager.h"

@implementation NLAdManager (RewardAd)

/// 加载激励广告
/// @param placeCode 广告位
/// @param completion 加载结束回调
- (void)loadRewardAdWithPlaceCode:(NLRewardAdPlaceCode)placeCode
                       completion:(nullable void(^)(BOOL successed))completion {
    [[NLAdDispatchManager sharedManager] loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:completion];
}

/// 是否有激励广告正在播放
- (BOOL)isRewardAdPlaying {
    return [[NLAdDispatchManager sharedManager] isRewardAdPlaying];
}

/// 显示激励广告
/// @param viewController 激励广告下面的视图控制器
/// @param placeCode 广告位
/// @param block 用户看完激励视频回调
/// @return 是否present成功开始播放，返回false正常情况是激励视频加载失败了，会重新加载
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController
                              placeCode:(NLRewardAdPlaceCode)placeCode
                 userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block {
    return [[NLAdDispatchManager sharedManager] presentRewardAdInViewController:viewController placeCode:(NLAdPlaceCode)placeCode userDidEarnRewardBlock:block];
}

- (BOOL)presentDebugRewardAdInViewController:(UIViewController *)viewController
                                   placeCode:(NLRewardAdPlaceCode)placeCode
                      userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block {
    UIViewController *presentViewController = [UIViewController new];
    [viewController presentViewController:presentViewController animated:true completion:^{
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [presentViewController dismissViewControllerAnimated:true completion:^{
            if (block) block(nil);
        }];
    });
    
    return true;
    
}

@end
