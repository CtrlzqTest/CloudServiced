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
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetCodeAPI] params:@{@"phoneNo":user.phoneNo} successBlock:^(id returnData) {
        [weakSelf countDownTime:@60];
        [MBProgressHUD showMessag:@"验证码获取成功" toView:nil];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showMessag:@"验证码获取失败" toView:nil];
    } showHUD:YES];
//    _myBlock(2);
}

- (void)showViewWithCallBack:(ClickBtnBlock )callBack {
    
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.430];
    _myBlock = callBack;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

/**
 *  倒计时函数
 */
-(void)countDownTime:(NSNumber *)sourceDate{
    
    //    self.sendBtn.backgroundColor = [UIColor lightGrayColor];
    self.sendBtn.enabled = NO;
    __block int timeout = sourceDate.intValue; //倒计时时间
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 1){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                [weakSelf.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                weakSelf.sendBtn.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                NSString *numStr=[NSString stringWithFormat:@"%d秒后重新发送",timeout];
                //                [weakSelf.sendBtn setTitleColor:[UIColor colorWithWhite:0.573 alpha:1.000] forState:UIControlStateNormal];
                [weakSelf.sendBtn setTitle:numStr forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
