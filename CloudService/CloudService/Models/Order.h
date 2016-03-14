//
//  Order.h
//  CloudService
//
//  Created by 安永超 on 16/3/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, copy)NSString *orderId;
@property (nonatomic, copy)NSString *orderStatus;
@property (nonatomic, copy)NSString *licenseNo;
@property (nonatomic, copy)NSString *customerName;
@property (nonatomic, copy)NSString *biPremium;
@property (nonatomic, copy)NSString *ciPremium;
@property (nonatomic, copy)NSString *vehicleTaxPremium;
@property (nonatomic, copy)NSString *customerId;
@property (nonatomic, copy)NSString *endCode;
@property (nonatomic, copy)NSString *phoneNo;
@end
