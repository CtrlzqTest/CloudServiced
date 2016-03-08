//
//  SingleHandle.h
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface SingleHandle : NSObject
@property (nonatomic,strong)User *user;
+(SingleHandle *)shareSingleHandle;

/**
 *  获取用户信息model
 */
- (User *)getUserInfo;

/**
 *  存储用户信息
 */
- (void)saveUserInfo:(User *)userModel;
/**
 *  获取结束码
 */
- (NSArray *)getEndCodeArray;

@end
