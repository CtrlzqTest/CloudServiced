//
//  UIViewController+AlertView.m
//  JinYeFeiLin
//
//  Created by zhangqiang on 15/11/17.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "UIViewController+AlertView.h"

@implementation UIViewController (AlertView)

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButtonTitle.length > 0) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancleAction];
    }
    
    if (otherButtonTitles.length > 0) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:otherAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *aletView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [aletView show];
#endif
    
}

@end
