//
//  BankInfoData.h
//  CloudService
//
//  Created by zhangqiang on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
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

/**
 *  公司名转编码
 */
+ (NSString *)changeCompanyCodeToText:(NSString *)code;

/**
 *  编码转公司名
 */
+ (NSString *)changeCompanyTextToCode:(NSString *)name;

/**
 *  所有省
 */
+(NSArray *)provinceArray;

/**
 *  省对应编码
 */
+(NSDictionary *)provinceCodeDict;

/**
 *  编码转汉字
 */
+(NSString *)changeSaleCompanyWithCodeString:(NSString *)codeStr;

/**
 *  编码转数组
 */
+(NSArray *)changeSaleCompanyWithString:(NSString *)codeStr;
@end
