//
//  NLAdDispatchManager.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdDispatchManager.h"
#import "NLAdAdapter.h"
#import "NLPlatformAdLoaderDelegate.h"
#import "NLPlatformAdLoaderConfig.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>

static NSInteger const kReadBottomAdViewTag = 1001;
static NSInteger const kReadBottomAdPlaceholderViewTag = 1002;

@interface NLAdDispatchManager () <NLPlatformAdLoaderDelegate>

@property (nonatomic, strong) NLAdAdapter *adAdapter;
@property (nonatomic, strong) UIView *readBottomAdContainerView;
@property (nonatomic, strong) NSMutableDictionary *adLoadCompletionDict;
@property (nonatomic, strong) NSMutableSet *adLoadFailedSet;
@property (nonatomic, strong) NSMutableSet *adPlaceCodeLoadingSet;
@property (nonatomic, strong) NSTimer *readBottomAdTimer;

@property (nonatomic, assign) BOOL rewardAdIsPlaying;
@property (nonatomic, strong) NSMutableDictionary *rewardAdLoadCompletionDict;
@property (nonatomic, strong) NSMutableDictionary *rewardAdEarnRewardDict;
@property (nonatomic, strong) NSMutableSet *adRewardPlaceIdLoadingSet;
@property (nonatomic, weak) UIViewController *rewardAdViewController;

@end

@implementation NLAdDispatchManager

+ (instancetype)sharedManager {
    static NLAdDispatchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NLAdAdapter *)adAdapter {
    if (_adAdapter == nil) {
        _adAdapter = [[NLAdAdapter alloc] init];
    }
    return _adAdapter;
}

- (UIView *)readBottomAdContainerView {
    if (_readBottomAdContainerView == nil) {
        _readBottomAdContainerView = [[UIView alloc] init];
        _readBottomAdContainerView.clipsToBounds = YES;
    }
    return _readBottomAdContainerView;
}

- (NSMutableDictionary *)adLoadCompletionDict {
    if (_adLoadCompletionDict == nil) {
        _adLoadCompletionDict = [[NSMutableDictionary alloc] init];
    }
    return _adLoadCompletionDict;
}

- (NSMutableDictionary *)rewardAdLoadCompletionDict {
    if (_rewardAdLoadCompletionDict == nil) {
        _rewardAdLoadCompletionDict = [[NSMutableDictionary alloc] init];
    }
    return _rewardAdLoadCompletionDict;
}

- (NSMutableDictionary *)rewardAdEarnRewardDict {
    if (_rewardAdEarnRewardDict == nil) {
        _rewardAdEarnRewardDict = [[NSMutableDictionary alloc] init];
    }
    return _rewardAdEarnRewardDict;
}

- (NSMutableSet *)adLoadFailedSet {
    if (_adLoadFailedSet == nil) {
        _adLoadFailedSet = [[NSMutableSet alloc] init];
    }
    return _adLoadFailedSet;
}

- (NSMutableSet *)adPlaceCodeLoadingSet {
    if (_adPlaceCodeLoadingSet == nil) {
        _adPlaceCodeLoadingSet = [[NSMutableSet alloc] init];
    }
    return _adPlaceCodeLoadingSet;
}

- (NSMutableSet *)adRewardPlaceIdLoadingSet {
    if (_adRewardPlaceIdLoadingSet == nil) {
        _adRewardPlaceIdLoadingSet = [[NSMutableSet alloc] init];
    }
    return _adRewardPlaceIdLoadingSet;
}

- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems {
    [self.adAdapter setupPlaceItems:placeItems];
}

- (id<NLPlatformAdLoaderProtocol>)adLoaderWithPlaceCode:(NLAdPlaceCode)placeCode {
    NSInteger adPlatform = [self.adAdapter platformWithCode:placeCode];
    id<NLPlatformAdLoaderProtocol> adLoader = [[NLPlatformAdLoaderConfig adLoaderList] objectForKey:@(adPlatform)];
    adLoader.delegate = self;
    return adLoader;
}

- (void)loadNativeAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:(void(^)(BOOL successed))completion {
    if (completion != nil) {
        [self.adLoadCompletionDict setObject:completion forKey:@(placeCode).stringValue];
    }
    if ([self.adPlaceCodeLoadingSet containsObject:@(placeCode).stringValue]) {
        return; //正在加载中...
    }
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    NSString *placeId = [self.adAdapter placeIdWithCode:placeCode];
    [adLoader loadAdWithPlaceCode:placeCode placeId:placeId];
}

- (BOOL)hasNativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode {
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    BOOL hasAd = [adLoader hasAdWithPlaceCode:placeCode];
    if (!hasAd) {
        [self loadNativeAdWithPlaceCode:placeCode completion:nil];
    }
    return hasAd;
}

- (BOOL)isReadBottomNativeAdWithPlaceCode:(NLAdPlaceCode)placeCode {
    return placeCode == NLAdPlaceCodeNativeNovelBottom
    || placeCode == NLAdPlaceCodeNativeComicBottom;
}

