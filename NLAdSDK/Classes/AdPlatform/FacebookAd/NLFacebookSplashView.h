//
//  NLFacebookAdSplashView.h
//  Novel
//
//  Created by Ke Jie on 2020/9/9.
//  Copyright © 2020 panling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FBNativeAd;

@interface NLFacebookAdSplashView : UIView

+ (instancetype)createView;

- (void)setupAdModel:(FBNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
