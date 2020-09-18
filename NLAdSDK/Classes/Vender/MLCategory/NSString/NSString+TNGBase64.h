//
//  NSString+TNGBase64.h
//  Touch 'n Go
//
//  Created by Allen on 2019/1/19.
//  Copyright © 2019年 orangenat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TNGBase64)

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

@end

NS_ASSUME_NONNULL_END
