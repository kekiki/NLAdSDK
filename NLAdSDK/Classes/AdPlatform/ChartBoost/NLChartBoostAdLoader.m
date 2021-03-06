//
//  NLChartBoostAdLoader.m
//  Novel
//
//  Created by Ray Tao on 2020/9/22.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLChartBoostAdLoader.h"
#import <Chartboost/Chartboost.h>

@interface NLChartBoostAdLoader ()<CHBRewardedDelegate>
/// key placecode value 广告id
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *adPlaceCodeIdDict;
/// key placeid value 激励广告
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<CHBAd>> *adRewardDict;
@property (nonatomic, assign) BOOL startSuccess;
@property (nonatomic, assign) BOOL isRewardUser;
@property (nonatomic, assign) NLAdPlaceCode loadingPlaceCode;
@property (nonatomic, strong) CHBRewarded *playingRewarded;
@end

@implementation NLChartBoostAdLoader

+ (instancetype)sharedLoader {
    static NLChartBoostAdLoader *loader = nil;
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
        // Initialize the Chartboost library
         [Chartboost startWithAppId:[self appID]
                       appSignature:[self appSignature]
                         completion:^(BOOL success) {
             // Chartboost was initialized if success is YES
             self.startSuccess = success;
             if (success) {
                 [self.adRewardDict.allValues enumerateObjectsUsingBlock:^(id<CHBAd> obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     [obj cache];
                 }];
             }
         }];
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
    NSObject *loadingRewarded = self.adRewardDict[placeId];
    if ([loadingRewarded isKindOfClass:CHBRewarded.class]) {
        CHBRewarded *rewarded = (CHBRewarded *)loadingRewarded;
        return rewarded.isCached;
    }
    return NO;
}

// 激励
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    id<CHBAd> loadingRewarded = self.adRewardDict[placeId];
    if (loadingRewarded != nil) {  return;  }
    
    CHBRewarded *rewarded = [[CHBRewarded alloc] initWithLocation:CBLocationDefault delegate:self];
    self.loadingPlaceCode = placeCode;
    if (self.startSuccess) {
        [rewarded cache];
    }
    self.adRewardDict[placeId] = rewarded;
    self.adPlaceCodeIdDict[@(placeCode)] = placeId;
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId
{
    BOOL successed = NO;
    NSObject *loadingRewarded = self.adRewardDict[placeId];
    if ([loadingRewarded isKindOfClass:CHBRewarded.class]) {
        CHBRewarded *rewarded = (CHBRewarded *)loadingRewarded;
        if (rewarded.isCached) {
            [rewarded showFromViewController:viewController];
            self.playingRewarded = rewarded;
            successed = true;
            [self.adRewardDict removeObjectForKey:placeId];
        }
    }
    return successed;
}

#pragma mark - CHBRewardedDelegate

- (NSString *)placeIdForEvent:(CHBAdEvent *)event {
    id<CHBAd> cacheAd = event.ad;
    __block NSString *placeId = nil;
    [self.adRewardDict.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.adRewardDict[key] == cacheAd) {
            placeId = key;
            *stop = true;
        }
    }];
    return placeId;
}

- (void)didEarnReward:(CHBRewardEvent *)event {
    self.isRewardUser = true;
}

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    if (![self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        return;
    }

    NSString *placeId = [self placeIdForEvent:event];
    if (placeId == nil) return;
    
    NSError *rewardError = nil;
    if (error != nil) {
        [self.adRewardDict removeObjectForKey:placeId];
    }
    [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.loadingPlaceCode error:error placeId:placeId];
}

- (void)willShowAd:(CHBShowEvent *)event {
    
}

- (void)didDismissAd:(CHBDismissEvent *)event {
    NSString *placeId = [self placeIdForEvent:event] ?: @"";
    if (placeId == nil) return;
    NLAdPlaceCode placeCode = [self placeCodeForPlaceId:placeId];
    
    if (self.isRewardUser) {
        if ([self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
            [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:placeCode placeId:placeId];
        }
        self.isRewardUser = false;
    }
    
    // 用户点击关闭按钮，关闭广告
    if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:nil placeId:placeId];
    }
}


#pragma mark - property

- (NLAdPlaceCode)placeCodeForPlaceId:(NSString *)placeId {
    NLAdPlaceCode placeCode = NLAdPlaceCodeUnknow;
    if ([self.adPlaceCodeIdDict.allValues containsObject:placeId]) {
        NSArray<NSNumber *> *codeArrays = [self.adPlaceCodeIdDict allKeysForObject:placeId];
        placeCode = codeArrays.lastObject.integerValue;
    }
    return placeCode;
}

- (NSString *)appID { return @"5f69c5468556a007eda1c832"; }
- (NSString *)appSignature { return @"0608d49f0edc7747cd5875e294da1b960a50c294"; }

- ( NSMutableDictionary<NSNumber *, NSString *> *)adPlaceCodeIdDict {
    if (!_adPlaceCodeIdDict) {
        _adPlaceCodeIdDict = [[NSMutableDictionary alloc] init];
    }
    return _adPlaceCodeIdDict;
}

- (NSMutableDictionary<NSString *,id<CHBAd>> *)adRewardDict {
    if (_adRewardDict == nil) {
        _adRewardDict = [[NSMutableDictionary alloc] init];
    }
    return _adRewardDict;
}

@end
