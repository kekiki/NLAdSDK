//
//  UIImage+NLAdPalette.h
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAdPalette.h"

@interface UIImage (Palette)

//To avoid some weird problems,so I add the "NLAdPalette" prefix to the API declaration

- (void)getPaletteImageColor:(NLAdGetColorBlock)block;

//you can use '|' to separate every target mode ,eg :"DARK_VIBRANT_PALETTE | VIBRANT_PALETTE"

- (void)getPaletteImageColorWithMode:(NLAdPaletteTargetMode)mode withCallBack:(NLAdGetColorBlock)block;

@end
