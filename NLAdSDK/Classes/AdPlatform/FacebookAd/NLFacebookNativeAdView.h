//
//  NLFacebookNativeAdView.h
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAdViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class FBMediaView;
@class FBNativeAd;
@class NLAdAttribute;

@interface NLFacebookNativeAdView : UIView <NLAdViewProtocol>

@property(nonatomic, weak, nullable) IBOutlet FBMediaView *mediaView;
@property(nonatomic, weak, nullable) IBOutlet FBMediaView *iconView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *headlineView;
@property(nonatomic, weak, nullable) IBOutlet UIButton *callToActionView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *advertiserView;
@property(nonatomic, weak, nullable) IBOutlet UILabel *bodyView;

+ (instancetype)createView;

- (void)setupAdModel:(FBNativeAd *)nativeAd;
- (void)setAdConfig:(NLAdAttribute *)config;

@end

NS_ASSUME_NONNULL_END
