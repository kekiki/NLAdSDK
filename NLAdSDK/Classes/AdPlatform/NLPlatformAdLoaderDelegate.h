//
//  NLPlatformAdLoaderDelegate.h
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NLPlatformAdLoaderDelegate;
@class NLAdAttribute;

@protocol NLPlatformAdLoaderProtocol <NSObject>

@property (nonatomic, weak, nullable) id<NLPlatformAdLoaderDelegate> delegate;

// 原生
- (void)loadAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (BOOL)hasAdWithPlaceCode:(NLAdPlaceCode)placeCode;
- (nullable UIView *)adViewWithPlaceCode:(NLAdPlaceCode)placeCode;
- (void)setAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode;

// 激励
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;

@end

@protocol NLPlatformAdLoaderDelegate <NSObject>

// 原生
- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadAdStartedWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(NSString *)placeId;

// 激励
- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadRewardAdStartedWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager loadRewardAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(NSString *)placeId;

- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager showRewardAdFinishedWithPlaceCode:(NLAdPlaceCode)placeCode error:(nullable NSError *)error placeId:(NSString *)placeId;
- (void)adLoader:(id<NLPlatformAdLoaderProtocol>)manager userDidEarnRewardWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;

@end

NS_ASSUME_NONNULL_END
