//
//  AYCButton.h
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/12/7.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYCButton : UIButton
//添加点击后执行的block
// void action(ZTButton *button);
@property (copy,nonatomic) void (^action)(AYCButton *button);

@end
