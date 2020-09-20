//
//  NLGoogleNativeAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/17.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLGoogleNativeAdView.h"

@implementation NLGoogleNativeAdView

+ (instancetype)createView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nibObjects firstObject];
}

- (void)setupAdModel:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)setAdConfig:(NLAdAttribute *)config {
    
}

@end
