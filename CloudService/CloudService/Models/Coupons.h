//
//  Coupons.h
//  CloudService
//
//  Created by 安永超 on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupons : NSObject

@property (nonatomic, assign)int amount;
@property (nonatomic, copy)NSString *couponName;
@property (nonatomic, assign)int couponNum;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *ctype;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *couponId;
@property (nonatomic, copy)NSString *startTime;


- (NSDictionary *)dictionaryWithModel:(Coupons *)coupons;
@end
