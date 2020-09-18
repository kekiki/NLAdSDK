//
//  UILabel+TextSize.h
//  MorningStar
//
//  Created by Allen on 2017/1/12.
//  Copyright © 2017年 MorningStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Verify.h"

@interface UILabel (TextSize)

@property (nonatomic, assign, readonly) CGSize  textSize;   ///< 需首先设置text和font,文字为单行时
@property (nonatomic, assign, readonly) CGFloat textWidth;  ///< 需首先设置text和font,文字为单行时
@property (nonatomic, assign, readonly) CGFloat textHeight; ///< 需首先设置text和font,文字为单行时

@end
