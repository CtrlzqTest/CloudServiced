//
//  CallView.m
//  CloudService
//
//  Created by zhangqiang on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CallView.h"
#import <ButelCommonConnectSDK/ButelCommonConnectSDK.h>
#import <ButelCommonConnectSDK/ButelRecordConnect.h>
#import "MHNetwrok.h"
@interface CallView()<ButelCommonConnectDelegateV1>
{
    UIButton *_button;
    BOOL isSliding;
    
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
}
@property (retain) ButelCommonConnectV1 *connect;
@property (retain) NSString *deviceId;
@property (retain) NSString *nuber;
@end
@implementation CallView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [HelperUtil colorWithHexString:@"2E2D2F"];
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
        [self setContentView];
    }
    return self;
}

- (void)showCallView {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)hideCallView {
    
    [self removeFromSuperview];
}

- (void)setContentView {
    //初始化青牛
    self.connect = [ButelEventConnectSDK CreateButelCommonConn:self];
    if ([self.connect Init] == -50006) {
        
    }
    
    
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
    [self addSubview:_button];
    [self addSubview:_btnCall];
    [self addSubview:_imgCall];
    [self addSubview:_lbCall];
    [self addSubview:_btnSpeaker];
    [self addSubview:_imgSpeaker];
    [self addSubview:_lbSpeaker];
    [self addSubview:lineImg];
    [self addSubview:_btnMute];
    [self addSubview:_imgMute];
    [self addSubview:_lbMute];
    [self addGestureRecognizer:oneFingerSwipeleft];
    
}
//拨号挂断
- (void)callNum:(UIButton *)sender {
    if (isCall) {
        //挂断
        [self.connect HangupCall:0];
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"pop2-btn1"] forState:UIControlStateNormal];
        _imgCall.hidden = NO;
        _lbCall.text = @"拨号";
    }else {
        [MHNetworkManager postReqeustWithURL:@"http://221.4.250.108:8088/apHttpService/agent/makeCall" params:@{@"entId":@"7593111023", @"agentId":@"1001",@"number":@"13162565715", @"ani":@"12345", @"uuid":self.deviceId, @"requestType":@"test" } successBlock:^(NSDictionary *returnData) {
            NSDictionary *dic = returnData;
            NSLog(@"%@",dic);
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        } showHUD:NO];
        
        [_btnCall setBackgroundImage:[UIImage imageNamed:@"pop2-btn1_"] forState:UIControlStateNormal];
        _imgCall.hidden = NO;
        _lbCall.text = @"挂断";
    }
    isCall = !isCall;
    NSLog(@"faf");
}
//扬声器
- (void)speaker {
    if (isSpeaker) {
        [self.connect OpenSpeaker:NO];
        _imgSpeaker.image = [UIImage imageNamed:@"pop2-icon2"];
        _lbSpeaker.textColor = [UIColor whiteColor];
    }else {
        [self.connect OpenSpeaker:YES];
        _imgSpeaker.image = [UIImage imageNamed:@"pop2-icon2_"];
        _lbSpeaker.textColor = [HelperUtil colorWithHexString:@"1FAAF2"];
    }
    isSpeaker = !isSpeaker;
}
//静音
- (void)mute {
    if (isMute) {
        [self.connect EnableMute:NO];
        _imgMute.image = [UIImage imageNamed:@"pop2-icon3"];
        _lbMute.textColor = [UIColor whiteColor];
    }else {
        [self.connect EnableMute:YES];
        _imgMute.image = [UIImage imageNamed:@"pop2-icon3_"];
        _lbMute.textColor = [HelperUtil colorWithHexString:@"1FAAF2"];
    }
    isMute = !isMute;
}
- (void)oneFingerSwipeUp:(UIPanGestureRecognizer *)recognizer{
    CGPoint translatedPoint = [recognizer translationInView:self];
    if (translatedPoint.x>0) {
        [UIView animateWithDuration:.5 animations:^{
            self.frame = CGRectMake(KWidth-20, KHeight/2, 220, 80);
        } completion:^(BOOL finished) {
            _btnCall.userInteractionEnabled = NO;
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            self.frame = CGRectMake(KWidth-170, KHeight/2, 220, 80);
        } completion:^(BOOL finished) {
            _btnCall.userInteractionEnabled = YES;
        }];
    }
    
    
    
    
}
#pragma mark 回调入口
/****************************************************回调实现****************************************************************/
- (void)OnInit:(int)reason
{
    NSLog(@"APP::OnInit()...");
    
    if (reason == 0) {
        //http登陆
        [MHNetworkManager postReqeustWithURL:@"http://221.4.250.108:8088/apHttpService/agent/login4yg" params:@{@"entId":@"7593111023", @"agentId":@"1001",@"passWord":@"1001"} successBlock:^(NSDictionary *returnData) {
            NSDictionary *dic = returnData;
            NSDictionary *extDic = [dic objectForKey:@"ext"];
            NSString *str = [extDic objectForKey:@"dn"];
            NSArray *array = [str componentsSeparatedByString:@":"];
            self.nuber = [array objectAtIndex:1];
            self.deviceId = [extDic objectForKey:@"nubeUUID"];
            NSString *UUID = [extDic objectForKey:@"nubeAppKey"];
            NSLog(@"%@",dic);
            [self.connect Login:UUID number:self.nuber deviceId:self.deviceId nickname:@"CONNECT" userUniqueIdentifer:self.deviceId];
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        } showHUD:NO];
        
        //        [RedAlertUtil showAlertWithText:@"初始化成功..."];
        //        if (![deviceId isEqualToString:self.deviceId]) {
        //            self.deviceId = deviceId;
        //            [[UserInfo sharedInstance] setDeviceId:self.deviceId];
        //            [RedAlertUtil showAlertWithText:@"需要点击申请注册新号..."];
        //        }
    }
}
- (void)OnLogin:(int)reason
{
    NSLog(@"APP::OnLogin()...");
    
    if (reason == 0) {
        
        //        [RedAlertUtil showAlertWithText:@"登录成功..."];
        NSLog(@"denglu chengg");
        
    }
}
- (void)OnRing:(NSString*)Sid {
    NSLog(@"%@",Sid);
    
}
- (void)OnConnect:(int)mediaFormat Sid:(NSString*)Sid {
    NSLog(@"%i,%@",mediaFormat,Sid);
}
- (void)OnNewcall:(NSString*)szCallerNum szCallerNickname:(NSString*)szCallerNickname Sid:(NSString*)Sid  nCallType:(int) nCallType  szExtendSignalInfo:(NSString*)szExtendSignalInfo{
    NSLog(@"%@",szCallerNum);
}
- (void)OnDisconnect:(int) nReason Sid:(NSString*)Sid{
    
}
-(void)OnCdrNotify:(NSString *)cdrInfo {
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end