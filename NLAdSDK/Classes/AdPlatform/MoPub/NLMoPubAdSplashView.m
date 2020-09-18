//
//  NLMoPubAdSplashView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLMoPubAdSplashView.h"
#import "UIView+Gradient.h"
#import "Palette.h"
#import "MLUtils.h"
#import "UIImage+Add.h"
#import "NLAdAttribute.h"

@interface NLMoPubAdSplashView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverBgConstraints;

@end

@implementation NLMoPubAdSplashView

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

- (void)setupViews {
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

- (void)setCoverColor:(UIColor *)coverColor {
    UIColor *endColor = [coverColor colorByChangeHue:0 saturation:0.2 brightness:0 alpha:0];
    CGPoint start = CGPointMake(0.96, 0.05);
    CGPoint end = CGPointMake(0.1, 0.93);
    [self.coverImageView setGradientBackgroundWithColors:@[coverColor, endColor] locations:nil startPoint:start endPoint:end];
    
    [self.callToActionView setGradientBackgroundWithColors:@[coverColor, endColor] locations:@[@0, @1.0] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.76)];
}

@end
