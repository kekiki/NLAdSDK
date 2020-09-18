//
//  NSString+Add.h
//  demo10-9
//
//  Created by xx on 15/10/11.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Add)


/**
 获取数据库路径
 旧地址 已经废弃
 */
+ (NSString *_Nullable)getDBPath;
+ (NSString *_Nullable)getRealDBPath;

/**
 json转字符串
 */
+ (NSString *_Nullable)jsonToString:(id _Nullable)data;


/**
 URL编码

 @param input <#input description#>
 @return <#return value description#>
 */
+ (NSString *_Nullable)encodeToPercentEscapeString:(NSString *_Nullable)input;


/**
 将数字转换有逗号分隔的数字

 @param title <#title description#>
 @return <#return value description#>
 */
+ (NSString *_Nullable)numFormatWithTitlte:(NSString *_Nullable)title;


/**
 去掉float后面无效的0

 @param stringFloat 要传入的数字字符串
 @return 字符串
 */
+ (NSString *_Nullable)changeFloat:(NSString *_Nullable)stringFloat;


/**
 判断字符串是否为null @“”

 @param string 判断的字符串
 @return 是否为NUll
 */
+ (BOOL)isBlankString:(NSString *_Nullable)string;


/**
 判断是否为浮点形

 @param string 字符数据
 @return <#return value description#>
 */
+ (BOOL)isPureFloat:(NSString *_Nonnull)string;


/**
 *@method 判断是否为整形
 *@param string 字符数据
 */
+ (BOOL)isPureInt:(NSString *_Nonnull)string;


/**
 *  判断是否为空字符串，如为空转为特定字符串，否则原值返回
 *
 *  @param string 字符串
 *
 *  @return string
 */
+ (NSString *_Nonnull)changNULLString:(id _Nullable)string;

+ (NSString *_Nonnull)changNULLString:(id _Nullable)string newString:(NSString *_Nullable)newString;


/**
 *  判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
 *
 *  @param string    原字符串
 *  @param appendStr 要添加的字符串
 *
 *  @return string
 */
+ (NSString *_Nonnull)changNULLString:(id _Nullable)string addendStr:(NSString *_Nullable)appendStr;


/**
 计算字体宽度

 @param font 字体
 @param height 最大高度
 @return 宽度
 */
- (CGFloat)calculateTextfont:(UIFont *_Nonnull)font AndMaxHeight:(CGFloat)height;


/**
 计算字体总的高度

 @param font 字体
 @param width 最大宽度
 @return 高度
 */
- (CGFloat)calculateTextHeightFont:(UIFont *_Nonnull)font AndMaxWidth:(CGFloat)width;


#pragma mark - 文件夹 目录相关

/**
 document根文件夹

 @return document根文件夹
 */
+ (NSString *_Nonnull)documentFolder;


/*
 *  caches根文件夹
 */
+ (NSString *_Nonnull)cachesFolder;


/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
- (NSString *_Nonnull)createSubFolder:(NSString *_Nonnull)subFolder;


/** 返回+1后的字符串*/
+ (NSString *_Nonnull)addOne:(id _Nonnull)number;


/** 返回-1后的字符串*/
+ (NSString *_Nonnull)reduceOne:(id _Nonnull)number;

@end
