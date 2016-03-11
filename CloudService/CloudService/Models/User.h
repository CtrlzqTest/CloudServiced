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
@property(nonatomic,copy)NSString *userType;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *age;             // 地址编码
@property(nonatomic,copy)NSString *applySaleCompany;
@property(nonatomic,copy)NSString *chatName;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *oldPost;
@property(nonatomic,copy)NSString *phoneNo;
@property(nonatomic,copy)NSString *photoUrl;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *registerTime;
@property(nonatomic,copy)NSString *oldCompany;

@property(nonatomic,copy)NSString *roleId;
@property(nonatomic,copy)NSString *roleName;
@property(nonatomic,copy)NSString *saleCity;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *workStartDate;
@property(nonatomic,copy)NSString *saleCityValue;

// 银行信息
@property(nonatomic,copy)NSString *accountCity;  // 市
@property(nonatomic,copy)NSString *accountProvinces; // 省
@property(nonatomic,copy)NSString *bankAccountName;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString *bankNum;
@property(nonatomic,copy)NSString *bankId;      // 银行卡号ID
@property(nonatomic,copy)NSString *subbranchName; // 支行

// 签到
@property(nonatomic,copy)NSString *sign;

// 积分
@property(nonatomic,copy)NSNumber *totalNum;
@property(nonatomic,copy)NSNumber *frozenNum;
@property(nonatomic,copy)NSNumber *usableNum;

- (NSDictionary *)dictionaryWithModel:(User *)user;

@end
