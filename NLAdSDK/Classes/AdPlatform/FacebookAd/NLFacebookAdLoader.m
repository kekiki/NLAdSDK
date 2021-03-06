//
//  NLFacebookAdLoader.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookAdLoader.h"
#import "NLFacebookAdSplashView.h"
#import "NLFacebookAdBannerView.h"
#import "NLFacebookAdReadView.h"
#import "NLPlatformAdLoaderConfig.h"
#import "NLAdAttribute.h"
#import "NLReadAdObject.h"
@import FBAudienceNetwork;

@interface NLFacebookAdLoader() <FBNativeAdDelegate, FBRewardedVideoAdDelegate>

// 原生
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adLoaderDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adObjectDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *adViewDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NLAdAttribute *> *adAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *adViewValues;
@property (nonatomic, strong) NSMutableSet<NSString *> *invalidAdPlaceCodeSet;

// 激励
@property (nonatomic, strong) NSMutableDictionary<NSString *, FBRewardedVideoAd *> *rewardAdObjectDict;
@property (nonatomic, strong) FBRewardedVideoAd *playingRewardAd;
@property (nonatomic, assign) BOOL isRewardUser;
@end

@implementation NLFacebookAdLoader

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
    static NLFacebookAdLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (void)loadNativeAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    FBNativeAd *nativeAdLoader = [[FBNativeAd alloc] initWithPlacementID:placeId];
    nativeAdLoader.delegate = self;
    [nativeAdLoader loadAd];
    
    [self.adLoaderDict setObject:nativeAdLoader forKey:@(placeCode).stringValue];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdStartedWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self loadAdStartedWithPlaceCode:placeCode placeId:placeId];
    }
}

- (NLAdPlaceCode)placeCodeWithAdLoader:(NSObject *)adLoader {
    NLAdPlaceCode placeCode = NLAdPlaceCodeUnknow;
    if ([self.adLoaderDict.allValues containsObject:adLoader]) {
        NSArray<NSString *> *keys = [self.adLoaderDict allKeysForObject:adLoader];
        placeCode = [keys.lastObject integerValue];
    }
    return placeCode;
}

#pragma mark - FBNativeAdDelegate

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:nativeAd];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:error placeId:nativeAd.placementID];
    }
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:nativeAd];
    
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        NLFacebookAdSplashView *view = [NLFacebookAdSplashView createView];
        view.frame = [UIScreen mainScreen].bounds;
        [view setupAdModel:nativeAd];
        [self.adViewDict setObject:view forKey:@(placeCode).stringValue];
        [self.invalidAdPlaceCodeSet removeObject:@(placeCode).stringValue];
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead
               || placeCode == NLAdPlaceCodeNativeComicRead) {
        NLReadAdObject *object = [[NLReadAdObject alloc] initWithPlaceCode:placeCode adPlatform:NLAdPlatformFacebook adObject:nativeAd];
        [self.adObjectDict setObject:object forKey:@(placeCode).stringValue];
        [self.invalidAdPlaceCodeSet removeObject:@(placeCode).stringValue];
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom
               || placeCode == NLAdPlaceCodeNativeComicBottom) {
        NLFacebookAdBannerView *view = [NLFacebookAdBannerView createView];
        view.frame = CGRectMake(0, 0, 320, 66);
        [view setupAdModel:nativeAd];
        [self.adViewDict setObject:view forKey:@(placeCode).stringValue];
        [self.invalidAdPlaceCodeSet removeObject:@(placeCode).stringValue];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:nil placeId:nativeAd.placementID];
    }
}

#pragma mark - Reward

- (NSMutableDictionary<NSString *,FBRewardedVideoAd *> *)rewardAdObjectDict {
    if (_rewardAdObjectDict == nil) {
        _rewardAdObjectDict = [[NSMutableDictionary<NSString *,FBRewardedVideoAd *> alloc] init];
    }
    return _rewardAdObjectDict;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)showApplicationStatusBar {
    [self setStatusBarHidden:false];
}

- (void)setStatusBarHidden:(BOOL)hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}

#pragma GCC diagnostic pop

- (void)startLoadRewardAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    FBRewardedVideoAd *rewardedVideoAd = [[FBRewardedVideoAd alloc] initWithPlacementID:placeId];
    rewardedVideoAd.delegate = self;
    [rewardedVideoAd loadAd];
    
    [self.adLoaderDict setObject:rewardedVideoAd forKey:@(placeCode).stringValue];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdStartedWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdStartedWithPlaceCode:placeCode placeId:placeId];
    }
}

- (void)showRewardAdFinishWithError:(NSError *)error placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.rewardAdObjectDict removeObjectForKey:placeId];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:showRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self showRewardAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
    }
}

#pragma mark - FBRewardedVideoAdDelegate

- (void)rewardedVideoAdDidClick:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdDidClick");
}

- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdDidLoad");
    [self.rewardAdObjectDict setObject:rewardedVideoAd forKey:rewardedVideoAd.placementID];
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedVideoAd];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:nil placeId:rewardedVideoAd.placementID];
    }
}

- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdDidClose");
    [self showApplicationStatusBar];
    
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedVideoAd];
    [self showRewardAdFinishWithError:nil placeCode:placeCode placeId:rewardedVideoAd.placementID];
    
    if (self.isRewardUser && self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
        NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedVideoAd];
        [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:placeCode placeId:rewardedVideoAd.placementID];
    }
    
    self.isRewardUser = false;
}

- (void)rewardedVideoAdWillClose:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdWillClose");
}

- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"rewardedVideoAd:didFailWithError");
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedVideoAd];
    [self.rewardAdObjectDict removeObjectForKey:rewardedVideoAd.placementID];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:error placeId:rewardedVideoAd.placementID];
    }
}

- (void)rewardedVideoAdVideoComplete:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdVideoComplete");
    self.isRewardUser = true;
}

- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdWillLogImpression");
}

- (void)rewardedVideoAdServerRewardDidSucceed:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdServerRewardDidSucceed");
}

- (void)rewardedVideoAdServerRewardDidFail:(FBRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewardedVideoAdServerRewardDidFail");
}

#pragma mark - public

- (void)loadAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    if (adView == nil || [self.invalidAdPlaceCodeSet containsObject:@(placeCode).stringValue]) {
        [self loadNativeAdWithPlaceId:placeId placeCode:placeCode];
    }
}

- (BOOL)hasAdWithPlaceCode:(NLAdPlaceCode)placeCode {
    if (placeCode == NLAdPlaceCodeNativeNovelRead
        || placeCode == NLAdPlaceCodeNativeComicRead) {
        NSObject *object = [self.adObjectDict objectForKey:@(placeCode).stringValue];
        return object != nil;
    }
    
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    return adView != nil;
}

- (nullable UIView *)adViewWithPlaceCode:(NLAdPlaceCode)placeCode {
    [self.invalidAdPlaceCodeSet addObject:@(placeCode).stringValue];
    UIView *adView = [self.adViewDict objectForKey:@(placeCode).stringValue];
    
    NLAdAttribute *attributes = [self.adAttributes objectForKey:@(placeCode).stringValue];
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        NLFacebookAdSplashView *view = (NLFacebookAdSplashView *)adView;
        [view setAdConfig:attributes];
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom
               || placeCode == NLAdPlaceCodeNativeComicBottom) {
        NLFacebookAdBannerView *view = (NLFacebookAdBannerView *)adView;
        [view setAdConfig:attributes];
    }
    NSValue *value = [NSValue valueWithNonretainedObject:adView];
    [self.adViewValues setObject:value forKey:@(placeCode).stringValue];
    return adView;
}

- (void)setAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode {
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        [self.adAttributes setObject:attributes forKey:@(placeCode).stringValue];
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom
               || placeCode == NLAdPlaceCodeNativeComicBottom) {
        [self.adAttributes setObject:attributes forKey:@(NLAdPlaceCodeNativeNovelBottom).stringValue];
        [self.adAttributes setObject:attributes forKey:@(NLAdPlaceCodeNativeComicBottom).stringValue];
    }
    
    NSValue *viewValue = [self.adViewValues objectForKey:@(placeCode).stringValue];
    NLFacebookNativeAdView *adView = [viewValue nonretainedObjectValue];
    if (adView != nil && [adView isKindOfClass:NLFacebookNativeAdView.class]) {
        [adView setAdConfig:attributes];
    }
}

- (__kindof NSObject *)readAdObjectWithPlaceCode:(NLAdPlaceCode)placeCode {
    [self.invalidAdPlaceCodeSet addObject:@(placeCode).stringValue];
    return [self.adObjectDict objectForKey:@(placeCode).stringValue];
}

- (BOOL)hasRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    FBRewardedVideoAd *rewardedAdObject = [self.rewardAdObjectDict objectForKey:placeId];
    return rewardedAdObject != nil && rewardedAdObject.isAdValid;
}

- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    FBRewardedVideoAd *object = [self.rewardAdObjectDict objectForKey:placeId];
    if (object == nil) {
        [self startLoadRewardAdWithPlaceId:placeId placeCode:placeCode];
    }
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {

    FBRewardedVideoAd *rewardedAdObject = [self.rewardAdObjectDict objectForKey:placeId];
    BOOL successed = NO;
    if (rewardedAdObject != nil) {
        if (rewardedAdObject.isAdValid) {
            successed = [rewardedAdObject showAdFromRootViewController:viewController];
            self.playingRewardAd = rewardedAdObject;
            [self.rewardAdObjectDict removeObjectForKey:placeId];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setStatusBarHidden:true];
            });
        } else {
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-1 userInfo:nil];
            [self showRewardAdFinishWithError:error placeCode:placeCode placeId:placeId];
        }
    }
    
    if (successed) {
        [self setStatusBarHidden:true];
    }
    
    return successed;
}

@end
