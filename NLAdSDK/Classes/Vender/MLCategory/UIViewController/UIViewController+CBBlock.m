//
//  UIViewController+CBBlock.m
//  SuYunTong
//
//  Created by iMac on 16/3/31.
//  Copyright © 2016年 Mars. All rights reserved.
//

#import "UIViewController+CBBlock.h"
#import <objc/runtime.h>

@implementation UIViewController (CBBlock)

#pragma mark - runtime associate

-(void)setCallbackBlock:(viewCtlCBBlock)callbackBlock
{
    objc_setAssociatedObject(self, @selector(callbackBlock), callbackBlock, OBJC_ASSOCIATION_COPY);
}

- (viewCtlCBBlock)callbackBlock
{
    return objc_getAssociatedObject(self, @selector(callbackBlock));
}

#pragma mark - callbackAction

- (void)callbackAction:(viewCtlCBBlock)block
{
    self.callbackBlock = nil;
    self.callbackBlock = [block copy];
}

@end
