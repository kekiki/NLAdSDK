//
//  NLAdModelProtocol.h
//  Novel
//
//  Created by Ke Jie on 2020/9/4.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NLAdPlatformModelProtocol <NSObject>

/// 平台广告ID
@property (nonatomic, copy, nullable, readonly) NSString *platformAdId;

/// 平台类型：1、Admob， 2、Facebook
@property (nonatomic, assign, readonly) NSInteger platformType;

@end

@protocol NLAdPlaceModelProtocol <NSObject>

/// 广告位编码，见NLAdPlaceCode
@property (nonatomic, assign, readonly) NLAdPlaceCode adPlaceCode;

/// 广告平台列表
@property (nonatomic, strong, nullable, readonly) NSArray<NLAdPlatformModelProtocol> *adPlatformList;

@end

NS_ASSUME_NONNULL_END
