//
//  NLPlatformAdLoaderConfig.m
//  Novel
//
//  Created by Ke Jie on 2020/9/6.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLPlatformAdLoaderConfig.h"
#import "NLAdDefines.h"
#import "NLFacebookAdLoader.h"
#import "NLGoogleAdLoader.h"
//#import "NLMoPubAdLoader.h"

// 配置阅读底部广告自动刷新间隔时间，秒为单位
NSTimeInterval const kReadBottomAdRefreshTime = 10;

@implementation NLPlatformAdLoaderConfig

// 配置广告平台对应的广告加载类
+ (NSDictionary *)adLoaderList {
    return @{
        @(NLAdPlatformAdmob): [NLGoogleAdLoader sharedLoader],
        @(NLAdPlatformFacebook): [NLFacebookAdLoader sharedLoader],
//        @(NLAdPlatformMoPub): [NLMoPubAdLoader sharedLoader]
    };
}

@end
