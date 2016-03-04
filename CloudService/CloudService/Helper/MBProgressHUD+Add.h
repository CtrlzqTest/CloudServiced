//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
/** 显示错误信息  */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/** 显示成功信息  */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/** 显示文字信息  */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end
