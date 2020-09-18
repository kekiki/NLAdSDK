//
//  NLGoogleNativeAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/17.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleNativeAdView.h"

@implementation NLGoogleNativeAdView

+ (instancetype)createView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nibObjects firstObject];
}

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)setAdConfig:(NLAdAttribute *)config {
    
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:NLGoogleNativeAdView.class]) {
        return NO;
    }
    NLGoogleNativeAdView *adView = (NLGoogleNativeAdView *)object;
    GADUnifiedNativeAd *ad1 = adView.nativeAd;
    GADUnifiedNativeAd *ad2 = self.nativeAd;
    return [ad1.headline isEqualToString:ad2.headline]
    && [ad1.body isEqualToString:ad2.body]
    && [ad1.advertiser isEqualToString:ad2.advertiser];
}

@end
