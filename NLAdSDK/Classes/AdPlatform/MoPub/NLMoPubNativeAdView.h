//
//  NLMoPubNativeAdView.h
//  Novel
//
//  Created by Ke Jie on 2020/9/16.
//  Copyright © 2020 panling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NLAdAttribute;

@interface NLMoPubNativeAdView : UIView

@property(nonatomic, weak, nullable) IBOutlet UIImageView *mediaView;
@property(nonatomic, weak, nullable) IBOutlet UIImageView *iconView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *headlineView;
@property(nonatomic, weak, nullable) IBOutlet UIButton *callToActionView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *advertiserView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *bodyView;

- (void)setAdConfig:(NLAdAttribute *)config;
- (void)setupViews;

@end

NS_ASSUME_NONNULL_END
