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
/**
 *  注册
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param addDress 地址
 *  @param code     验证码
 *  @param success
 *  @param failure  
 */
+(void)registerWithPhoneNum:(NSString *)PhoneNum
                   passWord:(NSString *)passWord
                    address:(NSString *)addDress
                       code:(NSString *)code
                    success:(void (^)(id responseObject, NSError *error))success
                    failure:(void (^)(NSError *error))failure;
/**
 *  获取验证码
 *
 *  @param phoneNum 手机号
 *  @param success
 *  @param failure
 */
+(void)getCodeWithUserPhoneNum:(NSString *)phoneNum
                       success:(void (^)(id responseObject, NSError *error))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  获取用户信息
 *
 *  @param userId  用户ID
 *  @param success
 *  @param failure
 */
+(void)getUserInfoWithUserId:(NSString *)userId
                         success:(void (^)(id responseObject, NSError *error))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  修改用户信息
 *
 *  @param userInfo 用户信息
 *  @param success
 *  @param failure
 */
+(void)resetUserInfoWithUserInfo:(NSDictionary *)userInfo
                         success:(void (^)(id responseObject, NSError *error))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  签到
 *
 *  @param userId  用户名
 *  @param address 地址
 *  @param success
 *  @param failure
 */
+(void)signedWithUserId:(NSString *)userId
                address:(NSString *)address
                success:(void (^)(id responseObject, NSError *error))success
                failure:(void (^)(NSError *error))failure;


+(NSString *)urlString:(NSString *)kString;

@end
