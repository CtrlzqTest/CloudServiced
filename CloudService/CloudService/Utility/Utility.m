//
//  Utility.m
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "Utility.h"
#import "User.h"
#import <MJExtension.h>

static User *user = nil;

@implementation Utility

+ (User *)shareUser {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        user = [User mj_objectWithKeyValues:infoDict];
    });
    return user;
}

+ (BOOL)isFirstLoadding {
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return !flag;
}

+(void)setLoginStates:(BOOL )isLogin {
    
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL )isLogin {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
}

+ (NSString *)location {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"locate"];
}

+(NSDictionary *)getUserInfoFromLocal
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    return dict;
}

+(void)saveUserInfo:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveLocation:(NSString *)locate {
    
    [[NSUserDefaults standardUserDefaults] setValue:locate forKey:@"locate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isRemberPassWord {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"remberPassWord"];
}

+(void)remberPassWord:(BOOL )isRemberPwd {
    
    [[NSUserDefaults standardUserDefaults] setBool:isRemberPwd forKey:@"remberPassWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveUserName:(NSString *)userName passWord:(NSString *)passWord {
    
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:passWord forKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString *)userName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
}

+(NSString *)passWord {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"passWord"];
}

+ (NSString *)changeStrArraytoString:(NSArray *)array {
    NSMutableString *result = [NSMutableString string];
    for (NSString *str in array) {
        [result appendString:str];
        [result appendString:@","];
    }
    return [result substringToIndex:result.length - 1];
}

+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock{
    
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
////    NSLog(@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]);
//    __block double currentVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] doubleValue];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"IOS" forKey:@"clientType"];
//    [RequestManager startRequest:kCheckNewVersionAPI paramer:dict method:(RequestMethodPost) success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = [responseObject objectForKey:@"list"];
//        double newVersion = [[dict objectForKey:@"versionNum"] doubleValue];
//        BOOL flag = newVersion > currentVersion;
//        versionCheckBlock(flag);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        versionCheckBlock(NO);
//    }];
}

@end
