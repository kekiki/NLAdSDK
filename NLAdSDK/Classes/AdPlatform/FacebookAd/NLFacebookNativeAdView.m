//
//  NLFacebookNativeAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookNativeAdView.h"

@implementation NLFacebookNativeAdView

+ (instancetype)createView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nibObjects firstObject];
}

- (void)setupAdModel:(FBNativeAd *)nativeAd {
    
}

- (void)setAdConfig:(NLAdAttribute *)config {
    
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:NLFacebookNativeAdView.class]) {
        return NO;
    }
    NLFacebookNativeAdView *adView = (NLFacebookNativeAdView *)object;
    NLFacebookNativeAdView *ad1 = adView;
    NLFacebookNativeAdView *ad2 = self;
    return [ad1.headlineView.text isEqualToString:ad2.headlineView.text]
    && [ad1.bodyView.text isEqualToString:ad2.bodyView.text]
    && [ad1.advertiserView.text isEqualToString:ad2.advertiserView.text];
}

@end
