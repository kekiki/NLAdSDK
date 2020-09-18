//
//  UILabel+Add.h
//  xx
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Add)


/**
 初始化

 @param text <#text description#>
 @param color <#color description#>
 @param font <#font description#>
 @return <#return value description#>
 */
+ (UILabel *_Nullable)newLabel:(NSString *_Nullable)text andTextColor:(UIColor *_Nullable)color andFont:(UIFont *_Nonnull)font;


/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *_Nullable)label WithSpace:(float)space;


/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *_Nullable)label WithSpace:(float)space;


/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *_Nullable)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
