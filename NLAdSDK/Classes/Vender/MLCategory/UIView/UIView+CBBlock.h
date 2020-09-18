//
//  UIView+CBBlock.h
//  SuYunTong
//
//  Created by Allen on 16/3/31.
//  Copyright © 2016年 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^viewCBBlock)(id obj);

@interface UIView (CBBlock)

/// View完成某些动作后的回调block
@property (nonatomic, copy) viewCBBlock callbackBlock;

/// View完成某些动作后的block回调函数
- (void)callbackAction:(viewCBBlock)block;

@end
