//
//  SetUserInfoViewController.h
//  CloudService
//
//  Created by zhangqiang on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

@interface SetUserInfoViewController : BaseViewController

/**
 *  个人中心用户认证和注册成功进入,显示提交
 *  其他地方进入,显示保存
 */
@property(nonatomic,strong)NSString *rightBtnTitle;
/**
 *  是否处于不可编辑状态
 */
@property(nonatomic,assign)BOOL notEnable;

@end
