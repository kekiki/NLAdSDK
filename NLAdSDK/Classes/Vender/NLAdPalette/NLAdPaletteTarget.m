//
//  TRIPPaletteTarget.m
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "NLAdPaletteTarget.h"

const float NLADSDK_TARGET_DARK_LUMA = 0.26f;
const float NLADSDK_MAX_DARK_LUMA = 0.45f;

const float NLADSDK_MIN_LIGHT_LUMA = 0.55f;
const float NLADSDK_TARGET_LIGHT_LUMA = 0.74f;

const float NLADSDK_MIN_NORMAL_LUMA = 0.3f;
const float NLADSDK_TARGET_NORMAL_LUMA = 0.5f;
const float NLADSDK_MAX_NORMAL_LUMA = 0.7f;

const float NLADSDK_TARGET_MUTED_SATURATION = 0.3f;
const float NLADSDK_MAX_MUTED_SATURATION = 0.4f;

const float NLADSDK_TARGET_VIBRANT_SATURATION = 1.0f;
const float NLADSDK_MIN_VIBRANT_SATURATION = 0.35f;

const float NLADSDK_WEIGHT_SATURATION = 0.24f;
const float NLADSDK_WEIGHT_LUMA = 0.52f;
const float NLADSDK_WEIGHT_POPULATION = 0.24f;

const NSInteger NLADSDK_INDEX_MIN = 0;
const NSInteger NLADSDK_INDEX_TARGET = 1;
const NSInteger NLADSDK_INDEX_MAX = 2;

const NSInteger NLADSDK_INDEX_WEIGHT_SAT = 0;
const NSInteger NLADSDK_INDEX_WEIGHT_LUMA = 1;
const NSInteger NLADSDK_INDEX_WEIGHT_POP = 2;

@interface NLAdPaletteTarget()

@property (nonatomic,strong) NSMutableArray *saturationTargets;

@property (nonatomic,strong) NSMutableArray *lightnessTargets;

@property (nonatomic,strong) NSMutableArray* weights;

@property (nonatomic,assign) BOOL isExclusive; // default to true

@property (nonatomic,assign) NLAdPaletteTargetMode mode;

@end

@implementation NLAdPaletteTarget

- (instancetype)initWithTargetMode:(NLAdPaletteTargetMode)mode{
    self = [super init];
    if (self){
        _mode = mode;
        [self initParams];
        [self configureLumaAndSaturationWithMode:mode];
    }
    return self;
}

- (void)initParams{
    _saturationTargets = [[NSMutableArray alloc]init];
    _lightnessTargets = [[NSMutableArray alloc]init];
    _weights = [[NSMutableArray alloc]init];
    
    [self setDefaultWeights];
    [self setDefaultLuma];
    [self setDefaultSaturation];
}

#pragma mark - configure luma and saturation with mode

- (void)configureLumaAndSaturationWithMode:(NLAdPaletteTargetMode)mode{
    switch (mode) {
        case NLADSDK_LIGHT_VIBRANT_PALETTE:
            [self setDefaultLightLuma];
            [self setDefaultVibrantSaturation];
            break;
        case NLADSDK_VIBRANT_PALETTE:
            [self setDefaultNormalLuma];
            [self setDefaultVibrantSaturation];
            break;
        case NLADSDK_DARK_VIBRANT_PALETTE:
            [self setDefaultDarkLuma];
            [self setDefaultVibrantSaturation];
            break;
        case NLADSDK_LIGHT_MUTED_PALETTE:
            [self setDefaultLightLuma];
            [self setDefaultMutedSaturation];
            break;
        case NLADSDK_MUTED_PALETTE:
            [self setDefaultNormalLuma];
            [self setDefaultMutedSaturation];
            break;
        case NLADSDK_DARK_MUTED_PALETTE:
            [self setDefaultDarkLuma];
            [self setDefaultMutedSaturation];
            break;
        default:
            break;
    }
}

- (void)setDefaultWeights{
    [_weights addObject:[NSNumber numberWithFloat:NLADSDK_WEIGHT_SATURATION]];
    [_weights addObject:[NSNumber numberWithFloat:NLADSDK_WEIGHT_LUMA]];
    [_weights addObject:[NSNumber numberWithFloat:NLADSDK_WEIGHT_POPULATION]];
}

- (void)setDefaultLuma{
    [_lightnessTargets addObject:[NSNumber numberWithFloat:0.0f]];
    [_lightnessTargets addObject:[NSNumber numberWithFloat:0.5f]];
    [_lightnessTargets addObject:[NSNumber numberWithFloat:1.0f]];
}

- (void)setDefaultSaturation{
    [_saturationTargets addObject:[NSNumber numberWithFloat:0.0f]];
    [_saturationTargets addObject:[NSNumber numberWithFloat:0.5f]];
    [_saturationTargets addObject:[NSNumber numberWithFloat:1.0f]];
}

