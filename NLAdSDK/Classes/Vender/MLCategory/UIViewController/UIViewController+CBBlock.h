//
//  UIViewController+CBBlock.h
//  SuYunTong
//
//  Created by iMac on 16/3/31.
//  Copyright © 2016年 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^viewCtlCBBlock)(_Nullable id obj);

@interface UIViewController (CBBlock)

#pragma mark - block

/// VC完成某些动作后的回调block
@property (nonatomic, copy) viewCtlCBBlock _Nullable callbackBlock;

/// VC完成某些动作后的block回调函数
- (void)callbackAction:(viewCtlCBBlock _Nullable )blockl;

@end
