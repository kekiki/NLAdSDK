//
//  NLAdManager.h
//  Novel
//
//  Created by Ke Jie on 2020/9/2.
//  Copyright © 2020 panling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NLAdModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
广告聚合管理者类
 
 对外公开，所有广告的沟通都通过该类进行
*/
@interface NLAdManager : NSObject

/// 单利
+ (instancetype)sharedManager;

/// 设置广告位条目列表
/// 广告的调度分发都是根据条目列表进行的
///
/// @param placeItems 广告位条目列表
- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems;

@end

NS_ASSUME_NONNULL_END
