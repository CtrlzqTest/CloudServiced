//
//  Utility.h
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

/**
 *  SHA-256加密算法
 */
+ (NSString*)sha256WithString:(NSString *)string;

/**
 *  获取用户信息
 *
 *  @return 用户信息
 */
+(NSDictionary *)getUserInfoFromLocal;

/**
 *  存储用户信息
 *
 *  @param dict 用户信息
 */
+(void)saveUserInfo:(NSDictionary *)dict;

/**
 *  设置登录状态
 *
 *  @param isLogin 是否登录
 */
+(void)setLoginStates:(BOOL )isLogin;

/**
 *  登录状态
 *
 *  @return 是否登录
 */
+(BOOL )isLogin;

/**
 *  版本检测
 *
 *  @param versionCheckBlock 是否有新版本
 */
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock;

/**
 *  获取定位城市
 */
+ (NSString *)location;

/**
 *  存储定位城市
 */
+ (void)saveLocation:(NSString *)locate;

/**
 *  是否记住密码
 */
+ (BOOL)isRemberPassWord;

/**
 *  是否记住密码
 */

+(void)remberPassWord:(BOOL )isRemberPwd;

/**
 *  获取用户密码
 */
+(NSString *)passWord;

/**
 *  获取用户名
 */
+(NSString *)userName;

/**
 *  保存用户密码和用户名
 */
+(void)saveUserName:(NSString *)userName passWord:(NSString *)passWord;
/**
 *  保存版本号
 */
+(void)saveVersion:(BOOL )isNewVersion;
/**
 *  是否有最新版本
 */
+(BOOL )isNewVersion;
@end
