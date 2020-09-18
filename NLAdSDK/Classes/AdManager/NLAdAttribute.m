//
//  NLAdAttributeConfiguration.m
//  Novel
//
//  Created by Ke Jie on 2020/9/7.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdAttribute.h"

@implementation NLAdAttribute

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = [UIColor blackColor];
        self.detailColor = [UIColor grayColor];
        self.iconAlpha = 1.0f;
        self.mediaAlpha = 1.0f;
        self.buttonTitleColor = [UIColor whiteColor];
        self.buttonBackgroundColor = [UIColor clearColor];
        self.buttonTitleColor = [UIColor blackColor];
        self.buttonBorderColor = [UIColor blackColor];
    }
    return self;
}

+ (instancetype)defaultConfiguration {
    return [[NLAdAttribute alloc] init];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NLAdAttribute *configuration = [[NLAdAttribute allocWithZone:zone] init];
    configuration.titleColor = self.titleColor;
    configuration.detailColor = self.detailColor;
    return configuration;
}

@end
