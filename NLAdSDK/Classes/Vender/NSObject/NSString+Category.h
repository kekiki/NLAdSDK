//
//  NSString+Category.h
//  Novel
//
//  Created by xiaobai zhang on 2020/4/27.
//  Copyright © 2020 th. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)

// 获取字符串长度，中文算1个，英文算半个
- (NSInteger)unicodeLength;

@end

NS_ASSUME_NONNULL_END
