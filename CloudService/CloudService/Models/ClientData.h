//
//  ClientData.h
//  CloudService
//
//  Created by 安永超 on 16/3/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientData : NSObject

@property (nonatomic, assign)int assign;
@property (nonatomic, copy)NSString *assignTime;
@property (nonatomic, copy)NSString *assignUserId;
@property (nonatomic, copy)NSString *cappld;
@property (nonatomic, assign)int cityId;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *custName;
@property (nonatomic, copy)NSString *engineNo;
@property (nonatomic, copy)NSString *frameNo;
@property (nonatomic,assign)int handled;
@property (nonatomic, copy)NSString *clientId;
@property (nonatomic, copy)NSString *licenseNo;
@property (nonatomic, copy)NSString *phoneNo;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *baseId;
@property (nonatomic, copy)NSString *endCode;
@end
