//
//  NLGoogleAdLoader.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleAdLoader.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "NLGoogleAdSplashView.h"
#import "NLGoogleAdBannerView.h"
#import "NLGoogleAdReadView.h"
#import "NLPlatformAdLoaderConfig.h"
#import "NLAdAttribute.h"
#import "NLAdModelProtocol.h"
#import "NLAdLog.h"

@interface NLGoogleAdLoader()<GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate, GADRewardedAdDelegate>

// 原生
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adLoaderDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *adViewDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NLAdAttribute *> *adAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *adViewValues;
@property (nonatomic, strong) NSMutableSet<NSString *> *invalidAdPlaceCodeSet;

// 激励
@property (nonatomic, strong) NSMutableDictionary<NSString *, GADRewardedAd *> *rewardAdPortraitDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, GADRewardedAd *> *rewardAdLandscapeDict;

@end

@implementation NLGoogleAdLoader

- (NSMutableDictionary<NSString *,NSObject *> *)adLoaderDict {
    if (_adLoaderDict == nil) {
        _adLoaderDict = [[NSMutableDictionary<NSString *, NSObject *> alloc] init];
    }
    return _adLoaderDict;
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
    static NLGoogleAdLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange:)
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadNativeAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    GADNativeAdMediaAdLoaderOptions *mediaAdLoaderOptions = [[GADNativeAdMediaAdLoaderOptions alloc] init];
    [mediaAdLoaderOptions setMediaAspectRatio:GADMediaAspectRatioPortrait];
    NSMutableArray *aptions = [NSMutableArray arrayWithObject:mediaAdLoaderOptions];
    if (placeCode == NLAdPlaceCodeNativeSplash || placeCode == NLAdPlaceCodeNativeNovelBottom || placeCode == NLAdPlaceCodeNativeComicBottom) {
        GADNativeAdViewAdOptions *adViewOptions = [[GADNativeAdViewAdOptions alloc] init];
        adViewOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomLeftCorner;
        [aptions addObject:adViewOptions];
    }
    
    GADAdLoader *nativeAdLoader = [[GADAdLoader alloc] initWithAdUnitID:placeId rootViewController:nil adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:aptions];
    nativeAdLoader.delegate = self;
    GADRequest *request = [GADRequest request];
    [nativeAdLoader loadRequest:request];
    
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

#pragma mark - GADAdLoaderDelegate

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:adLoader];
    NLAdLog(error.description, placeCode);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:error placeId:adLoader.adUnitID];
    }
}

- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadAdFinishedWithPlaceCode:error:placeId:)]) {
        NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:adLoader];
        [self.delegate adLoader:self loadAdFinishedWithPlaceCode:placeCode error:nil placeId:adLoader.adUnitID];
    }
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd {
    nativeAd.delegate = self;
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:adLoader];
    UIView *adView = nil;
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        NLGoogleAdSplashView *view = [NLGoogleAdSplashView createView];
        view.frame = [UIScreen mainScreen].bounds;
        [view setupAdModel:nativeAd];
        adView = view;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead || placeCode == NLAdPlaceCodeNativeComicRead) {
        NLGoogleAdReadView *view = [NLGoogleAdReadView createView];
        view.frame = CGRectMake(0, 0, 325, 310);
        [view setupAdModel:nativeAd];
        adView = view;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom || placeCode == NLAdPlaceCodeNativeComicBottom) {
        NLGoogleAdBannerView *view = [NLGoogleAdBannerView createView];
        view.frame = CGRectMake(0, 0, 320, 66);
        [view setupAdModel:nativeAd];
        adView = view;
    }
    if (adView != nil) {
        [self.adViewDict setObject:adView forKey:@(placeCode).stringValue];
        [self.invalidAdPlaceCodeSet removeObject:@(placeCode).stringValue];
    }
}

#pragma mark - Reward

- (NSMutableDictionary<NSString *,GADRewardedAd *> *)rewardAdPortraitDict {
    if (_rewardAdPortraitDict == nil) {
        _rewardAdPortraitDict = [[NSMutableDictionary<NSString *,GADRewardedAd *> alloc] init];
    }
    return _rewardAdPortraitDict;
}

- (NSMutableDictionary<NSString *,GADRewardedAd *> *)rewardAdLandscapeDict {
    if (_rewardAdLandscapeDict == nil) {
        _rewardAdLandscapeDict = [[NSMutableDictionary<NSString *,GADRewardedAd *> alloc] init];
    }
    return _rewardAdLandscapeDict;
}

- (NSMutableDictionary<NSString *,GADRewardedAd *> *)rewardAdObjectDict {
    if (![self isDeviceLandscape]) {
        return self.rewardAdPortraitDict;
    }
    return self.rewardAdLandscapeDict;
}

- (BOOL)isDeviceLandscape {
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}

