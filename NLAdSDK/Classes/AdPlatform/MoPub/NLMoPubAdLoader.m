//
//  NLMoPubAdLoader.m
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLMoPubAdLoader.h"
#import <MoPub/MoPub.h>
#import "NLPlatformAdLoaderConfig.h"
#import "NLAdAttribute.h"
#import "NLAdLog.h"
#import "NLMoPubAdSplashView.h"
#import "NLMoPubAdBannerView.h"
#import "NLMoPubAdReadView.h"

@interface NLMoPubAdLoader () <MPNativeAdDelegate, MPRewardedVideoDelegate>
// 原生
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adLoaderDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adObjectDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *adViewDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NLAdAttribute *> *adAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *adViewValues;
@property (nonatomic, strong) NSMutableSet<NSString *> *invalidAdPlaceCodeSet;

// 激励
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *rewardAdLoadPlaceIdDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *rewardAdShowPlaceIdDict;
@end

@implementation NLMoPubAdLoader

- (NSMutableDictionary<NSString *,NSObject *> *)adLoaderDict {
    if (_adLoaderDict == nil) {
        _adLoaderDict = [[NSMutableDictionary<NSString *, NSObject *> alloc] init];
    }
    return _adLoaderDict;
}

- (NSMutableDictionary<NSString *,NSObject *> *)adObjectDict {
    if (_adObjectDict == nil) {
        _adObjectDict = [[NSMutableDictionary<NSString *, NSObject *> alloc] init];
    }
    return _adObjectDict;
}

- (NSMutableDictionary<NSString *,UIView *> *)adViewDict {
    if (_adViewDict == nil) {
        _adViewDict = [[NSMutableDictionary<NSString *, UIView *> alloc] init];
    }
    return _adViewDict;
}

- (NSMutableDictionary<NSString *,NLAdAttribute *> *)adAttributes {
    if (_adAttributes == nil) {
        _adAttributes = [[NSMutableDictionary<NSString *,NLAdAttribute *> alloc] init];
    }
    return _adAttributes;
}
- (NSMutableDictionary<NSString *,NSValue *> *)adViewValues {
    if (_adViewValues == nil) {
        _adViewValues = [[NSMutableDictionary<NSString *,NSValue *> alloc] init];
    }
    return _adViewValues;
}

- (NSMutableSet<NSString *> *)invalidAdPlaceCodeSet {
    if (_invalidAdPlaceCodeSet == nil) {
        _invalidAdPlaceCodeSet = [[NSMutableSet<NSString *> alloc] init];
    }
    return _invalidAdPlaceCodeSet;
}

+ (instancetype)sharedLoader {
    static NLMoPubAdLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (void)sdkInitializeWithPlaceId:(NSString *)placeId completion:(void(^_Nullable)(void))completionBlock {
    if ([MoPub sharedInstance].isSdkInitialized) {
        completionBlock();
    } else {
        MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:placeId];
        sdkConfig.loggingLevel = MPBLogLevelInfo;
        [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:completionBlock];
    }
}

