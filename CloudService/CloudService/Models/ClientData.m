//
//  ClientData.m
//  CloudService
//
//  Created by 安永超 on 16/3/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ClientData.h"

@implementation ClientData
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"clientId" : @"id",
             
             };
}

@end
