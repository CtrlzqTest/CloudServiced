//
//  HelperUtil.h
//  SQLite（购物）
//
//  Created by Yock Deng on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HelperUtil : NSObject
/**替换双引号
 */
+ (NSString *)htmlShuangyinhao:(NSString *)values;
/** 颜色
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
/** 替换空字符串
 */
+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr;
/** 根据经纬度算距离
 */
+( CLLocationDistance)meterKiloHaveHowLong:(float)orginLatitude wei:(float)orginlongitude arrJing:(float)arrivewLocationJing arrWei:(float)arriLocationWei;
/** MD5加密
 */
+ (NSString *)md5HexDigest:(NSString*)input;
/** 计算时间差
 */
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate;
/** 时间戳转时间
 */
+ (NSString *)timeFormat:(NSString *)date format:(NSString *)dateFormat;
/** 计算时间差
 */
+ (NSString *) returnUploadTime:(NSString *)timeStr;

/** 正则匹配邮箱号
 */
+ (BOOL)checkMailInput:(NSString *)mail;
/** 正则匹配手机号
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;
/** 正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/** 正则匹配用户姓名,20位的中文或英文
 */
+ (BOOL)checkUserName : (NSString *) userName;

/** 正则匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;

/** 正则匹员工号,12位的数字
 */
+ (BOOL)checkEmployeeNumber : (NSString *) number;

/** 正则匹配URL
 */
+ (BOOL)checkURL : (NSString *) url;

/** 正则匹配昵称
 */
+ (BOOL) checkNickname:(NSString *) nickname;
/**
 *  正则匹配银行卡号
 */
+ (BOOL)checkBankCard: (NSString *) bankCard;

/** 
 车牌号验证 MODIFIED BY HELENSONG
 */
+ (BOOL)validateCarNo:(NSString *) carNo;
/**
 车架号验证 MODIFIED BY HELENSONG
 */
+ (BOOL)validateCarFrame:(NSString *) carFrame;
/**
 发动机号验证 MODIFIED BY HELENSONG
 */
+ (BOOL)validateEngineNo:(NSString *) engineNo;


/**
 *  根据身份证号判别男女
 */
+(NSString *)getSexWithIdcord:(NSString *)idCord;

/**
 *  获取出生年份
 */
+(NSString *)getBorthDayWithIdCord:(NSString *)idCord;

/**
 *  字符串转时间戳
 */
+(NSString *)getDateWithDateStr:(NSString *)dateStr;
/**
 *  消失键盘
 */
+ (void)resignKeyBoardInView:(UIView *)view;
/**
 *  获取网络状态
 */
+(NSString *)getNetWorkStates;
@end
