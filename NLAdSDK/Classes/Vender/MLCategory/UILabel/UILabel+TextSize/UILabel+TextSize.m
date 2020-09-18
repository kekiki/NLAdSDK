//
//  UILabel+TextSize.m
//  MorningStar
//
//  Created by Allen on 2017/1/12.
//  Copyright © 2017年 MorningStar. All rights reserved.
//

#import "UILabel+TextSize.h"

@implementation UILabel (TextSize)

- (CGSize)textSize
{
    return [self.text sizeWithFontFew:self.font];
}

- (CGFloat)textWidth
{
    return self.textSize.width;
}

- (CGFloat)textHeight
{
    return self.textSize.height;
}

@end
