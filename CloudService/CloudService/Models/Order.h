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
@property (nonatomic, copy)NSString *cappld;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, copy)NSString *engineNo;
@property (nonatomic, copy)NSString *frameNo;
@property (nonatomic, copy)NSString *cityCode;
@property (nonatomic, copy)NSString *vehicleModelName;
@property (nonatomic, copy)NSString *primaryDate;
@property (nonatomic, copy)NSString *baseId;
@end

