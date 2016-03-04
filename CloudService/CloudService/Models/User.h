//
//  User.h
//  OnePage
//
//  Created by zhangqiang on 15/12/8.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *applySaleCompany;
@property(nonatomic,copy)NSString *chatName;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *oldPost;
@property(nonatomic,copy)NSString *phoneNo;
@property(nonatomic,copy)NSString *photoUrl;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *registerTime;

@property(nonatomic,copy)NSString *roleId;
@property(nonatomic,copy)NSString *roleName;
@property(nonatomic,copy)NSString *saleCity;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *workStartDate;

- (NSDictionary *)dictionaryWithModel:(User *)user;

@end
