//
//  SingleHandle.h
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleHandle : NSObject
+(SingleHandle *)shareSingleHandle ;
@property(nonatomic,strong)NSString *isHidden;
@end
