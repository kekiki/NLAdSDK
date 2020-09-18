//
//  NLFacebookAdSplashView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/9.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookAdSplashView.h"
#import "UIView+Gradient.h"
#import "Palette.h"
#import "MLUtils.h"
#import "UIImage+Add.h"
#import "NLAdAttribute.h"
#import "UIColor+Hex.h"
#import <YYCategories/YYCategories.h>

@import FBAudienceNetwork;

@interface NLFacebookAdSplashView()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverBgConstraints;

@end

@implementation NLFacebookAdSplashView

+ (instancetype)createView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nibObjects firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = [[[UIApplication sharedApplication].delegate window] safeAreaInsets];
        self.coverBgConstraints.constant = insets.top;
    } else {
        // Fallback on earlier versions
        self.coverBgConstraints.constant = 0;
    }
    self.bodyView.textColor = [UIColor colorWithHex:0x222222];
    self.iconView.layer.cornerRadius = 12.0;
    self.iconView.layer.masksToBounds = true;
    self.iconView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.iconView.layer.borderWidth = 3;
    
    self.mediaView.layer.cornerRadius = 10.0;
    self.mediaView.layer.masksToBounds = true;
}

- (void)setupAdModel:(FBNativeAd *)nativeAd {
    if (nativeAd != nil && nativeAd.isAdValid) {
        [nativeAd unregisterView];
        [nativeAd registerViewForInteraction:self mediaView:self.mediaView iconView:self.iconView viewController:nil];
        
        self.headlineView.text = nativeAd.headline;
        
        self.bodyView.text = nativeAd.bodyText;
        self.bodyView.hidden = nativeAd.bodyText ? NO : YES;
        
        [self.callToActionView setTitle:nativeAd.callToAction forState:UIControlStateNormal];
        self.callToActionView.hidden = nativeAd.callToAction ? NO : YES;
        
        self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImage *coverImage = self.mediaView.snapshotImage;
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
}

- (void)setCoverColor:(UIColor *)coverColor {
    UIColor *endColor = [coverColor colorByChangeHue:0 saturation:0.2 brightness:0 alpha:0];
    CGPoint start = CGPointMake(0.96, 0.05);
    CGPoint end = CGPointMake(0.1, 0.93);
    [self.coverImageView setGradientBackgroundWithColors:@[coverColor, endColor] locations:nil startPoint:start endPoint:end];
    
    [self.callToActionView setGradientBackgroundWithColors:@[coverColor, endColor] locations:@[@0, @1.0] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.76)];
}

@end
