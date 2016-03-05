//
//  User.m
//  OnePage
//
//  Created by zhangqiang on 15/12/8.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "User.h"
#import <MJExtension.h>

@implementation User

- (NSDictionary *)dictionaryWithModel:(User *)user {
    
    return [user mj_keyValues];
    
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"couponId" : @"id",
             
             };
}

@end
