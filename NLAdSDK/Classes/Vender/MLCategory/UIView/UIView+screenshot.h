//
//  UIView+screenshot.h
//  jdApp
//
//  Created by SquRab on 2019/4/28.
//  Copyright © 2019 squrab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (screenshot)

- (UIImage *)screenshot;
- (UIImage *)screenshotWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
