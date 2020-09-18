//
//  NSString+Exist.h
//  NSString
//
//  Created by Allen on 2014/11/30.
//  Copyright © 2014年 Mar Co., All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Exist)

/// 判断字符串是否有内容  @"",nil,Nil 为没有
@property (nonatomic, assign, readonly, getter=isExist) BOOL exist;

/// 返回不为nil的字符串,如果入参为nil,Nil,null,Null,或非NSString类,则返回 @"", 其他的不变返回(防止字典,数组崩溃,界面显示null)
+ (NSString *)disnilString:(id)string;

/// 返回不为nil的字符串,如果入参均为nil,Nil,null,Null,或非NSString类,则返回 @"", 其他的不变返回(防止字典,数组崩溃,界面显示null,优先返回first one)
+ (NSString *)disnilString:(NSString *)first second:(NSString *)second;

/// 过滤所有的空格
- (NSString *)filterAllSpace;

/// 过滤首尾空格
- (NSString *)filterHeaderFooterSpace;

/// 判断两个字符串是否具备包含或被包含关系
+ (BOOL)stringIsContainsFristStr:(NSString *)fristStr secondStr:(NSString *)secondStr;

@end
