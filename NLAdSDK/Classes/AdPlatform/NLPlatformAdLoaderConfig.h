//
//  NLPlatformAdLoaderConfig.h
//  Novel
//
//  Created by Ke Jie on 2020/9/6.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 配置阅读底部广告自动刷新间隔时间，秒为单位
extern NSTimeInterval const kReadBottomAdRefreshTime;

/// 广告平台配置类
@interface NLPlatformAdLoaderConfig: NSObject

// 配置广告平台对应的广告加载类
+ (NSDictionary *)adLoaderList;

@end

NS_ASSUME_NONNULL_END
