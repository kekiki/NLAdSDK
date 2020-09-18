//
//  NLAdLog.h
//  Novel
//
//  Created by Ke Jie on 2020/9/14.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdDefines.h"

NS_ASSUME_NONNULL_BEGIN

#define NLAdLog(msg, code) [NLAdLog log:msg placeCode:code]

@interface NLAdLog : NSObject

/// 广告异常日志
/// @param logMsg 日志信息
+ (void)log:(NSString *)logMsg placeCode:(NLAdPlaceCode)code;

/// 日志内容
+ (NSString *)logContent;

/// 清空
+ (void)clear;

@end

NS_ASSUME_NONNULL_END
