//
//  Integral.h
//  CloudService
//
//  Created by 安永超 on 16/3/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Integral : NSObject

@property (nonatomic, copy)NSString *comment;
@property (nonatomic, assign)int creditsNum;
@property (nonatomic, copy)NSString *creditsId;
@property (nonatomic, copy)NSString *reason;
@property (nonatomic, copy)NSString *relatedId;
@property (nonatomic, copy)NSString *result;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *type;

@end
