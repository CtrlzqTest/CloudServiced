//
//  SingleHandle.m
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SingleHandle.h"
#import "Utility.h"

static SingleHandle *singleHandle = nil;
@implementation SingleHandle

+(SingleHandle *)shareSingleHandle {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleHandle = [[SingleHandle alloc] init];
    });
    return singleHandle;
}

- (User *)getUserInfo {
    if (!self.user) {
        self.user = [[User alloc] init];
        self.user = [User mj_objectWithKeyValues:[Utility getUserInfoFromLocal]];
    }
    return self.user;
}

-(void)saveUserInfo:(User *)userModel {
    
    self.user = userModel;
    NSDictionary *dict = [userModel mj_keyValues];
    [Utility saveUserInfo:dict];
    
}

- (NSArray *)getEndCodeArray {
    NSArray *array = @[@"初始",
                       @"已报价",
                       @"未报价",
                       @"未联系到",
                       @"空错号",
                       @"到期日不准",
                       @"客户毁单",
                       @"客户拒绝",
                       @"费用少",
                       @"无效数据",
                       @"成交"];
    return array;
}

@end
