//
//  NLAdViewProtocol.h
//  Novel
//
//  Created by Ke Jie on 2020/9/18.
//  Copyright © 2020 panling. All rights reserved.
//

#ifndef NLAdViewProtocol_h
#define NLAdViewProtocol_h

#import <Foundation/Foundation.h>

@protocol NLAdViewProtocol <NSObject>

- (void)setupAdModel:(__kindof NSObject *)adModel;

@end

#endif /* NLAdViewProtocol_h */
