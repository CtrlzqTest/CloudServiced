//
//  FloatButton.m
//  FloatButton
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 安永超. All rights reserved.
//

#import "FloatButton.h"


UIButton *_button;
BOOL isSliding;
UIWindow *_window;
UIButton *_btnCall;//拨号按钮
UIImageView *_imgCall;//电话图标
UILabel *_lbTime;//通话计时
UILabel *_lbCall;//拨号显示
UIImageView *_imgSpeaker;//扬声器图片
UIImageView *_imgMute;//静音图片
UILabel *_lbSpeaker;//扬声器
UILabel *_lbMute;//静音
UIButton *_btnSpeaker;//扬声器按钮
UIButton *_btnMute;//静音按钮
NSString *_telNumStr;
BOOL isSpeaker;//是否开启扬声器
BOOL isMute;//是否静音
BOOL isCall;//是否拨号
@implementation FloatButton

+ (void)showFloatButton:(NSString *)telNum{

    _telNumStr = telNum;
    /** 拨号、挂断按钮*/
    _btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCall.frame = CGRectMake(0, 0, 80, 80);
    _btnCall.layer.cornerRadius = 40;
    _btnCall.layer.masksToBounds = YES;
    _btnCall.clipsToBounds = YES;
    [_btnCall addTarget:self action:@selector(callNum:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCall setBackgroundImage:[UIImage imageNamed:@"pop2-btn1"] forState:UIControlStateNormal];
    _btnCall.userInteractionEnabled = NO;
    
    
    /** 电话图标*/
    _imgCall = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 27, 27)];
    _imgCall.image = [UIImage imageNamed:@"pop2-icon1"];
    
    
    /** 拨号*/
    _lbCall = [[UILabel alloc] initWithFrame:CGRectMake(25, 43, 40, 20)];
    _lbCall.textColor = [UIColor whiteColor];
    _lbCall.font = [UIFont systemFontOfSize:12];
    _lbCall.text = @"拨号";
    
    /** 扬声器按钮*/
    _btnSpeaker = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSpeaker.frame = CGRectMake(80, 3, 90, 35);
    [_btnSpeaker addTarget:self action:@selector(speaker) forControlEvents:UIControlEventTouchUpInside];
    
    /** 扬声器icon*/
    _imgSpeaker = [[UIImageView alloc] initWithFrame:CGRectMake(85, 7, 27, 27)];
    _imgSpeaker.image = [UIImage imageNamed:@"pop2-icon2"];
    
    
    /** 扬声器*/
    _lbSpeaker = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, 50, 20)];
    _lbSpeaker.textColor = [UIColor whiteColor];
    _lbSpeaker.font = [UIFont systemFontOfSize:12];
    _lbSpeaker.text = @"扬声器";
    
    /** 分割线*/
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(77, 40, 123, 1)];
    lineImg.image = [UIImage imageNamed:@"login-input-line"];
    
    /** 静音按钮*/
    _btnMute = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMute.frame = CGRectMake(80, 43, 90, 35);
    [_btnMute addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 静音icon*/
    _imgMute = [[UIImageView alloc] initWithFrame:CGRectMake(85, 47, 27, 27)];
    _imgMute.image = [UIImage imageNamed:@"pop2-icon3"];
    
    /** 静音*/
    _lbMute = [[UILabel alloc] initWithFrame:CGRectMake(115, 50, 50, 20)];
    _lbMute.textColor = [UIColor whiteColor];
    _lbMute.font = [UIFont systemFontOfSize:12];
    _lbMute.text = @"静音";
    
    
    /** 拖拽手势*/
    UIPanGestureRecognizer *oneFingerSwipeleft =
    
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    
    
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(KWidth-20, KHeight/2, 220, 80)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [HelperUtil colorWithHexString:@"2E2D2F"];
    _window.layer.cornerRadius = 40;
    _window.layer.masksToBounds = YES;
    [_window addSubview:_button];
    [_window addSubview:_btnCall];
    [_window addSubview:_imgCall];
    [_window addSubview:_lbCall];
    [_window addSubview:_btnSpeaker];
    [_window addSubview:_imgSpeaker];
    [_window addSubview:_lbSpeaker];
    [_window addSubview:lineImg];
    [_window addSubview:_btnMute];
    [_window addSubview:_imgMute];
    [_window addSubview:_lbMute];
    [_window addGestureRecognizer:oneFingerSwipeleft];
    
    [_window makeKeyAndVisible];//关键语句,显示window
    
}

+ (void)hiddenFloatButton {
    [_window resignKeyWindow];
    _window = nil;
}
//拨号挂断
+ (void)callNum:(UIButton *)sender {
    if (isCall) {
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"pop2-btn1"] forState:UIControlStateNormal];
        _imgCall.hidden = NO;
        _lbCall.text = @"拨号";
    }else {
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"pop2-btn1_"] forState:UIControlStateNormal];
        _imgCall.hidden = NO;
        _lbCall.text = @"挂断";
    }
    isCall = !isCall;
    NSLog(@"faf");
}
//扬声器
+ (void)speaker {
    if (isSpeaker) {
        _imgSpeaker.image = [UIImage imageNamed:@"pop2-icon2"];
        _lbSpeaker.textColor = [UIColor whiteColor];
    }else {
        _imgSpeaker.image = [UIImage imageNamed:@"pop2-icon2_"];
        _lbSpeaker.textColor = [HelperUtil colorWithHexString:@"1FAAF2"];
    }
    isSpeaker = !isSpeaker;
}
//静音
+ (void)mute {
    if (isMute) {
        _imgMute.image = [UIImage imageNamed:@"pop2-icon3"];
        _lbMute.textColor = [UIColor whiteColor];
    }else {
        _imgMute.image = [UIImage imageNamed:@"pop2-icon3_"];
        _lbMute.textColor = [HelperUtil colorWithHexString:@"1FAAF2"];
    }
    isMute = !isMute;
}
+ (void)oneFingerSwipeUp:(UIPanGestureRecognizer *)recognizer{
    CGPoint translatedPoint = [recognizer translationInView:_window];
    if (translatedPoint.x>0) {
        [UIView animateWithDuration:.5 animations:^{
            _window.frame = CGRectMake(KWidth-20, KHeight/2, 220, 80);
        } completion:^(BOOL finished) {
           _btnCall.userInteractionEnabled = NO;
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            _window.frame = CGRectMake(KWidth-170, KHeight/2, 220, 80);
        } completion:^(BOOL finished) {
            _btnCall.userInteractionEnabled = YES;
        }];
    }
    
    
    
    
}
@end
