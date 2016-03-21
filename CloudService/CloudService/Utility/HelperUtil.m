//
//  HelperUtil.m
//  SQLite（购物）
//
//  Created by Yock Deng on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "HelperUtil.h"
#import <CommonCrypto/CommonDigest.h>

#define LocalStr_None  @""

@implementation HelperUtil

+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr{
    if ([fromString isEqualToString:@""] || [fromString isEqualToString:@"(null)"] || [fromString isEqualToString:@"<null>"] || [fromString isEqualToString:@"null"] || fromString==nil) {
        return nullStr;
    }else{
        return fromString;
    }
}
+ (NSString *)htmlShuangyinhao:(NSString *)values{
    if (values == nil) {
        return @"";
    }
    /*
     字符串的替换
     注：将字符串中的参数进行替换
     参数1：目标替换值
     参数2：替换成为的值
     参数3：类型为默认：NSLiteralSearch
     参数4：替换的范围
     */
    NSMutableString *temp = [NSMutableString stringWithString:values];
    [temp replaceOccurrencesOfString:@"\"" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    return temp;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor colorWithWhite:1.0 alpha:0.5];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor colorWithWhite:1.0 alpha:0.5];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//根据经纬度算距离
+( CLLocationDistance)meterKiloHaveHowLong:(float)orginLatitude wei:(float)orginlongitude arrJing:(float)arrivewLocationJing arrWei:(float)arriLocationWei{
    CLLocation*orign=[[CLLocation alloc]initWithLatitude:orginLatitude longitude:orginlongitude];
    CLLocation*dist=[[CLLocation alloc]initWithLatitude:arrivewLocationJing longitude:arriLocationWei];
    CLLocationDistance kilometers=[orign distanceFromLocation:dist]/1000;
    
    return kilometers;
}

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


+ (BOOL)checkMailInput:(NSString *)mail{
    NSString *Regex = @"[A-Z0-9a-z._%+-]{2,10}@[A-Za-z0-9.-]{0,8}.[A-Za-z]{2,4}";
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if ([pre evaluateWithObject:mail]) {
        return YES;
    }
    else{
        return NO;
    }
}


+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time>0&&time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time>60&&time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time>60*60&&time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
    
}
+ (NSString *)timeFormat:(NSString *)date format:(NSString *)dateFormat
{
    
    
    NSTimeInterval time=([date doubleValue]+28800)/1000;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:dateFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+ (NSString *) returnUploadTime:(NSString *)timeStr
{
    //Tue May 21 10:56:45 +0800 2013
    
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    if (cha/60<1) {
        timeString = [NSString stringWithFormat:@"%f",cha];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@秒前", timeString];
    }
    if (cha/60>1&&cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        //        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        //        [dateformatter setDateFormat:@"HH:mm"];
        //        timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        
    }
    if (cha/86400>1)
    {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        //        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        
    }
    
    return timeString;
}

+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}


+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}



+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[X])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}


+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}


+ (BOOL) checkNickname:(NSString *) nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

+ (BOOL)checkBankCard: (NSString *) bankCard
{
    BOOL flag;
    if (bankCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^\\d{16,19}$|^\\d{6}[- ]\\d{10,13}$|^\\d{4}[- ]\\d{4}[- ]\\d{4}[- ]\\d{4,7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:bankCard];
    return isMatch;
}
+ (BOOL)validateCarNo:(NSString *) carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

/**
 车架号验证 MODIFIED BY HELENSONG
 */
+ (BOOL)validateCarFrame:(NSString *) carFrame {
    NSString *carRegex = @"^[a-zA-Z0-9]{17}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carFrame];
}
/**
 发动机号验证 MODIFIED BY HELENSONG
 */
+ (BOOL)validateEngineNo:(NSString *) engineNo {
    NSString *carRegex = @"^[a-zA-Z0-9]{6,}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:engineNo];
}

+(NSString *)getSexWithIdcord:(NSString *)idCord {
    
    NSRange range = NSMakeRange(idCord.length - 2, 1);
    NSString *numStr = [idCord substringWithRange:range];
    int num = (int )[numStr integerValue];
    if (num % 2 == 1) {
        return @"男";
    }else {
        return @"女";
    }
}

+(NSString *)getBorthDayWithIdCord:(NSString *)idCord {
    NSRange range = NSMakeRange(6, 4);
    return [idCord substringWithRange:range];
}

+(NSString *)getDateWithDateStr:(NSString *)dateStr {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//格式化
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    long time2 = (long )(time * 1000);
    return [NSString stringWithFormat:@"%ldL",time2];
}
/** 
 *
 *消失键盘
 */
+ (void)resignKeyBoardInView:(UIView *)view

{
    
    for (UIView *v in view.subviews) {
        
        if ([v.subviews count] > 0) {
            
            [self resignKeyBoardInView:v];
            
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            
            [v resignFirstResponder];
            
        }
        
    }
    
}
/**
 *
 *获取网络状态
 */
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
@end
