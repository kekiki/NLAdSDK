//
//  NLFacebookAdLoader.h
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLPlatformAdLoaderDelegate.h"
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NLFacebookAdLoader : NSObject <NLPlatformAdLoaderProtocol>

@property (nonatomic, weak, nullable) id<NLPlatformAdLoaderDelegate> delegate;

+ (instancetype)sharedLoader;

// 原生
- (void)loadAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (BOOL)hasAdWithPlaceCode:(NLAdPlaceCode)placeCode;
- (nullable UIView *)adViewWithPlaceCode:(NLAdPlaceCode)placeCode;
- (void)setAdAttributes:(NLAdAttribute *)attributes placeCode:(NLAdPlaceCode)placeCode;

// 激励
- (void)loadRewardAdWithPlaceCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;
- (BOOL)presentRewardAdInViewController:(UIViewController *)viewController placeCode:(NLAdPlaceCode)placeCode placeId:(NSString *)placeId;

@end

NS_ASSUME_NONNULL_END
