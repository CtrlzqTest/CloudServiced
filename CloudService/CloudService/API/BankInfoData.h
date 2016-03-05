//
//  BankInfoData.h
//  CloudService
//
//  Created by zhangqiang on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankInfoData : NSObject
/**
 *  银行开头
 */
+(NSArray *)bankBin;

/**
 *  开户银行
 */
+(NSArray *)bankNameArray;

@end
