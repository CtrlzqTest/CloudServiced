//
//  SingleHandle.h
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface SingleHandle : NSObject
+(SingleHandle *)shareSingleHandle;

@end
