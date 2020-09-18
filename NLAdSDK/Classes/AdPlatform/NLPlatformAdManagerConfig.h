//
//  NLPlatformAdLoaderConfig.h
//  Novel
//
//  Created by Ke Jie on 2020/9/6.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Banner自动刷新时间
extern NSTimeInterval const kBannerAdRefreshTimeSeconds;

/// 广告平台配置
@interface NLPlatformAdLoaderConfig: NSObject

/// 广告加载器列表
+ (NSDictionary *)adLoaderList;

@end

NS_ASSUME_NONNULL_END
