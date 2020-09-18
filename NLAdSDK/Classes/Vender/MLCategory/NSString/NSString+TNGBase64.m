//
//  NSString+TNGBase64.m
//  Touch 'n Go
//
//  Created by Allen on 2019/1/19.
//  Copyright © 2019年 orangenat. All rights reserved.
//

#import "NSString+TNGBase64.h"

@implementation NSString (TNGBase64)

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
