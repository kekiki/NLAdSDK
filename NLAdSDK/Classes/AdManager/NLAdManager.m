//
//  NLAdManager.m
//  Novel
//
//  Created by Ke Jie on 2020/9/2.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdManager.h"
#import "NLAdDispatchManager.h"

@implementation NLAdManager

+ (instancetype)sharedManager {
    static NLAdManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems {
    [[NLAdDispatchManager sharedManager] setupPlaceItems:placeItems];
}

@end
