//
//  NLGoogleAdSplashView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/7.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleAdSplashView.h"
#import "UIView+Gradient.h"
#import "Palette.h"
#import "MLUtils.h"
#import "UIImage+Add.h"
#import "NLAdAttribute.h"
#import <YYCategories/YYCategories.h>
#import "UIColor+Hex.h"

@interface NLGoogleAdSplashView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverBgConstraints;
@end

@implementation NLGoogleAdSplashView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = [[[UIApplication sharedApplication].delegate window] safeAreaInsets];
        self.coverBgConstraints.constant = insets.top;
    } else {
        // Fallback on earlier versions
        self.coverBgConstraints.constant = 0;
    }

    ((UILabel *)self.bodyView).textColor = [UIColor colorWithHex:0x222222];
    self.iconView.layer.cornerRadius = 12.0;
    self.iconView.layer.masksToBounds = true;
    self.iconView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.iconView.layer.borderWidth = 3;
    
    self.mediaView.layer.cornerRadius = 10.0;
    self.mediaView.layer.masksToBounds = true;
}

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd {
    GADUnifiedNativeAdView *nativeAdView = self;
    nativeAdView.nativeAd = nativeAd;
    nativeAdView.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
        nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;

    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

    [((UIImageView *)nativeAdView.iconView) setImage:nativeAd.icon.image];
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    nativeAdView.imageView.hidden = true;
    
    UIImage *coverImage = nativeAdView.mediaView.snapshotImage;
    Palette *palette = [[Palette alloc] initWithImage:coverImage];
    [palette startToAnalyzeForTargetMode:MUTED_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
        UIColor *color = UIColorHexStr(recommendColor.imageColorString);
        if (!recommendColor.imageColorString) {
            color = [coverImage mostColor];
            color = [color colorByChangeHue:0 saturation:0 brightness:-0.2 alpha:0];
        }
        [self setCoverColor:color];
    }];
}

- (void)setCoverColor:(UIColor *)coverColor {
    UIColor *endColor = [coverColor colorByChangeHue:0 saturation:0.2 brightness:0 alpha:0];
    CGPoint start = CGPointMake(0.96, 0.05);
    CGPoint end = CGPointMake(0.1, 0.93);
    [self.coverImageView setGradientBackgroundWithColors:@[coverColor, endColor] locations:nil startPoint:start endPoint:end];
    
    [self.callToActionView setGradientBackgroundWithColors:@[coverColor, endColor] locations:@[@0, @1.0] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.76)];
}

- (void)setAdConfig:(NLAdAttribute *)config {
    if (!config) { return; }
}

@end