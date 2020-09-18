//
//  NLFacebookAdBannerView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookAdBannerView.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>
@import FBAudienceNetwork;

@implementation NLFacebookAdBannerView

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

- (void)setupAdModel:(FBNativeAd *)nativeAd {

    if (nativeAd != nil && nativeAd.isAdValid) {
        [nativeAd unregisterView];
        [nativeAd registerViewForInteraction:self mediaView:self.mediaView iconView:self.iconView viewController:nil];
        
        self.headlineView.text = nativeAd.headline;
        self.bodyView.text = nativeAd.bodyText ?: nativeAd.advertiserName;
        
        [[self.callToActionView titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
        [self.callToActionView setTitle:nativeAd.callToAction forState:UIControlStateNormal];
        [self.callToActionView setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        self.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
        
        self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    }
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
