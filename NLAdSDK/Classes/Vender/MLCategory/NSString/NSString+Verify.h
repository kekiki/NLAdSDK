//
//  NSString+Verify.h
//  BdEgo
//
//  Created by Allen on 15/6/8.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

- (BOOL)isPhoneNum;

- (BOOL)isEmailAddress;

- (BOOL)isContentEspeciallyChar;

- (BOOL)isPureNumber;

- (BOOL)validateIdentityCard;

- (NSInteger)stringByteCount;

@end


@interface NSString (TimeInterval)

- (NSString *)timeStringFromTimeValueWithFormat:(NSString *)formatString;
- (NSString *)timeStringFromTimeIntervalWithFormat:(NSString *)formatString;

- (NSString *)dayDateFromTimeValueWithFormat:(NSString *)formatString;

- (NSTimeInterval)timeIntervalFromFormat:(NSString *)formatString;

@end

@interface NSString (Extension)

/**
 字符串加行间距
 
 @param lineSpacing 行间距大小
 
 @return 返回是Attributed格式
 */
-(NSMutableAttributedString*)stringWithLineSpacing:(CGFloat)lineSpacing;

@end




@interface NSString (Size)

/**
 计算字符串大小（宽、高）

 @param font    字符串字体大小
 @param maxSize (如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)

 @return 字符串大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 计算少量(不换行)字符串大小（宽、高）
 @param font    字符串字体大小
 @return 字符串大小
 */
- (CGSize)sizeWithFontFew:(UIFont *)font;

/**
 计算有行间距的字符串大小（宽、高）

 @param font        字符串字体大小
 @param maxSize     (如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 @param lineSpacing 行间距大小

 @return 字符串大小
 */
-(CGSize)sizeHaveLineSpacingWithFont:(UIFont*)font
                             maxSize:(CGSize)maxSize
                         LineSpacing:(CGFloat)lineSpacing;


/**
 * 手机号加星号 ***
 */
- (NSString *)AsteriskPhonenumber;

/**
 * 字符串加星号 ***
 */
- (NSString *)asteriskWithLocation:(NSUInteger)location length:(NSUInteger)length;

/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+ (NSString *)reviseString:(NSString *)str;

/** 直接传入精度丢失有问题的Double类型*/
NSString *decimalNumberWithDouble(double conversionValue);

- (NSString *)TimestampToDateStr;

/// 2018-07-27T13:30:23+08:00
- (NSString *)date;

/// EEE MMM dd HH:mm:ss Z yyyy --> dd/MM/yyyy HH:mm
- (NSString *)TnGDate2;

// 2017-02-06T00:00:00.000+08:00 --> dd/MM/yyyy HH:mm
- (NSString *)TnGdate3;

// 转换为万单位字符串 无单位
- (NSString *)wanRaw;
// 转换为万单位字符串 w
- (NSString *)wan;
// 转换为万单位字符串 万
- (NSString *)wanHan;

//去掉换行,缩进等格式后的原始字符串
- (NSString *)rawString;

@end

@interface NSString (DecimalNumber)
+(NSString *)A:(NSString *)a jiaB:(NSString *)b;
+(NSString *)A:(NSString *)a jianB:(NSString *)b;
+(NSString *)A:(NSString *)a chengyiB:(NSString *)b;
+(NSString *)A:(NSString *)a chuyiB:(NSString *)b;
+(BOOL)A:(NSString *)a dayuB:(NSString *)b;
+(BOOL)A:(NSString *)a dengyuB:(NSString *)b;
+(BOOL)A:(NSString *)a xiaoyuB:(NSString *)b;

/// 小数点后几位
- (NSString *)pointValueWith:(NSUInteger)point;

@end



