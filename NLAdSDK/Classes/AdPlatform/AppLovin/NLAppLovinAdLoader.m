//
//  NLAppLovinAdLoader.m
//  Novel
//
//  Created by Ray Tao on 2020/9/21.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAppLovinAdLoader.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface NLAppLovinAdLoader () <ALAdRewardDelegate, ALAdLoadDelegate, ALAdDisplayDelegate>
@property (nonatomic, assign) NLAdPlaceCode playingPlaceCode;
@property (nonatomic, assign) NLAdPlaceCode loadingPlaceCode;
@property (nonatomic, assign) NSString *playingPlaceId;
@property (nonatomic, assign) NSString *loadingPlaceId;
@property (nonatomic, assign) BOOL isRewardUser;
@end

@implementation NLAppLovinAdLoader


+ (instancetype)sharedLoader {
    static NLAppLovinAdLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [ALSdk initializeSdk];
        [ALIncentivizedInterstitialAd shared].adDisplayDelegate = self;
    }
    return self;
}

#pragma mark - NLPlatformAdLoaderProtocol

// 原生
- (void)loadAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    
}

- (BOOL)hasAdWithPlaceCode:(NLAdPlaceCode)placeCode {
    return false;
}

- (nullable UIView *)adViewWithPlaceCode:(NLAdPlaceCode)placeCode {
    return nil;
}

- (void)setAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode {
    
}

- (__kindof NSObject *)readAdObjectWithPlaceCode:(NLReadAdPlaceCode)placeCode {
    return nil;
}

- (BOOL)hasRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    return [ALIncentivizedInterstitialAd isReadyForDisplay];
}

// 激励
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    if (![ALIncentivizedInterstitialAd isReadyForDisplay]) {
        [ALIncentivizedInterstitialAd preloadAndNotify:self];
        self.loadingPlaceCode = placeCode;
        self.loadingPlaceId = placeId;
        // 广告开始播放
        if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdStartedWithPlaceCode:placeId:)]) {
            [self.delegate adLoader:self loadRewardAdStartedWithPlaceCode:placeCode placeId:placeId];
        }
    }
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId
{
    BOOL successed = NO;
    if ( [ALIncentivizedInterstitialAd isReadyForDisplay] ) {
        // Show call if using a reward delegate.
        [ALIncentivizedInterstitialAd showAndNotify:self];
        successed = true;
        self.playingPlaceCode = placeCode;
        self.playingPlaceId = placeId;
    }
    return successed;
}

#pragma mark - ALAdDisplayDelegate
- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    // 用户点击关闭按钮，关闭广告
    if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.playingPlaceCode error:nil placeId:self.playingPlaceId];
    }
    
    if (self.isRewardUser && [self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:self.playingPlaceCode placeId:self.playingPlaceId];
    }
    self.isRewardUser = false;
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    
}

#pragma mark - ALAdRewardDelegate

- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response {
    self.isRewardUser = true;
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didExceedQuotaWithResponse:(NSDictionary *)response
{
    
}

- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response
{
    
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)adResponseCode {

}

#pragma mark - ALAdLoadDelegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.loadingPlaceCode error:nil placeId:self.loadingPlaceId];
    }
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    // 缓存广告成功或失败
    NSError *error = [NSError errorWithDomain:@"AppLovin.com"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey: @"AppLovin 激励广告加载失败"}];
    if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.loadingPlaceCode error:error placeId:self.loadingPlaceId];
    }
}


@end