- (void)loadNativeAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    Class class = nil;
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        class = NLMoPubAdSplashView.class;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead || placeCode == NLAdPlaceCodeNativeNovelRead) {
        class = NLMoPubAdReadView.class;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom || placeCode == NLAdPlaceCodeNativeNovelBottom) {
        class = NLMoPubAdBannerView.class;
    } else {
        NSAssert(0, @"placeCode error");
    }
    @weakify(self);
    [self sdkInitializeWithPlaceId:placeId completion:^{
        @strongify(self);
        MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
        settings.renderingViewClass = class;
        MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
        MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:placeId rendererConfigurations:@[config]];
         MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
         targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, nil]; //The constants correspond to the 6 elements of MoPub native ads
        adRequest.targeting = targeting;
        [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
            if (error) {
                NLAdLog(error.description, placeCode);
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
                    [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
                }
            } else {
                response.delegate = self;
                NSError *error = nil;
                UIView *adView = [response retrieveAdViewWithError:&error];
                if (adView == nil || error != nil) {
                    NLAdLog(error.description, placeCode);
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
                        if (error == nil) {
                            error = [NSError errorWithDomain:@"retrieveAdViewError" code:-1 userInfo:nil];
                        }
                        [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
                    }
                    return;
                }
                adView.frame = [UIScreen mainScreen].bounds;
                for (NLMoPubNativeAdView *subView in adView.subviews) {
                    if ([subView isKindOfClass:NLMoPubAdSplashView.class]) {
                        [subView setupViews];
                    }
                }
                
                [self.adObjectDict setObject:response forKey:@(placeCode).stringValue];
                [self.adViewDict setObject:adView forKey:@(placeCode).stringValue];
                [self.invalidAdPlaceCodeSet removeObject:@(placeCode).stringValue];
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
                    [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:nil placeId:placeId];
                }
            }
        }];
        
        [self.adLoaderDict setObject:adRequest forKey:@(placeCode).stringValue];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdStartedWithPlaceCode:placeId:)]) {
            [self.delegate adLoader:self loadAdStartedWithPlaceCode:placeCode placeId:placeId];
        }
    }];
}

- (NLAdPlaceCode)placeCodeWithAdLoader:(NSObject *)adLoader {
    NLAdPlaceCode placeCode = NLAdPlaceCodeUnknow;
    if ([self.adLoaderDict.allValues containsObject:adLoader]) {
        NSArray<NSString *> *keys = [self.adLoaderDict allKeysForObject:adLoader];
        placeCode = [keys.lastObject integerValue];
    }
    return placeCode;
}

#pragma mark - MPNativeAdDelegate

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"willPresentModalForNativeAd");
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"didDismissModalForNativeAd");
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"willLeaveApplicationFromNativeAd");
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [self.class topViewController];
}

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self.class topViewController:rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self topViewController:viewController.presentedViewController];
        
    } else if([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *) viewController;
        return [self topViewController:navigationController.visibleViewController];
        
    } else if([viewController isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self topViewController:tabBarController.selectedViewController];
        
    } else {
        return viewController;
    }
}

#pragma mark - Reward

- (NSMutableDictionary<NSString *,NSString *> *)rewardAdLoadPlaceIdDict {
    if (_rewardAdLoadPlaceIdDict == nil) {
        _rewardAdLoadPlaceIdDict = [[NSMutableDictionary<NSString *,NSString *> alloc] init];
    }
    return _rewardAdLoadPlaceIdDict;
}

- (NSMutableDictionary<NSString *,NSString *> *)rewardAdShowPlaceIdDict {
    if (_rewardAdShowPlaceIdDict == nil) {
        _rewardAdShowPlaceIdDict = [[NSMutableDictionary<NSString *,NSString *> alloc] init];
    }
    return _rewardAdShowPlaceIdDict;
}

- (void)startLoadRewardAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    @weakify(self);
    [self sdkInitializeWithPlaceId:placeId completion:^{
        @strongify(self);
        [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:placeId withMediationSettings:nil];
        [MPRewardedVideo setDelegate:self forAdUnitId:placeId];

        [self.rewardAdLoadPlaceIdDict setObject:@(placeCode).stringValue forKey:placeId];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdStartedWithPlaceCode:placeId:)]) {
            [self.delegate adLoader:self loadRewardAdStartedWithPlaceCode:placeCode placeId:placeId];
        }
    }];
}

