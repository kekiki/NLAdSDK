//
//  NLGoogleAdBannerView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/5.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleAdBannerView.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>

@implementation NLGoogleAdBannerView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.callToActionView.isHidden) {
        [self.headlineView sizeToFit];
        CGFloat maxWidth = self.width - self.mediaView.right - 16;
        if (self.headlineView.width > maxWidth) {
            self.headlineView.width = maxWidth;
        }
    } else {
        [self.callToActionView sizeToFit];
        self.callToActionView.height = 26;
        self.callToActionView.right = self.width-8;
        [((UIButton *)self.callToActionView) setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        
        [self.headlineView sizeToFit];
        CGFloat maxWidth = self.callToActionView.left - self.mediaView.right - 16;
        if (self.headlineView.width > maxWidth) {
            self.headlineView.width = maxWidth;
        }
    }
}

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd {
    self.nativeAd = nativeAd;

    [((UIButton *)self.callToActionView).titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [((UIButton *)self.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    self.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
    [((UIButton *)self.callToActionView) setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];

    self.mediaView.mediaContent = nativeAd.mediaContent;
    self.mediaView.contentMode = UIViewContentModeScaleAspectFill;

    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    ((UILabel *)self.headlineView).text = nativeAd.headline;

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)self.bodyView).text = nativeAd.body;
    self.bodyView.hidden = nativeAd.body ? NO : YES;
}

- (void)setAdConfig:(NLAdAttribute *)config {
    if (!config) { return; }
    self.mediaView.alpha = config.iconAlpha;
    ((UILabel *)self.headlineView).textColor = config.titleColor;
    ((UILabel *)self.bodyView).textColor = config.detailColor;
    [((UIButton *)self.callToActionView) setTitleColor:config.buttonTitleColor forState:UIControlStateNormal];
    self.callToActionView.layer.borderColor = config.buttonBorderColor.CGColor;
}

@end
