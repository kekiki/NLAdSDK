//
//  NLAdReadAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdReadAdView.h"
#import "NLReadAdObject.h"
#import "NLAdViewProtocol.h"
#import "NLGoogleAdReadView.h"
#import "NLFacebookAdReadView.h"

@interface NLAdReadAdView ()

@property (nonatomic, strong) NLGoogleAdReadView *gView;
@property (nonatomic, strong) NLFacebookAdReadView *fView;

@end

@implementation NLAdReadAdView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.gView];
        [self addSubview:self.fView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gView.frame = self.bounds;
    self.fView.frame = self.bounds;
}

- (void)setupObject:(__kindof NSObject *)adObject {
    if (![adObject isKindOfClass:NLReadAdObject.class]) { return; }
    NLReadAdObject *object = (NLReadAdObject *)adObject;
    if (object.adPlatform == NLAdPlatformAdmob) {
        self.fView.hidden = YES;
        self.gView.hidden = NO;
        [self.gView setupAdModel:object.adObject];
    } else if (object.adPlatform == NLAdPlatformFacebook) {
        self.gView.hidden = YES;
        self.fView.hidden = NO;
        [self.fView setupAdModel:(FBNativeAd *)object.adObject];
    }
}

- (void)setAttributes:(NLAdAttribute *)attributes {
    if (!self.fView.isHidden) {
        [self.fView setAdConfig:attributes];
    } else if (!self.gView.isHidden) {
        [self.gView setAdConfig:attributes];
    }
}

- (NLGoogleAdReadView *)gView {
    if (_gView == nil) {
        _gView = [NLGoogleAdReadView createView];
    }
    return _gView;
}

- (NLFacebookAdReadView *)fView {
    if (_fView == nil) {
        _fView = [NLFacebookAdReadView createView];
    }
    return _fView;
}

@end
