//
//  SingleHandle.m
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SingleHandle.h"

static SingleHandle *singleHandle = nil;
@implementation SingleHandle

+(SingleHandle *)shareSingleHandle {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleHandle = [[SingleHandle alloc] init];
    });
    return singleHandle;
}

@end
