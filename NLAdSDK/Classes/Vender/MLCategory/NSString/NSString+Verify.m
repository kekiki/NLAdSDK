//
//  NSString+Verify.m
//  BdEgo
//
//  Created by Allen on 15/6/8.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

#import "NSString+Verify.h"


#pragma mark == Verify ==
@implementation NSString (Verify)
- (BOOL)isPhoneNum{
    NSString *regex = @"\\d{11}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];

    return isMatch;
}

- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isMatch= [emailTest evaluateWithObject:self];
    
    return isMatch;
}

- (BOOL)isContentEspeciallyChar{
    for (int i=0; i<self.length; i++) {
        char a=[self characterAtIndex:i];
        if (!((a<='z'&&a>='a')||(a<='Z'&&a>='A')||(a>='0'&&a<='9'))) {
            return YES;
        }
    }
    return NO;
}

//判断数字
- (BOOL)isPureNumber
{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}


- (BOOL)validateIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

- (NSInteger)stringByteCount
{
    int strlength = 0;
    char *p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

@end

#pragma mark == TimeInterval ==
@implementation NSString (TimeInterval)

- (NSString *)timeStringFromTimeValueWithFormat:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    
    NSDate *date = [format dateFromString:self];
    return [format stringFromDate:date];
}

- (NSString *)dayDateFromTimeValueWithFormat:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    
    NSDate *date = [format dateFromString:self];
    NSString *dateString = [format stringFromDate:date];
    return [dateString componentsSeparatedByString:@" "].firstObject;
}

- (NSString *)timeStringFromTimeIntervalWithFormat:(NSString *)formatString {
    NSTimeInterval interval=[self doubleValue];
    NSDate*date=[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter*format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    return [format stringFromDate:date];
}

- (NSTimeInterval)timeIntervalFromFormat:(NSString *)formatString {
    NSDateFormatter*format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    NSDate*date=[format dateFromString:self];
    return [date timeIntervalSince1970];
}


@end


#pragma mark == Extension ==
@implementation NSString (Extension)


/**
 字符串加行间距
 
 @param lineSpacing 行间距大小
 
 @return 返回是Attributed格式
 */
-(NSMutableAttributedString*)stringWithLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}

@end

#pragma mark == Size ==
@implementation NSString (Size)


//返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font?font:[UIFont systemFontOfSize:17]};
    CGSize fontSize = [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    //向上取整
    CGSize newFontSize = CGSizeMake(ceilf(fontSize.width), ceilf(fontSize.height));
    
    return newFontSize;
}

- (CGSize)sizeWithFontFew:(UIFont *)font
{
    return [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}


/**
 计算有行间距的字符串大小（宽、高）
 
 @param font        字符串字体大小
 @param maxSize     (如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 @param lineSpacing 行间距大小
 
 @return 字符串大小
 */
-(CGSize)sizeHaveLineSpacingWithFont:(UIFont*)font
                             maxSize:(CGSize)maxSize
                         LineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    
    CGSize size = [self boundingRectWithSize:maxSize
                                       options:options
                                    attributes:attributes
                                       context:nil].size;
    
    return size;
}

- (NSString *)AsteriskPhonenumber
{
    if (self.length < 9) return @"";
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

- (NSString *)asteriskWithLocation:(NSUInteger)location length:(NSUInteger)length
{
    if (self.length < location + length) return @"";
    NSString *newString = self;
    for (int i = 0; i < length; i++) {
        NSRange range = NSMakeRange(location, 1);
        newString = [newString stringByReplacingCharactersInRange:range withString:@"*"];
        location ++;
    }
    return newString;
}

/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+ (NSString *)reviseString:(NSString *)str
{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/** 直接传入精度丢失有问题的Double类型*/
NSString *decimalNumberWithDouble(double conversionValue) {
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

- (NSString *)TimestampToDateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
//    formatter.dateFormat = @"dd/MM/yyyy HH:mm";
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

- (NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [formatter stringFromDate:date];
}

- (NSString *)TnGDate2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = @"dd/MM/yyyy HH:mm";
    return [formatter stringFromDate:date];
}

- (NSString *)TnGdate3 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = @"dd/MM/yyyy HH:mm";
    return [formatter stringFromDate:date];
}

- (NSString *)wanRaw {
    CGFloat count = self.floatValue;
    if (count >= 10000) {
        return [NSString stringWithFormat:@"%.1f", count/10000];
    } else {
        return self;
    }
}

- (NSString *)wan {
    CGFloat count = self.floatValue;
    if (count >= 10000) {
        return [NSString stringWithFormat:@"%.1fw", count/10000];
    } else {
        return self;
    }
}

- (NSString *)wanHan {
    CGFloat count = self.floatValue;
    if (count >= 10000) {
        return [NSString stringWithFormat:@"%.1f万", count/10000];
    } else {
        return self;
    }
}

- (NSString *)rawString {
    // 换行\t制表符，缩进
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return string;
}

@end


@implementation NSString (DecimalNumber)
+(NSString *)A:(NSString *)a jiaB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByAdding:num2];
    return [resultNum stringValue];
}

+(NSString *)A:(NSString *)a jianB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];
    return [resultNum stringValue];
}

+(NSString *)A:(NSString *)a chengyiB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [resultNum stringValue];
}

+(NSString *)A:(NSString *)a chuyiB:(NSString *)b {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByDividingBy:num2];
    return [resultNum stringValue];
}

+(BOOL)A:(NSString *)a dayuB:(NSString *)b {
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;

}

+(BOOL)A:(NSString *)a dengyuB:(NSString *)b {
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;

}

+(BOOL)A:(NSString *)a xiaoyuB:(NSString *)b {
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return YES;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;

}

- (NSString *)pointValueWith:(NSUInteger)point {
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:point
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *resultNumber = [number decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return resultNumber.stringValue;
}

@end
