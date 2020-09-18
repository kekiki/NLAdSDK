//
//  NLMoPubAdBannerView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLMoPubAdBannerView.h"

@implementation NLMoPubAdBannerView

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

- (void)setupViews {
    [[self.callToActionView titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
    [self.callToActionView setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.callToActionView.hidden = self.callToActionView.titleLabel.text.length > 0 ? NO : YES;
    self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
