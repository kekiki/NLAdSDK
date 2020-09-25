//
//  NLVungleAdLoader.m
//  Novel
//
//  Created by Ray Tao on 2020/9/21.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLVungleAdLoader.h"
#import <VungleSDK/VungleSDK.h>

@interface NLVungleAdLoader ()<VungleSDKDelegate>
// 原生
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSObject *> *adLoaderDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *adViewDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NLAdAttribute *> *adAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *adViewValues;
@property (nonatomic, strong) NSMutableSet<NSString *> *invalidAdPlaceCodeSet;
@property (nonatomic, assign) NLAdPlaceCode playingPlaceCode;
@property (nonatomic, assign) NLAdPlaceCode loadingPlaceCode;
@property (nonatomic, assign) BOOL isRewardUser;
/// key placeid value bool是否存在请求
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *adRewardDict;
@property (nonatomic, assign) BOOL startSuccess;
@end

@implementation NLVungleAdLoader

+ (instancetype)sharedLoader {
    static NLVungleAdLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSError* error;
        NSString* appID = @"5f68194e58401a000165d6b0";
        VungleSDK* sdk = [VungleSDK sharedSDK];
        sdk.delegate = self;
        if (![sdk startWithAppId:appID error:&error]) {
            if (error) {
                NSLog(@"Error encountered starting the VungleSDK: %@", error);
            }
        }
    }
    return self;
}

- (void)dealloc {
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

// 激励
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    NSError* error;
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSNumber *placementIsLoad = self.adRewardDict[placeId];
    if (placementIsLoad.boolValue == true) return;
    
    if (![sdk isAdCachedForPlacementID:placeId]) {
        BOOL placementIsLoad = false;
        if (self.startSuccess) {
            placementIsLoad = [sdk loadPlacementWithID:placeId error:&error];
        }
        
        self.adRewardDict[placeId] = @(placementIsLoad);
        
        self.loadingPlaceCode = placeCode;
        // 广告开始播放
        if (placementIsLoad && [self.delegate respondsToSelector:@selector(adLoader:loadRewardAdStartedWithPlaceCode:placeId:)]) {
            [self.delegate adLoader:self loadRewardAdStartedWithPlaceCode:placeCode placeId:placeId];
        } else if (error != nil) {
            [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:placeCode error:error placeId:placeId];
        }
    }
}

- (BOOL)hasRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId {
    return [[VungleSDK sharedSDK] isAdCachedForPlacementID:placeId];
}

- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId
{
    BOOL successed = NO;
    VungleSDK* sdk = [VungleSDK sharedSDK];
    // 静音播放
    // sdk.muted = true;
    NSError* error;
    if([sdk isAdCachedForPlacementID:placeId]){
        [sdk playAd:viewController options:nil placementID:placeId error:&error];
        if (!error) {
            successed = true;
            self.playingPlaceCode = placeCode;
            [self.adRewardDict removeObjectForKey:placeId];
        }
    }
    [self loadRewardAdWithPlaceCode:placeCode placeId:placeId];
    return successed;
}

#pragma mark - VungleSDKDelegate
- (void)vungleSDKDidInitialize{
// 初始化成功
    self.startSuccess = true;
    [self.adRewardDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.boolValue == false) {
            [self loadAdWithPlaceCode:self.loadingPlaceCode placeId:key];
        }
    }];
}

- (void)vungleSDKFailedToInitializeWithError:(NSError *)error{
// 初始化失败
    self.startSuccess = false;
}

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error{
    if (placementID == nil) return;
// 缓存广告成功或失败
    if (error == nil && isAdPlayable) {
        
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.loadingPlaceCode error:error placeId:placementID];
    } else {
        [self.adRewardDict removeObjectForKey:placementID];
    } 
}

- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID{
// 广告即将开始播放
}

- (void)vungleDidShowAdForPlacementID:(nullable NSString *)placementID{
   
}

- (void)vungleTrackClickForPlacementID:(nullable NSString *)placementID{
    // 广告被点击
}

- (void)vungleWillLeaveApplicationForPlacementID:(nullable NSString *)placementID{
    // 离开应用，例如用户点击广告，跳转商店
}

- (void)vungleRewardUserForPlacementID:(nullable NSString *)placementID{
    // 使用与奖励广告位，当用户观看80%以上时触发
//    VungleSDK* sdk = [VungleSDK sharedSDK];
    self.isRewardUser = true;
}

- (void)vungleDidCloseAdForPlacementID:(nonnull NSString *)placementID{
    if (self.isRewardUser && [self.delegate respondsToSelector:@selector(adLoader:userDidEarnRewardWithPlaceCode:placeId:)]) {
        [self.delegate adLoader:self userDidEarnRewardWithPlaceCode:self.playingPlaceCode placeId:placementID];
        self.isRewardUser = false;
    }
    
    // 用户点击关闭按钮，关闭广告
    if ([self.delegate respondsToSelector:@selector(adLoader:loadRewardAdFinishedWithPlaceCode:error:placeId:)]) {
        [self.delegate adLoader:self loadRewardAdFinishedWithPlaceCode:self.playingPlaceCode error:nil placeId:placementID];
    }
}

#pragma mark - property


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

- (NSMutableDictionary<NSString *, NSNumber *> *)adRewardDict {
    if (!_adRewardDict) {
        _adRewardDict = [[NSMutableDictionary alloc] init];
    }
    return _adRewardDict;
}

@end
