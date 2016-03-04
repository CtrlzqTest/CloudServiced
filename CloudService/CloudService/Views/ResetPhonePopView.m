//
//  ResetPhonePopView.m
//  CloudService
//
//  Created by zhangqiang on 16/2/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ResetPhonePopView.h"

@implementation ResetPhonePopView{
    ClickBtnBlock _myBlock;
}

- (IBAction)cancleAction:(id)sender {
    _myBlock(0);
    [self removeFromSuperview];
}

- (IBAction)ensureAction:(id)sender {
    _myBlock(1);
    [self removeFromSuperview];
}

- (IBAction)sendAction:(id)sender {
    _myBlock(2);
}

- (void)showViewWithCallBack:(ClickBtnBlock )callBack {
    
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.430];
    _myBlock = callBack;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
