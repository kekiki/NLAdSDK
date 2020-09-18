//
//  NSString+Add.m
//  demo10-9
//
//  Created by xx on 15/10/11.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import "NSString+Add.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Add)

+ (NSString *_Nullable)getRealDBPath {
    //沙河缓存路径 视频或者语音的拼接路径
    NSString *documentPath = [self cachesFolder];
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    //数据库文件夹 考虑到可能有多个账号切换，应该在TuiJi_DB下再拼接账号的文件夹
    NSString *docDirName = @"NL_DB";
    
    NSString *dbDirPath = [documentPath stringByAppendingPathComponent:docDirName];
    
    BOOL isDir;
    BOOL exit = [filemanage fileExistsAtPath:dbDirPath isDirectory:&isDir];
    
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //配置账户文件夹
    NSString *userDBName = @"NLDB";
    
    NSString *userPath = [dbDirPath stringByAppendingPathComponent:userDBName];
    
    BOOL isUserDir;
    BOOL userExit = [filemanage fileExistsAtPath:userPath isDirectory:&isUserDir];
    
    if (!userExit || !isUserDir) {
        [filemanage createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [userPath stringByAppendingPathComponent:userDBName];
}

+ (NSString *)getDBPath {
    
    //沙河缓存路径 视频或者语音的拼接路径
    NSString *documentPath = [self documentFolder];
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    //数据库文件夹 考虑到可能有多个账号切换，应该在TuiJi_DB下再拼接账号的文件夹
    NSString *docDirName = @"NL_DB";
    
    NSString *dbDirPath = [documentPath stringByAppendingPathComponent:docDirName];
    
    BOOL isDir;
    BOOL exit = [filemanage fileExistsAtPath:dbDirPath isDirectory:&isDir];
    
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //配置账户文件夹
    NSString *userDBName = @"NLDB";
    
    NSString *userPath = [dbDirPath stringByAppendingPathComponent:userDBName];
    
    BOOL isUserDir;
    BOOL userExit = [filemanage fileExistsAtPath:userPath isDirectory:&isUserDir];
    
    if (!userExit || !isUserDir) {
        [filemanage createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [userPath stringByAppendingPathComponent:userDBName];
}


//json转字符串
+ (NSString *)jsonToString:(id)data {
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//URL编码
+ (NSString *_Nullable)encodeToPercentEscapeString:(NSString *_Nullable)input {

    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)input, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);

    return outputStr;
}


//去掉float后面无效的0
+ (NSString *)changeFloat:(NSString *)stringFloat {
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = (int)(length - 1);
    for(; i >= 0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}


//将数字转换有逗号的数字
+ (NSString *)numFormatWithTitlte:(NSString *)title {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    numFormat.numberStyle = kCFNumberFormatterDecimalStyle;
    NSNumber *num = [NSNumber numberWithDouble:[title doubleValue]];
    return [numFormat stringFromNumber:num];
}


//判断字符串是否为null @“”
+ (BOOL)isBlankString:(NSString *)string {
    if (nil == string) {
        return YES;
    }
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp == nil) {
        return YES;
    }
    if (temp == NULL) {
        return YES;
    }
    if ([temp isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(temp.length < 1){
        return YES;
    }
    return NO;
}


//判断是否为浮点形
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


//判断是否为整形
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为空字符串，如为空转为特定字符串，否则原值返回
+ (NSString *)changNULLString:(id)string {
    if ([NSString isBlankString:string]) {
        
        return @"暂无";
    }
    else {
        return string;
    }
}


+ (NSString *)changNULLString:(id)string newString:(NSString *)newString {
    if ([NSString isBlankString:string]) {
        
        if (newString) {
            
            return newString;
        }
        return @"暂无";
    }
    else
    {
        return string;
    }
}


//判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
+ (NSString *)changNULLString:(id)string addendStr:(NSString *)appendStr {
    if ([NSString isBlankString:string]) {
        return @"暂无";
    }
    else {
        return [NSString stringWithFormat:@"%@%@", string, appendStr];
    }
}


//计算字体的宽
- (CGFloat)calculateTextfont:(UIFont *)font AndMaxHeight:(CGFloat)height {
    float width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return width;
}


//计算字体高
- (CGFloat)calculateTextHeightFont:(UIFont *_Nonnull)font AndMaxWidth:(CGFloat)width {
    float height = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}


//document根文件夹
+ (NSString *)documentFolder {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


//caches根文件夹
+ (NSString *)cachesFolder {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}


//生成子文件夹
- (NSString *)createSubFolder:(NSString *)subFolder{
    
    NSString *subFolderPath = [NSString stringWithFormat:@"%@/%@",self,subFolder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:subFolderPath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:subFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return subFolderPath;
}


+ (NSString *)addOne:(id)number{
    NSInteger count = [number integerValue];
    return [NSString stringWithFormat:@"%ld",(long)count+1];
}


+ (NSString *)reduceOne:(id)number{
    NSInteger count = [number integerValue];
    return [NSString stringWithFormat:@"%ld",(long)(count-1)];
}

@end
