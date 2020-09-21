//
//  NLAdPriorityBoxArray.h
//  iOSPalette
//
//  Created by 凡铁 on 17/6/3.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NLAdVBox;

//A queue like PriorityQueue in Java

@interface NLAdPriorityBoxArray : NSObject

- (void)addVBox:(NLAdVBox*)box;

- (NLAdVBox*)objectAtIndex:(NSInteger)i;

//Get the header element and delete it
- (NLAdVBox*)poll;

- (NSUInteger)count;

- (NSMutableArray*)getVBoxArray;

@end
