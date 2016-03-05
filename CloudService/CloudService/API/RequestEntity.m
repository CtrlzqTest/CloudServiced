//
//  RequestEntity.m
//  DaoWei
//
//  Created by zhangqiang on 15/10/14.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "RequestEntity.h"
#import "RestAPI.h"
#import "RequestManager.h"
#import "MHNetwrok.h"

@implementation RequestEntity
// 登录
+(void)LoginWithUserName:(NSString *)userName
                passWord:(NSString *)passWord
                address:(NSString *)addDress
                success:(void (^)(id responseObject, NSError *error))success
                failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        [paramer setObject:userName forKey:@"userName"];
        [paramer setValue:passWord forKey:@"password"];
        [paramer setValue:addDress forKey:@"address"];
        [RequestManager startRequest:kLoginAPI paramer:paramer method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject,error);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

// 注册
+(void)registerWithPhoneNum:(NSString *)PhoneNum
                   passWord:(NSString *)passWord
                    address:(NSString *)addDress
                       code:(NSString *)code
                 success:(void (^)(id responseObject, NSError *error))success
                 failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        [paramer setObject:PhoneNum forKey:@"phoneNo"];
        [paramer setValue:passWord forKey:@"password"];
        [paramer setValue:addDress forKey:@"address"];
        [paramer setValue:code forKey:@"code"];
        [RequestManager startRequest:kRegisterAPI paramer:paramer method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject,error);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

// 获取验证码
+(void)getCodeWithUserPhoneNum:(NSString *)phoneNum
                 success:(void (^)(id responseObject, NSError *error))success
                 failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:phoneNum forKey:@"phoneNo"];
        [RequestManager startRequest:kGetCodeAPI paramer:param method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

// 个人信息查询
+(void)getUserInfoWithUserId:(NSString *)userId
                       success:(void (^)(id responseObject, NSError *error))success
                       failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:userId forKey:@"userid"];
        [RequestManager startRequest:kGetuserInfoAPI paramer:param method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

+(void)resetUserInfoWithUserInfo:(NSDictionary *)userInfo
                         success:(void (^)(id responseObject, NSError *error))success
                         failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        
        [RequestManager startRequest:kResetUserInfoAPI paramer:userInfo method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

// 签到
+(void)signedWithUserId:(NSString *)userId
                address:(NSString *)address
                success:(void (^)(id responseObject, NSError *error))success
                failure:(void (^)(NSError *error))failure
{
    @try {
        NSError *error = nil;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:userId forKey:@"userid"];
        [param setValue:address forKey:@"address"];
        [RequestManager startRequest:kSignedAPI paramer:param method:RequestMethodPost success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[[exception callStackSymbols] componentsJoinedByString:@"\n"]);
    }
}

+(NSString *)urlString:(NSString *)kString {
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",BaseAPI,kString]);
    return [NSString stringWithFormat:@"%@%@",BaseAPI,kString];
}
@end
