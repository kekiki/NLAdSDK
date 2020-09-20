//
//  NLReadAdObject.h
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NLReadAdObject : NSObject

@property (nonatomic, assign, readonly) NLAdPlaceCode placeCode;
@property (nonatomic, assign, readonly) NLAdPlatform adPlatform;
@property (nonatomic, strong, readonly) __kindof NSObject *adObject;

- (instancetype)initWithPlaceCode:(NLAdPlaceCode)placeCode
                       adPlatform:(NLAdPlatform)adPlatform
                         adObject:(__kindof NSObject *)adObject;

@end

NS_ASSUME_NONNULL_END
