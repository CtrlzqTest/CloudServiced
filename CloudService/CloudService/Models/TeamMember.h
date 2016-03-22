//
//  TeamMember.h
//  CloudService
//
//  Created by 安永超 on 16/3/7.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamMember : NSObject
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *userNum;
@property (nonatomic, copy)NSString *phoneNo;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *teamId;
@property (assign, nonatomic)BOOL isCheck;
@property (assign, nonatomic)int moneyNum;
@property (nonatomic, copy)NSString *realName;
@property (nonatomic, copy)NSString *chatName;
@end