- (void)showRewardAdFailedWithError:(NSError *)error placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.rewardAdLoadPlaceIdDict removeObjectForKey:placeId];
    [self.rewardAdShowPlaceIdDict removeObjectForKey:placeId];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:showRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self showRewardAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
    }
}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdDidLoadForAdUnitID");
    NLAdPlaceCode placeCode = [[self.rewardAdLoadPlaceIdDict objectForKey:adUnitID] integerValue];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:nil placeId:adUnitID];
    }
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewardedVideoAdDidFailToLoadForAdUnitID");
    NLAdPlaceCode placeCode = [[self.rewardAdLoadPlaceIdDict objectForKey:adUnitID] integerValue];
    NLAdLog(error.description, placeCode);
    [self.rewardAdLoadPlaceIdDict removeObjectForKey:adUnitID];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:error placeId:adUnitID];
    }
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdDidExpireForAdUnitID");
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewardedVideoAdDidFailToPlayForAdUnitID");
    NLAdPlaceCode placeCode = [[self.rewardAdShowPlaceIdDict objectForKey:adUnitID] integerValue];
    [self showRewardAdFailedWithError:error placeCode:placeCode placeId:adUnitID];
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdWillAppearForAdUnitID");
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdDidAppearForAdUnitID");
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdWillDisappearForAdUnitID");
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdDidDisappearForAdUnitID");
    [self.rewardAdLoadPlaceIdDict removeObjectForKey:adUnitID];
    NLAdPlaceCode placeCode = [[self.rewardAdShowPlaceIdDict objectForKey:adUnitID] integerValue];
    [self.rewardAdShowPlaceIdDict removeObjectForKey:adUnitID];
    [self showRewardAdFailedWithError:nil placeCode:placeCode placeId:adUnitID];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdDidReceiveTapEventForAdUnitID");
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedVideoAdWillLeaveApplicationForAdUnitID");
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"rewardedVideoAdShouldRewardForAdUnitID");
    NLAdPlaceCode placeCode = [[self.rewardAdShowPlaceIdDict objectForKey:adUnitID] integerValue];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:placeCode placeId:adUnitID];
    }
}

- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData {
    NSLog(@"didTrackImpressionWithAdUnitID");
}

#pragma mark - public

- (void)loadAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    if (adView == nil || [self.invalidAdPlaceCodeSet containsObject:@(placeCode).stringValue]) {
        [self loadNativeAdWithPlaceId:placeId placeCode:placeCode];
    }
}

- (BOOL)hasAdWithPlaceCode:(NLAdPlaceCode)placeCode {
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    return adView != nil;
}

- (nullable UIView *)adViewWithPlaceCode:(NLAdPlaceCode)placeCode {
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    if (placeCode == NLAdPlaceCodeNativeNovelRead || placeCode == NLAdPlaceCodeNativeComicRead) {
        [self.invalidAdPlaceCodeSet addObject:@(placeCode).stringValue];
    } else {
        [self.adViewDict removeObjectForKey:@(placeCode).stringValue];
    }
    NLAdAttribute *attributes = [self.adAttributes objectForKey:@(placeCode).stringValue];
    for (NLMoPubNativeAdView *subView in adView.subviews) {
        if ([subView isKindOfClass:NLMoPubNativeAdView.class]) {
            [subView setAdConfig:attributes];
        }
    }
    NSValue *value = [NSValue valueWithNonretainedObject:adView];
    [self.adViewValues setObject:value forKey:@(placeCode).stringValue];
    return adView;
}

- (void)setAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode {
    [self.adAttributes setObject:attributes forKey:@(placeCode).stringValue];
    NSValue *viewValue = [self.adViewValues objectForKey:@(placeCode).stringValue];
    UIView *adView = [viewValue nonretainedObjectValue];
    if (adView != nil) {
        for (NLMoPubNativeAdView *subView in adView.subviews) {
            if ([subView isKindOfClass:NLMoPubNativeAdView.class]) {
                [subView setAdConfig:attributes];
            }
        }
    }
}

- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    if (![self.rewardAdLoadPlaceIdDict.allKeys containsObject:placeId]) {
        [self startLoadRewardAdWithPlaceId:placeId placeCode:placeCode];
    }
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    BOOL successed = NO;
    MPRewardedVideoReward *reward = [MPRewardedVideo selectedRewardForAdUnitID:placeId];
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:placeId], reward != nil) {
        [self.rewardAdShowPlaceIdDict setObject:@(placeCode).stringValue forKey:placeId];
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:placeId fromViewController:viewController withReward:reward];
        successed = YES;
    }
    return successed;
}

@end
