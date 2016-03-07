//
//  RestAPI.h
//  美食厨房
//
//  Created by zhangqiang on 15/8/7.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#ifndef _____RestAPI_h
#define _____RestAPI_h
#import <UIKit/UIKit.h>


#define BaseAPI                 @"http://10.136.96.139:8889/cloudSales-action"  // 阳光服务器

#define kRegisterAPI            @"/app/user/register"                     //注册

#define kLoginAPI               @"/app/user/login"                     //登录

#define kGetCodeAPI             @"/app/user/getCode"                     //获取验证码

#define kGetuserInfoAPI         @"/app/user/findUserInfo"                     //个人信息

#define kGetuserIntergralAPI         @"/app/credits/findUserCredits"                     //我的积分

#define kGetExchangeIntergralAPI         @"/app/credits/exchangeMoney"                    //积分兑换

#define kResetUserInfoAPI       @"/app/user/changeUserInfo"                     //修改个人信息

#define kResetPwdAPI            @"/app/user/changePassword"                     //修改密码

#define kSignedAPI              @"/app/sign/signed"                     //签到

#define kCheckPhoneNumAPI       @"/app/user/verifyPhoneNo"                     //验证手机

#define kSendCode               @"/userapp/sendCode"                     //业绩查询

#define kUserCouponsList        @"/app/coupon/findUserCouponsList"                 //个人业绩查询

#define kTeamCouponsList        @"/app/coupon/findTeamCouponsList"                 //团队业绩查询

#define kfindUserCreditsRecord    @"/app/credits/findUserCreditsRecord"             //积分历史查询

#define kapplyCustomerData     @"/app/customerData/applyCustomerData"             //客户数据申请

#define kfindPersonCustList     @"/app/customerData/findPersonCustList"          //历史客户数据列表

#define kaddReserve              @"/app/reserve/addReserve"                      //保存预约

#define kgetEndCode           @"/app/dic/getEndCode"                    //获取结束码

#define kfindTeamMember           @"/app/team/findTeamMember"                    //查询团队成员

#define ksaveOrder           @"/app/order/saveOrder"                    //新建订单

#define kfindInviteLink           @"/app/dic/findInviteLink"                    //邀请链接

//   常量
/**************************************************************************************/

static NSString *const ZQdidChangeLoginStateNotication = @"didChangeLoginNotication";    // 登录成功

/**
 *  StoryboardSugerID
 */
static NSString *const LoginToMenuView = @"loginToMenu";

static NSString *const RegisterSuccess = @"registerSuccess";

static NSString *const RegisterToMenuView = @"registerToMenuView";

/**
 *  通知
 */
static NSString *const LoginToMenuViewNotice = @"loginToMenu";

static NSString *const LogOutViewNotice = @"logOut";

/**************************************************************************************/

#endif
