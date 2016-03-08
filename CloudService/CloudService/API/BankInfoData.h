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

/**
 *  保险公司
 */
+(NSArray *)insureCommpanyNameArray;

/**
 *  保险公司编码
 */
+(NSArray *)insureCommpanyCodeArray;

@end
