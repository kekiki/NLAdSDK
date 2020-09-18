//
//  NLAdLog.m
//  Novel
//
//  Created by Ke Jie on 2020/9/14.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdLog.h"

@implementation NLAdLog

+ (NSString *)logPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [documentPath stringByAppendingPathComponent:@"logs"];
    NSString *logPath = [NSString stringWithFormat:@"%@/adLog.txt", dirPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logPath]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:logPath contents:nil attributes:nil];
    }
    return logPath;
}

+ (void)log:(NSString *)logMsg placeCode:(NLAdPlaceCode)code {
#if DEBUG
    if (logMsg == nil || logMsg.length <= 0) { return; }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *place = @"广告位";
        if (code == NLAdPlaceCodeNativeSplash) {
            place = @"原生-开屏";
        } else if (code == NLAdPlaceCodeNativeComicRead) {
            place = @"原生-漫画阅读";
        } else if (code == NLAdPlaceCodeNativeNovelRead) {
            place = @"原生-小说阅读";
        } else if (code == NLAdPlaceCodeNativeComicBottom) {
            place = @"原生-漫画底部";
        } else if (code == NLAdPlaceCodeNativeNovelBottom) {
            place = @"原生-小说底部";
        } else if (code == NLAdPlaceCodeRewardSign) {
            place = @"激励-签到";
        } else if (code == NLAdPlaceCodeRewardBindPhone) {
            place = @"激励-绑定手机";
        } else if (code == NLAdPlaceCodeRewardOpenBox) {
            place = @"激励-开宝箱";
        } else if (code == NLAdPlaceCodeRewardNovelDownload) {
            place = @"激励-小说下载";
        } else if (code == NLAdPlaceCodeRewardNovelPrivilege) {
            place = @"激励-小说权益";
        } else if (code == NLAdPlaceCodeRewardComicPrivilege) {
            place = @"激励-漫画权益";
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *message = [NSString stringWithFormat:@"%@:%@: %@\r\n", dateString, place, logMsg];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSString *filePath = [self logPath];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    });
#endif
}

+ (NSString *)logContent {
    NSString *filePath = [self logPath];
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+ (void)clear {
    NSString *filePath = [self logPath];
    [@"" writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
