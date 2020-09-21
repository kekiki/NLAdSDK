//
//  UIImage+NLAdPalette.m
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "UIImage+NLAdPalette.h"

@implementation UIImage (NLAdPalette)

- (void)getPaletteImageColor:(NLAdGetColorBlock)block{
    [self getPaletteImageColorWithMode:NLADSDK_DEFAULT_NON_MODE_PALETTE withCallBack:block];
    
}

- (void)getPaletteImageColorWithMode:(NLAdPaletteTargetMode)mode withCallBack:(NLAdGetColorBlock)block{
    NLAdPalette *palette = [[NLAdPalette alloc]initWithSourceImage:self];
    [palette startToAnalyzeForTargetMode:mode withCallBack:block];
}

@end
