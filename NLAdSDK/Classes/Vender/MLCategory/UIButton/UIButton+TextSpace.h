//
//  UIButton+TextSpace.h
//  Touch 'n Go
//
//  Created by Allen on 2018/8/18.
//  Copyright © 2018年 orangenat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TextSpace)

/// 须在设置完text后调用,内部实现为富文本,会覆盖之前设置过的富文本
- (void)setWordSpace:(float)space forState:(UIControlState)state; ///< 字间距
- (void)setLineHeight:(float)lineHeight forState:(UIControlState)state; ///< 行高
- (void)setLineHeight:(float)lineHeight wordSpace:(float)wordSpace forState:(UIControlState)state;

@end