- (void)startLoadRewardAdWithPlaceId:(NSString *)placeId placeCode:(NLAdPlaceCode)placeCode {
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:placeId];
    [self.adLoaderDict setObject:rewardedAd forKey:@(placeCode).stringValue];
    // 这么做是为了防止在加载的过程中旋转屏幕
    NSMutableDictionary<NSString *,GADRewardedAd *> *rewardAdObjectDict = self.rewardAdObjectDict;
    GADRequest *request = [GADRequest request];
    __weak typeof(self) weakSelf = self;
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError *_Nullable error) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil) {
            [strongSelf loadRewardAdFailedWithError:error placeCode:placeCode placeId:placeId];
        } else {
            [strongSelf loadRewardAdSuccessed:placeCode placeId:placeId];
            [rewardAdObjectDict setObject:rewardedAd forKey:placeId];
        }
    }];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdStartedWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdStartedWithPlaceCode:placeCode placeId:placeId];
    }
}

- (void)loadRewardAdSuccessed:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId  {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:nil placeId:placeId];
    }
}

- (void)loadRewardAdFailedWithError:(NSError *)error placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    NLAdLog(error.description, placeCode);
    [self.rewardAdObjectDict removeObjectForKey:placeId];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
    }
}

- (void)showRewardAdFailedWithError:(NSError *)error placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.rewardAdObjectDict removeObjectForKey:placeId];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:showRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self showRewardAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
    }
}

- (void)userDidEarnRewardWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.rewardAdObjectDict removeObjectForKey:placeId];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:placeCode placeId:placeId];
    }
}

#pragma mark - GADRewardedAdDelegate

- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedAd];
    [self userDidEarnRewardWithPlaceCode:placeCode placeId:rewardedAd.adUnitID];
}

- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NLAdPlaceCode placeCode = [self placeCodeWithAdLoader:rewardedAd];
    [self showRewardAdFailedWithError:error placeCode:placeCode placeId:rewardedAd.adUnitID];
}

- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"<------------> rewardedAdDidPresent");
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
     NSLog(@"<------------> rewardedAdDidDismiss");
}

#pragma mark - NotificationCenter

- (void)handleDeviceOrientationChange:(NSNotification *)notification {
    NSObject *rewardedAdObject = [self.adLoaderDict objectForKey:@(NLAdPlaceCodeRewardComicPrivilege).stringValue];
    if (rewardedAdObject != nil && [rewardedAdObject isKindOfClass:[GADRewardedAd class]]) {
        GADRewardedAd *rewardedAd = (GADRewardedAd *)rewardedAdObject;
        [self startLoadRewardAdWithPlaceId:rewardedAd.adUnitID placeCode:NLAdPlaceCodeRewardComicPrivilege];
    }
}

#pragma mark - GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordImpression:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdDidRecordImpression");
}

- (void)nativeAdDidRecordClick:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdDidRecordClick");
}

- (void)nativeAdWillPresentScreen:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdWillPresentScreen 1");
}

- (void)nativeAdWillDismissScreen:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdWillDismissScreen 2");
}

- (void)nativeAdDidDismissScreen:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdDidDismissScreen 3");
}

- (void)nativeAdWillLeaveApplication:(nonnull GADUnifiedNativeAd *)nativeAd {
    NSLog(@"nativeAdWillLeaveApplication 4");
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
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        NLGoogleAdSplashView *view = (NLGoogleAdSplashView *)adView;
        [view setAdConfig:attributes];
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead || placeCode == NLAdPlaceCodeNativeComicRead) {
        NLGoogleAdReadView *view = (NLGoogleAdReadView *)adView;
        [view setAdConfig:attributes];
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom || placeCode == NLAdPlaceCodeNativeComicBottom) {
        NLGoogleAdBannerView *view = (NLGoogleAdBannerView *)adView;
        [view setAdConfig:attributes];
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
        if (placeCode == NLAdPlaceCodeNativeSplash) {
            NLGoogleAdSplashView *view = (NLGoogleAdSplashView *)adView;
            [view setAdConfig:attributes];
        } else if (placeCode == NLAdPlaceCodeNativeNovelRead || placeCode == NLAdPlaceCodeNativeComicRead) {
            NLGoogleAdReadView *view = (NLGoogleAdReadView *)adView;
            [view setAdConfig:attributes];
        } else if (placeCode == NLAdPlaceCodeNativeNovelBottom || placeCode == NLAdPlaceCodeNativeComicBottom) {
            NLGoogleAdBannerView *view = (NLGoogleAdBannerView *)adView;
            [view setAdConfig:attributes];
        }
    }
}

- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    GADRewardedAd *object = [self.rewardAdObjectDict objectForKey:placeId];
    if (object == nil) {
        [self startLoadRewardAdWithPlaceId:placeId placeCode:placeCode];
    }
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(nonnull NSString *)placeId {
    GADRewardedAd *rewardedAdObject = [self.rewardAdObjectDict objectForKey:placeId];
    BOOL successed = NO;
    if (rewardedAdObject != nil) {
        NSError *error = nil;
        if (rewardedAdObject.ready && [rewardedAdObject canPresentFromRootViewController:viewController error:&error]) {
            [rewardedAdObject presentFromRootViewController:viewController delegate:self];
            successed = YES;
        } else {
            [self showRewardAdFailedWithError:error placeCode:placeCode placeId:placeId];
            [self.rewardAdObjectDict removeObjectForKey:placeId];
        }
    }
    return successed;
}

@end
