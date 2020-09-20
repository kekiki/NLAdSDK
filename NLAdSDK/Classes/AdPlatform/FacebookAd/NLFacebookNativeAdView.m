//
//  NLFacebookNativeAdView.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLFacebookNativeAdView.h"

@implementation NLFacebookNativeAdView

+ (instancetype)createView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return [nibObjects firstObject];
}

- (void)setupAdModel:(FBNativeAd *)nativeAd {
    
}

- (void)setAdConfig:(NLAdAttribute *)config {
    
}

@end
