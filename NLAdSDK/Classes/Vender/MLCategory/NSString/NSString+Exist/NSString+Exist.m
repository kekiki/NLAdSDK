//
//  NSString+Exist.h
//  NSString
//
//  Created by Allen on 2014/11/30.
//  Copyright © 2014年 Mar Co., All rights reserved.
//


#import "NSString+Exist.h"

@implementation NSString (Exist)

- (BOOL)isExist
{
    return [self length] > 0;
}

+ (NSString *)disnilString:(id)string
{
    return [self disnilString:string second:nil];
}

+ (NSString *)disnilString:(NSString *)first second:(NSString *)second
{
    if ([first isKindOfClass:[self class]] && first.isExist) {
        return first;
    }
    else if ([second isKindOfClass:[self class]] && second.isExist) {
        return second;
    }
    
    return @"";
}

- (NSString *)filterAllSpace
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)filterHeaderFooterSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去首尾空格
}

+ (BOOL)stringIsContainsFristStr:(NSString *)fristStr secondStr:(NSString *)secondStr
{
    if ([fristStr isKindOfClass:[NSString class]] && fristStr.length > 0 &&
        [secondStr isKindOfClass:[NSString class]] && secondStr.length > 0) {
        NSRange fristRange = [fristStr rangeOfString:secondStr];
        NSRange secondRange = [secondStr rangeOfString:fristStr];
        if (fristRange.location != NSNotFound || secondRange.location != NSNotFound) {
            return YES;
        }
        return NO;
    }
    return NO;
}


@end
