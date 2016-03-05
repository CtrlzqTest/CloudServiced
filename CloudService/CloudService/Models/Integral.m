//
//  Integral.m
//  CloudService
//
//  Created by 安永超 on 16/3/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "Integral.h"
#import <MJExtension.h>

@implementation Integral
- (NSDictionary *)dictionaryWithModel:(Integral *)integral {
    return [integral mj_keyValues];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"creditsId" : @"id",
             
             };
}

@end
