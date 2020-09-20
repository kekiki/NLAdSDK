//
//  NLGoogleNativeAdView.h
//  Novel
//
//  Created by Ke Jie on 2020/9/17.
//  Copyright © 2020 panling. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "NLAdViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

@interface NLGoogleNativeAdView : GADUnifiedNativeAdView <NLAdViewProtocol>

+ (instancetype)createView;

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd;
- (void)setAdConfig:(NLAdAttribute *)config;

@end

NS_ASSUME_NONNULL_END
