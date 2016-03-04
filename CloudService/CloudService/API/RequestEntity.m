//
//  RequestEntity.m
//  DaoWei
//
//  Created by zhangqiang on 15/10/14.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "RequestEntity.h"
#import "RestAPI.h"
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
 
        
        [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kLoginAPI] params:paramer successBlock:^(NSDictionary *returnData) {
            
            success(returnData,error);
        } failureBlock:^(NSError *error) {
            
            failure(error);
        } showHUD:NO];
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
