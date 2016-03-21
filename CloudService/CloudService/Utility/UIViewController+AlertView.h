//
//  UIViewController+AlertView.h
//  JinYeFeiLin
//
//  Created by zhangqiang on 15/11/17.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertView)
-(void)showAlertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
