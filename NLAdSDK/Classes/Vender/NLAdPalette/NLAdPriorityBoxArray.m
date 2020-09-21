//
//  NLAdPriorityBoxArray.m
//  iOSPalette
//
//  Created by 凡铁 on 17/6/3.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import "NLAdPriorityBoxArray.h"
#import "NLAdPalette.h"
//you must import the NLAdPalette.h file , or you'll get the compile error

@interface NLAdPriorityBoxArray ()

@property (nonatomic,strong) NSMutableArray *vboxArray;

@end

@implementation NLAdPriorityBoxArray

- (instancetype)init{
    self = [super init];
    if (self){
        _vboxArray = [[NSMutableArray alloc]init];
    }
    return self;
}

//with the volume comparator
- (void)addVBox:(NLAdVBox*)box{
    
    if (![box isKindOfClass:[NLAdVBox class]]){
        return;
    }
    if ([_vboxArray count] <= 0){
        [_vboxArray addObject:box];
        return;
    }
    
    for (int i = 0 ; i < [_vboxArray count] ; i++){
        NLAdVBox *nowBox = (NLAdVBox*)[_vboxArray objectAtIndex:i];
        
        if ([box getVolume] > [nowBox getVolume]){
            [_vboxArray insertObject:box atIndex:i];
            if (_vboxArray.count > kMaxColorNum){
                [_vboxArray removeObjectAtIndex:kMaxColorNum];
            }
            return;
        }
        
        if ((i == [_vboxArray count] - 1) && _vboxArray.count < kMaxColorNum){
            [_vboxArray addObject:box];
            
            return;
        }
    }
}

- (id)objectAtIndex:(NSInteger)i{
    return [_vboxArray objectAtIndex:i];
}

- (id)poll{
    if (_vboxArray.count <= 0){
        return nil;
    }
    id headObject = [_vboxArray objectAtIndex:0];
    [_vboxArray removeObjectAtIndex:0];
    return headObject;
}

- (NSUInteger)count{
    return _vboxArray.count;
}

- (NSMutableArray*)getVBoxArray{
    return _vboxArray;
}
@end
