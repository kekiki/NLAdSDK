//
//  NSString+Category.m
//  Novel
//
//  Created by xiaobai zhang on 2020/4/27.
//  Copyright © 2020 th. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

// 获取字符串长度
- (NSInteger)unicodeLength
{
    NSInteger strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i ++) {
        if (*p) {
            p++;
            strlength ++;
        } else {
            p++;
        }
    }
    return (strlength+1)/2;
}

@end
