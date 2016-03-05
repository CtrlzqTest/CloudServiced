//
//  Coupons.m
//  CloudService
//
//  Created by 安永超 on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "Coupons.h"
#import <MJExtension.h>

@implementation Coupons
- (NSDictionary *)dictionaryWithModel:(Coupons *)coupons {
    return [coupons mj_keyValues];
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"couponId" : @"id",
            
             };
}

@end
