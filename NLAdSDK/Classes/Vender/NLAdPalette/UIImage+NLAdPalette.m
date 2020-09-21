//
//  UIImage+NLAdPalette.m
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "UIImage+NLAdPalette.h"

@implementation UIImage (NLAdPalette)

- (void)getPaletteImageColor:(GetColorBlock)block{
    [self getPaletteImageColorWithMode:DEFAULT_NON_MODE_PALETTE withCallBack:block];
    
}

- (void)getPaletteImageColorWithMode:(NLAdPaletteTargetMode)mode withCallBack:(GetColorBlock)block{
    NLAdPalette *palette = [[NLAdPalette alloc]initWithImage:self];
    [palette startToAnalyzeForTargetMode:mode withCallBack:block];
}

@end
