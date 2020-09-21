//
//  NLGoogleAdReadView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/5.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleAdReadView.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NLGoogleAdReadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self roundCorner:self cornerRadius:8];
    [self roundCorner:self.iconView cornerRadius:12];
    [self roundCorner:self.callToActionView cornerRadius:19];
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

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd {
    GADUnifiedNativeAdView *nativeAdView = self;
    nativeAdView.nativeAd = nativeAd;
    nativeAdView.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;

    [((UIButton *)self.callToActionView).titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

    [((UIImageView *)nativeAdView.iconView) sd_setImageWithURL:nativeAd.icon.imageURL];
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;
    
    [self setNeedsLayout];
}

- (void)setAdConfig:(NLAdAttribute *)config {
    if (!config) { return; }
    self.iconView.alpha = config.iconAlpha;
    self.mediaView.alpha = config.mediaAlpha;
    ((UILabel *)self.headlineView).textColor = config.titleColor;
    ((UILabel *)self.bodyView).textColor = config.detailColor;
    self.callToActionView.backgroundColor = config.buttonBackgroundColor;
    [((UIButton *)self.callToActionView) setTitleColor:config.buttonTitleColor forState:UIControlStateNormal];
}

- (void)roundCorner:(UIView *)view cornerRadius:(CGFloat)cornerRadius {
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = view.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerRadius];
    mask.path = path.CGPath;
    view.layer.mask = mask;
}

@end
