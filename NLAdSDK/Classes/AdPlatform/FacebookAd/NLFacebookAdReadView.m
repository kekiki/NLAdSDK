//
//  NLFacebookAdReadView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookAdReadView.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>
@import FBAudienceNetwork;

@implementation NLFacebookAdReadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.mediaView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.iconView.hidden) {
        self.headlineView.left = self.iconView.left;
        self.headlineView.width = self.width - 28;
        self.bodyView.left = self.headlineView.left;
        self.bodyView.width = self.headlineView.width;
    }
}

- (void)setupAdModel:(FBNativeAd *)nativeAd {
    if (nativeAd != nil && nativeAd.isAdValid) {
        [nativeAd unregisterView];
        [nativeAd registerViewForInteraction:self mediaView:self.mediaView iconView:self.iconView viewController:nil];
        
        self.headlineView.text = nativeAd.headline;
        
        self.bodyView.text = nativeAd.bodyText;
        self.bodyView.hidden = nativeAd.bodyText ? NO : YES;
        
        [[self.callToActionView titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [self.callToActionView setTitle:nativeAd.callToAction forState:UIControlStateNormal];
        self.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
        
        self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setAdConfig:(NLAdAttribute *)config {
    if (!config) { return; }
    self.iconView.alpha = config.iconAlpha;
    self.mediaView.alpha = config.mediaAlpha;
    (self.headlineView).textColor = config.titleColor;
    (self.bodyView).textColor = config.detailColor;
    self.callToActionView.backgroundColor = config.buttonBackgroundColor;
    [self.callToActionView setTitleColor:config.buttonTitleColor forState:UIControlStateNormal];
}

@end
