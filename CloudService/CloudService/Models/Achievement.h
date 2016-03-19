//
//  Achievement.h
//  CloudService
//
//  Created by 安永超 on 16/3/7.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject

@property (nonatomic, assign)int orderNum;
@property (nonatomic, assign)float totalPremium;
@property (nonatomic, copy)NSString *realName;
@property (nonatomic, copy)NSString *userNum;
@property (nonatomic, copy)NSString *resultTime;
@end
