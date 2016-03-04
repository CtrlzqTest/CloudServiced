//
//  ResetPhonePopView.h
//  CloudService
//
//  Created by zhangqiang on 16/2/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBtnBlock)(NSInteger btnIndex);

@interface ResetPhonePopView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (void)showViewWithCallBack:(ClickBtnBlock )callBack;

@end
