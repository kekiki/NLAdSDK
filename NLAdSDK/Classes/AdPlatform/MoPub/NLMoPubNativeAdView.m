//
//  NLMoPubNativeAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLMoPubNativeAdView.h"
#import "NLAdAttribute.h"
@import MoPub;

@interface NLMoPubNativeAdView () <MPNativeAdRendering>

@end

@implementation NLMoPubNativeAdView

#pragma mark - MPNativeAdRendering

- (UILabel *)nativeMainTextLabel {
    return self.bodyView;
}

- (UILabel *)nativeTitleTextLabel {
    return self.self.headlineView;
}

- (UILabel *)nativeCallToActionTextLabel {
    return self.callToActionView.titleLabel;
}

- (UILabel *)nativeSponsoredByCompanyTextLabel {
    return self.advertiserView;
}

- (UIImageView *)nativeIconImageView {
    return self.iconView;
}

- (UIImageView *)nativeMainImageView {
    return self.mediaView;
}

+ (UINib *)nibForAd {
    NSString *nibName = NSStringFromClass([self class]);
    return [UINib nibWithNibName:nibName bundle:nil];
}

#pragma mark - Public

- (void)setAdConfig:(NLAdAttribute *)config {
    if (!config) { return; }
    self.iconView.alpha = config.iconAlpha;
    self.mediaView.alpha = config.mediaAlpha;
    (self.headlineView).textColor = config.titleColor;
    (self.bodyView).textColor = config.detailColor;
    self.callToActionView.backgroundColor = config.buttonBackgroundColor;
    [self.callToActionView setTitleColor:config.buttonTitleColor forState:UIControlStateNormal];
    self.callToActionView.layer.borderColor = config.buttonBorderColor.CGColor;
}

- (void)setupViews {
    
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:NLMoPubNativeAdView.class]) {
        return NO;
    }
    NLMoPubNativeAdView *adView = (NLMoPubNativeAdView *)object;
    NLMoPubNativeAdView *ad1 = adView;
    NLMoPubNativeAdView *ad2 = self;
    return [ad1.headlineView.text isEqualToString:ad2.headlineView.text]
    && [ad1.bodyView.text isEqualToString:ad2.bodyView.text]
    && [ad1.advertiserView.text isEqualToString:ad2.advertiserView.text];
}

@end
