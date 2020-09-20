//
//  NLReadAdObject.m
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLReadAdObject.h"

@interface NLReadAdObject()

@property (nonatomic, assign, readwrite) NLAdPlaceCode placeCode;
@property (nonatomic, assign, readwrite) NLAdPlatform adPlatform;
@property (nonatomic, strong, readwrite) __kindof NSObject *adObject;

@end

@implementation NLReadAdObject

- (instancetype)initWithPlaceCode:(NLAdPlaceCode)placeCode
                       adPlatform:(NLAdPlatform)adPlatform
                         adObject:(__kindof NSObject *)adObject {
    self = [super init];
    if (self) {
        self.placeCode = placeCode;
        self.adPlatform = adPlatform;
        self.adObject = adObject;
    }
    return self;
}

@end
