//
//  TRIPPaletteTarget.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger,NLAdPaletteTargetMode) {
    NLADSDK_DEFAULT_NON_MODE_PALETTE = 0,//if you don't need the ColorDic(including modeKey-colorModel key-value)
    NLADSDK_VIBRANT_PALETTE = 1 << 0,
    NLADSDK_LIGHT_VIBRANT_PALETTE = 1 << 1,
    NLADSDK_DARK_VIBRANT_PALETTE = 1 << 2,
    NLADSDK_LIGHT_MUTED_PALETTE = 1 << 3,
    NLADSDK_MUTED_PALETTE = 1 << 4,
    NLADSDK_DARK_MUTED_PALETTE = 1 << 5,
    NLADSDK_ALL_MODE_PALETTE = 1 << 6, //Fast path to All mode
};

@interface NLAdPaletteTarget : NSObject

- (instancetype)initWithTargetMode:(NLAdPaletteTargetMode)mode;

- (float)getMinSaturation;

- (float)getMaxSaturation;

- (float)getMinLuma;

- (float)getMaxLuma;

- (float)getSaturationWeight;

- (float)getLumaWeight;

- (float)getPopulationWeight;

- (float)getTargetSaturation;

- (float)getTargetLuma;

- (void)normalizeWeights;

- (NSString*)getTargetKey;

+ (NSString*)getTargetModeKey:(NLAdPaletteTargetMode)mode;

@end
