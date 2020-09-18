//
//  TNGPrintHelper.m
//
//
//  Created by Allen on 2016/12/7.
//  Copyright © 2016年 MorningStar. All rights reserved.
//

#import "MAPrintHelper.h"
#import "MLUtils.h"

@implementation MAPrintHelper

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

// json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (!jsonString.length) return nil;
    NSError *err;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 字典转json格式字符串：
+ (NSString *)jsonWithDictionary:(NSDictionary *)dic
{
    if (!isDict(dic))  {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    if (![dic allKeys].count) {
        return nil;
    }
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        return [NSString stringWithFormat:@"not Valid JSONObject == %@", dic];
    }
    
    NSError *parseError = nil;
    NSMutableDictionary *muDic = dic.mutableCopy;
    for (NSString *key in muDic.allKeys) {
        NSObject *obj = muDic[key];
        if ([obj isKindOfClass:NSData.class]) {
            [muDic setValue:obj.description forKey:key];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

+ (void)printRequestLogWithUrl:(NSString *)url
                        method:(NSString *)method
                        header:(NSDictionary *)header
                          body:(NSDictionary *)body
                  responseData:(NSDictionary *)data
                 responseError:(NSError *)error
{
    [self printRequestLogWithUrl:url method:method header:header body:body startTime:nil responseData:data responseError:error];
}


+ (void)printRequestLogWithUrl:(NSString *)url
                        method:(NSString *)method
                        header:(NSDictionary *)header
                          body:(NSDictionary *)body
                     startTime:(NSDate *)startTime
                  responseData:(NSDictionary *)data
                 responseError:(NSError *)error;
{
#ifdef DEBUG
//    NSLog(@"--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->---> Request Url:\n %@", url);
//    if (method) NSLog(@"---> Request method: %@",method);
//    if (header) NSLog(@"---> Request Header: %@",[self jsonWithDictionary:header]);
//    if (body) NSLog(@"---> Request Body:\n%@\n", [self jsonWithDictionary:body]);
//    if (data) NSLog(@"---> Response DataRaw:\n %@\n", [self jsonWithDictionary:data]);
//    if (error) NSLog(@"---> Response Error: error.localizedDescription == %@=======\n\n\n  %@ ------<------<------<------<------<------<------<------<------<------<\n", error.localizedDescription, error);
#endif
}

@end
