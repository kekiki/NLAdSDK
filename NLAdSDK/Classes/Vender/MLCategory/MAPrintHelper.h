//
//  TNGPrintHelper.h
//
//
//  Created by Allen on 2016/12/7.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAPrintHelper : NSObject

/// json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/// 字典转json格式字符串：
+ (NSString *)jsonWithDictionary:(NSDictionary *)dic;

+ (void)printRequestLogWithUrl:(NSString *)url
                        method:(NSString *)method
                        header:(NSDictionary *)header
                          body:(NSDictionary *)body
                  responseData:(NSDictionary *)data
                 responseError:(NSError *)error;

+ (void)printRequestLogWithUrl:(NSString *)url
                        method:(NSString *)method
                        header:(NSDictionary *)header
                          body:(NSDictionary *)body
                     startTime:(NSDate *)startTime
                  responseData:(NSDictionary *)data
                 responseError:(NSError *)error;


@end
