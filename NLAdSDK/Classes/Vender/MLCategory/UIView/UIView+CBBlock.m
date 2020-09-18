//
//  UIView+CBBlock.m
//  SuYunTong
//
//  Created by Allen on 16/3/31.
//  Copyright © 2016年 Mars. All rights reserved.
//

#import "UIView+CBBlock.h"
#import <objc/runtime.h>

@implementation UIView (CBBlock)

#pragma mark - runtime associate

-(void)setCallbackBlock:(viewCBBlock)callbackBlock
{
    objc_setAssociatedObject(self, @selector(callbackBlock), callbackBlock, OBJC_ASSOCIATION_COPY);
}

- (viewCBBlock)callbackBlock
{
    return objc_getAssociatedObject(self, @selector(callbackBlock));
}

#pragma mark - callbackAction

- (void)callbackAction:(viewCBBlock)block
{
    self.callbackBlock = nil;
    self.callbackBlock = [block copy];
}

@end
