//
//  NLAdAdapter.h
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 广告适配器
@interface NLAdAdapter : NSObject

/// 设置广告位条目列表
/// 广告的调度分发都是根据条目列表进行的
///
/// @param placeItems 广告位条目列表
- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems;

/// 获取广告位ID
/// @param placeCode 广告位代码
- (nullable NSString *)placeIdWithCode:(NLAdPlaceCode)placeCode;

/// 获取广告平台
/// @param placeCode 广告位代码
- (NSInteger)platformWithCode:(NLAdPlaceCode)placeCode;

/// 转换到下一个
/// @param placeCode 广告位代码
- (void)switchToNextWithCode:(NLAdPlaceCode)placeCode;

@end

NS_ASSUME_NONNULL_END