- (void)setDefaultLightLuma{
    _lightnessTargets[NLADSDK_INDEX_MIN] = [NSNumber numberWithFloat:NLADSDK_MIN_LIGHT_LUMA];
    _lightnessTargets[NLADSDK_INDEX_TARGET] = [NSNumber numberWithFloat:NLADSDK_TARGET_LIGHT_LUMA];
}

- (void)setDefaultNormalLuma{
    _lightnessTargets[NLADSDK_INDEX_MIN] = [NSNumber numberWithFloat:NLADSDK_MIN_NORMAL_LUMA];
    _lightnessTargets[NLADSDK_INDEX_TARGET] = [NSNumber numberWithFloat:NLADSDK_TARGET_NORMAL_LUMA];
    _lightnessTargets[NLADSDK_INDEX_MAX] = [NSNumber numberWithFloat:NLADSDK_MAX_NORMAL_LUMA];
}

- (void)setDefaultDarkLuma{
    _lightnessTargets[NLADSDK_INDEX_TARGET] = [NSNumber numberWithFloat:NLADSDK_TARGET_DARK_LUMA];
    _lightnessTargets[NLADSDK_INDEX_MAX] = [NSNumber numberWithFloat:NLADSDK_MAX_DARK_LUMA];
}

- (void)setDefaultMutedSaturation{
    _saturationTargets[NLADSDK_INDEX_TARGET] = [NSNumber numberWithFloat:NLADSDK_TARGET_MUTED_SATURATION];
    _saturationTargets[NLADSDK_INDEX_MAX] = [NSNumber numberWithFloat:NLADSDK_MAX_MUTED_SATURATION];
}

- (void)setDefaultVibrantSaturation{
    _saturationTargets[NLADSDK_INDEX_MIN] = [NSNumber numberWithFloat:NLADSDK_MIN_VIBRANT_SATURATION];
    _saturationTargets[NLADSDK_INDEX_TARGET] = [NSNumber numberWithFloat:NLADSDK_TARGET_VIBRANT_SATURATION];
}

#pragma mark - getter

- (float)getMinSaturation{
    return [_saturationTargets[NLADSDK_INDEX_MIN] floatValue];
}

- (float)getMaxSaturation{
    NSInteger maxIndex;
    maxIndex = MIN(NLADSDK_INDEX_MAX, _saturationTargets.count - 1);
    return [_saturationTargets[maxIndex] floatValue];
}

- (float)getMinLuma{
    return [_lightnessTargets[NLADSDK_INDEX_MIN] floatValue];
}

- (float)getMaxLuma{
    NSInteger maxIndex;
    maxIndex = NLADSDK_INDEX_MAX>=_lightnessTargets.count?_lightnessTargets.count:NLADSDK_INDEX_MAX;
    return [_lightnessTargets[maxIndex] floatValue];

}

- (float)getSaturationWeight{
    return [_weights[NLADSDK_INDEX_WEIGHT_SAT] floatValue];
}

- (float)getLumaWeight{
    return [_weights[NLADSDK_INDEX_WEIGHT_LUMA] floatValue];

}

- (float)getPopulationWeight{
    return [_weights[NLADSDK_INDEX_WEIGHT_POP] floatValue];

}

- (float)getTargetSaturation{
    return [_saturationTargets[NLADSDK_INDEX_TARGET] floatValue];
}

- (float)getTargetLuma{
    return [_lightnessTargets[NLADSDK_INDEX_TARGET] floatValue];
}
#pragma mark - utils

- (NSString*)getTargetKey{
    return [NLAdPaletteTarget getTargetModeKey:_mode];
}


+ (NSString*)getTargetModeKey:(NLAdPaletteTargetMode)mode{
    NSString *key;
    switch (mode) {
        case NLADSDK_LIGHT_VIBRANT_PALETTE:
            key = @"light_vibrant";
            break;
        case NLADSDK_VIBRANT_PALETTE:
            key = @"vibrant";
            break;
        case NLADSDK_DARK_VIBRANT_PALETTE:
            key = @"dark_vibrant";
            break;
        case NLADSDK_LIGHT_MUTED_PALETTE:
            key = @"light_muted";
            break;
        case NLADSDK_MUTED_PALETTE:
            key = @"muted";
            break;
        case NLADSDK_DARK_MUTED_PALETTE:
            key = @"dark_muted";
            break;
        default:
            break;
    }
    return key;
}

- (void)normalizeWeights{
    float sum = 0;
    for (NSUInteger i = 0, z = [_weights count]; i < z; i++) {
        float weight = [_weights[i] floatValue];
        if (weight > 0) {
            sum += weight;
        }
    }
    if (sum != 0) {
        for (NSUInteger i = 0, z = [_weights count]; i < z; i++) {
            if ([_weights[i] floatValue] > 0) {
                float weight = [_weights[i] floatValue];
                weight /= sum;
                _weights[i] = [NSNumber numberWithFloat:weight];
            }
        }
    }
}

@end