- (UIView *)nativeAdViewWithPlaceCode:(NLAdPlaceCode)placeCode {
    if ([self isReadBottomNativeAdWithPlaceCode:placeCode]) {
        if ([self.readBottomAdTimer isValid]) {
            [self.readBottomAdTimer invalidate];
            self.readBottomAdTimer = nil;
        }

        for (UIView *subView in self.readBottomAdContainerView.subviews) {
            [subView removeFromSuperview];
        }
        self.readBottomAdContainerView.frame = CGRectMake(0, 0, 320, 66);
        id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
        UIView *bannerAdView = [adLoader adViewWithPlaceCode:placeCode];
        if (bannerAdView != nil) {
            bannerAdView.frame = self.readBottomAdContainerView.bounds;
            bannerAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            bannerAdView.tag = kReadBottomAdViewTag;
            [self.readBottomAdContainerView addSubview:bannerAdView];
        } else {
            UIImageView *placeholderView = [[UIImageView alloc] init];
            placeholderView.frame = self.readBottomAdContainerView.bounds;
            placeholderView.contentMode = UIViewContentModeCenter;
            placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            placeholderView.tag = kReadBottomAdPlaceholderViewTag;
            [self.readBottomAdContainerView addSubview:placeholderView];
        }
        
        //自动更换
        self.readBottomAdTimer = [NSTimer timerWithTimeInterval:kReadBottomAdRefreshTime target:self selector:@selector(startAutoChangeReadBottomAdWithPlaceCode:) userInfo:@{@"placeCode": @(placeCode)} repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.readBottomAdTimer forMode:NSRunLoopCommonModes];
        
        return self.readBottomAdContainerView;
    } else {
        id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
        UIView *adView = [adLoader adViewWithPlaceCode:placeCode];
        adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        adView.frame = [UIScreen mainScreen].bounds;
        [self loadNativeAdWithPlaceCode:placeCode completion:nil];
        return adView;
    }
}

- (void)setNativeAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode {
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    [adLoader setAdAttributes:attributes placeCode:placeCode];
    if ([self isReadBottomNativeAdWithPlaceCode:placeCode]) {
        if (attributes.placeholderImage != nil) {
            UIImageView *placeholderView = [self.readBottomAdContainerView viewWithTag:kReadBottomAdPlaceholderViewTag];
            if (placeholderView != nil) {
                placeholderView.image = attributes.placeholderImage;
            }
        }
    }
}

- (__kindof NSObject *)readAdObjectWithPlaceCode:(NLAdPlaceCode)placeCode {
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    __kindof NSObject *adObject = [adLoader readAdObjectWithPlaceCode:placeCode];
    [self loadNativeAdWithPlaceCode:placeCode completion:nil];
    return adObject;
}

- (void)startAutoChangeReadBottomAdWithPlaceCode:(NSTimer *)timer {
    if (self.readBottomAdContainerView.superview == nil) {
        [timer invalidate];
        return;
    }
    NSNumber *placeCode = [timer.userInfo objectForKey:@"placeCode"];
    if (placeCode != nil) {
        [self changeReadBottomAd:placeCode];
        [self loadNativeAdWithPlaceCode:placeCode.integerValue completion:nil];
    }
}

- (void)changeReadBottomAd:(NSNumber *)placeCode {

    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode.integerValue];
    UIView *topView = [adLoader adViewWithPlaceCode:placeCode.integerValue];
    if (topView == nil) {
        return;
    }
    CGRect topFrame = self.readBottomAdContainerView.bounds;
    topFrame.origin.y -= topFrame.size.height;
    topView.frame = topFrame;
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.readBottomAdContainerView addSubview:topView];
    
    UIView *bottomView = [self.readBottomAdContainerView viewWithTag:kReadBottomAdViewTag];
    if (bottomView == nil) {
        bottomView = [self.readBottomAdContainerView viewWithTag:kReadBottomAdPlaceholderViewTag];
    }
    CGRect bottomframe = self.readBottomAdContainerView.bounds;
    bottomframe.origin.y += bottomframe.size.height;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        topView.frame = self.readBottomAdContainerView.bounds;
        bottomView.frame = bottomframe;
    } completion:^(BOOL finished) {
        [bottomView removeFromSuperview];
        topView.tag = kReadBottomAdViewTag;
    }];
}

#pragma mark - NLPlatformAdLoaderDelegate

- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadAdStartedWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.adPlaceCodeLoadingSet addObject:@(placeCode).stringValue];
}

- (void)adLoader:(nonnull id<NLPlatformAdLoaderProtocol>)manager loadAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(nonnull NSString *)placeId {
    
    [self.adPlaceCodeLoadingSet removeObject:@(placeCode).stringValue];
    void(^completion)(BOOL successed) = [self.adLoadCompletionDict objectForKey:@(placeCode).stringValue];
    if (completion != nil) { completion(error == nil); }
    if ([self.adLoadCompletionDict.allKeys containsObject:@(placeCode).stringValue]) {
        [self.adLoadCompletionDict removeObjectForKey:@(placeCode).stringValue];
    }
    
    if (error != nil) {
        [self.adLoadFailedSet addObject:placeId];
        [self.adAdapter switchToNextWithCode:placeCode];
        NSString *pid = [self.adAdapter placeIdWithCode:placeCode];
        if (!pid || [self.adLoadFailedSet containsObject:pid]) {
            return;
        }
        [self loadNativeAdWithPlaceCode:pid completion:nil];
    } else {
        [self.adLoadFailedSet removeObject:placeId];
    }
}

- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadRewardAdStartedWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    [self.adRewardPlaceIdLoadingSet addObject:placeId];
}

- (void)adLoader:(nonnull id<NLPlatformAdLoaderProtocol>)manager loadRewardAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(nonnull NSString *)placeId {
    
    [self.adRewardPlaceIdLoadingSet removeObject:placeId];
    void(^completion)(BOOL successed) = [self.rewardAdLoadCompletionDict objectForKey:placeId];
    if (completion != nil) { completion(error == nil); }
    if ([self.rewardAdLoadCompletionDict.allKeys containsObject:placeId]) {
        [self.rewardAdLoadCompletionDict removeObjectForKey:placeId];
    }
    
    self.rewardAdIsPlaying = NO;
    if (error != nil) {
        void(^rewardAdEarnReward)(NSError *) = [self.rewardAdEarnRewardDict objectForKey:placeId];
        if (rewardAdEarnReward) { rewardAdEarnReward(error); }
        if ([self.rewardAdEarnRewardDict.allKeys containsObject:placeId]) {
            [self.rewardAdEarnRewardDict removeObjectForKey:placeId];
        }
    }
    
    if (error != nil) {
        [self.adAdapter switchToNextWithCode:placeCode];
        if ([self.adLoadFailedSet containsObject:placeId]) {
            return;
        }
        [self.adLoadFailedSet addObject:placeId];
        [self loadRewardAdWithPlaceCode:placeCode completion:nil];
    } else {
        [self.adLoadFailedSet removeObject:placeId];
    }
}

- (void)adLoader:(nonnull id<NLPlatformAdLoaderProtocol>)manager showRewardAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(nonnull NSString *)placeId {
    self.rewardAdIsPlaying = NO;
    if (placeCode != NLAdPlaceCodeUnknow && placeId.length > 0) {
        [self loadRewardAdWithPlaceCode:placeCode completion:nil];
    }
}

- (void)adLoader:(nonnull id<NLPlatformAdLoaderProtocol>)manager userDidEarnRewardWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(nonnull NSString *)placeId {
    dispatch_async(dispatch_get_main_queue(), ^{
        @weakify(self);
        if (self.rewardAdViewController.presentedViewController) {
            [self.rewardAdViewController.presentedViewController dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                [self dismissAndRewardWithPlaceCode:placeCode placeId:placeId];
            }];
        } else {
            [self dismissAndRewardWithPlaceCode:placeCode placeId:placeId];
        }
       
    });
}

- (void)dismissAndRewardWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(nonnull NSString *)placeId {
    self.rewardAdIsPlaying = NO;
    void(^rewardAdEarnReward)(NSError *) = [self.rewardAdEarnRewardDict objectForKey:placeId];
    if (rewardAdEarnReward) { rewardAdEarnReward(nil); }
    if ([self.rewardAdEarnRewardDict.allKeys containsObject:placeId]) {
        [self.rewardAdEarnRewardDict removeObjectForKey:placeId];
    }
}

- (BOOL)isRewardAdPlaying {
    return self.rewardAdIsPlaying;
}

/// 加载激励广告
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode completion:(nullable void(^)(BOOL successed))completion {
    NSString *placeId = [self.adAdapter placeIdWithCode:placeCode];
    if (completion != nil) {
        [self.adLoadCompletionDict setObject:completion forKey:placeId];
    }
    if ([self.adRewardPlaceIdLoadingSet containsObject:placeId]) {
        return; //正在加载中
    }
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    [adLoader loadRewardAdWithPlaceCode:placeCode placeId:placeId];
}

/// 显示激励广告
/// @param viewController 激励广告下面的视图控制器
/// @param block 用户看完激励视频回调
/// @return 是否present成功开始播放，返回false正常情况是激励视频加载失败了，会重新加载
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController
                              placeCode:(NLAdPlaceCode)placeCode
                 userDidEarnRewardBlock:(nullable void(^)(NSError * _Nullable error))block {
    self.rewardAdViewController = viewController;
    NSString *placeId = [self.adAdapter placeIdWithCode:placeCode];
    if (block != nil) {
        [self.rewardAdEarnRewardDict setObject:block forKey:placeId];
    }
    id<NLPlatformAdLoaderProtocol> adLoader = [self adLoaderWithPlaceCode:placeCode];
    BOOL successed = [adLoader presentRewardAdInViewController:viewController placeCode:placeCode placeId:placeId];
    self.rewardAdIsPlaying = successed;
    [self loadRewardAdWithPlaceCode:placeCode completion:nil];
    return successed;
}

@end
