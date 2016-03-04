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

//#define BaseAPI                 @"http://192.168.16.139:8080/onepage/"  // 龙龙

#define BaseAPI                 @"http://192.168.16.147:8080/onepage/"  // 公司服务器

//#define BaseAPI                 @"http://192.168.16.124:8080/znweb/"    // 赵楠

#define kUpdateDataBaseToHost   @"vote3/test/update.do"

#define kHostUrlString          @"appinfo/list.do"

#define kProductListAPI         @"appinfo/plist"

#define kGoodsListAPI           @"appinfo/slist"       // 购物列表

#define kLoginAPI               @"appuser/login"       // 登录

#define SnsLoginUrlAPI          @"user_login2.action"  // 第三方登录

#define kRegisteAPI             @"appuser/reg"         //注册

#define kCollectAPI             @"appmyfavorite/save"  //收藏

#define kCollectionListAPI      @"appmyfavorite/findPersonalList"  //收藏列表


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
