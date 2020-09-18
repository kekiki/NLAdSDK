//
//  UILabel+TextSpace.h
//  Touch 'n Go
//
//  Created by Allen on 2018/8/18.
//  Copyright © 2018年 orangenat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextSpace)

/// 须在设置完text后调用,内部实现为富文本,会覆盖之前设置过的富文本
- (NSMutableAttributedString *)setLineSpace:(float)space; ///< 行间距
- (void)setWordSpace:(float)space; ///< 字间距
- (void)setLineSpace:(float)lineSpace wordSpace:(float)wordSpace; ///< 行字间距

- (NSMutableDictionary *)setLineHeight:(float)lineHeight; ///< 行高
- (NSMutableDictionary *)setLineHeight:(float)lineHeight wordSpace:(float)wordSpace;

@end
