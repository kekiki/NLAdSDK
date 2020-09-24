//
//  NLVungleAdLoader.h
//  Novel
//
//  Created by Ray Tao on 2020/9/21.
//  Copyright © 2020 panling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLPlatformAdLoaderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface NLVungleAdLoader : NSObject <NLPlatformAdLoaderProtocol>
@property (nonatomic, weak, nullable) id<NLPlatformAdLoaderDelegate> delegate;

+ (instancetype)sharedLoader;
@end

NS_ASSUME_NONNULL_END
