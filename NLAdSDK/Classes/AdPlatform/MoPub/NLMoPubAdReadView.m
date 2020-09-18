//
//  NLMoPubAdReadView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLMoPubAdReadView.h"

@implementation NLMoPubAdReadView

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

- (void)setupViews {
    [[self.callToActionView titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
    self.callToActionView.hidden = self.callToActionView.titleLabel.text.length > 0 ? NO : YES;
     self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
