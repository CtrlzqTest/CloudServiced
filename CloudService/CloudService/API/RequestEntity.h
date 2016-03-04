//
//  RequestEntity.h
//  DaoWei
//
//  Created by zhangqiang on 15/10/14.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestEntity : NSObject

/**
 *  登录
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param addDress 地址
 *  @param success
 *  @param failure
 */
+(void)LoginWithUserName:(NSString *)userName
                passWord:(NSString *)passWord
                 address:(NSString *)addDress
                 success:(void (^)(id responseObject, NSError *error))success
                 failure:(void (^)(NSError *error))failure;
@end
