//
//  ButelHandle.m
//  CloudService
//
//  Created by 安永超 on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ButelHandle.h"
#import "CallView.h"
#import "AppDelegate.h"
#import <ButelCommonConnectSDK/ButelCommonConnectSDK.h>
#import <ButelCommonConnectSDK/ButelRecordConnect.h>

static ButelHandle *singleHandle = nil;

@interface ButelHandle()<ButelCommonConnectDelegateV1>
{
    BOOL isCall;//是否拨号
    // 通话时长
    NSInteger _callDuration;
    BOOL isCanCall;  // 拨号之前判断能否拨号
}
@property (nonatomic, strong) NSTimer *timerForDuration;
@property (retain) ButelCommonConnectV1 *connect;
@property (retain) NSString *deviceId;
@property (nonatomic,strong)CallView *callView;
@end

@implementation ButelHandle

+ (ButelHandle *)shareButelHandle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleHandle = [[ButelHandle alloc] init];
        
    });
    return singleHandle;
}

- (void)Init {
    //初始化青牛
    self.connect = [ButelEventConnectSDK CreateButelCommonConn:self];
    
    if ([self.connect Init] == -50006) {
        
    }
}

- (void)logOut {
    [self.connect Logout];
    //释放青牛sdk
    [ButelEventConnectSDK destroyButelCommonConn:self.connect];
}

// 扬声器
- (void)openSpeaker:(BOOL )isSpeaker {
    [self.connect OpenSpeaker:isSpeaker];
}

// 静音
- (void)enableMute:(bool )isMute {
    [self.connect EnableMute:isMute];
}

// 设置拨打手机号
- (void)setPhoneNo:(NSString *)phoneNo {
    self.callView.telNumStr = phoneNo;
}

- (void)showCallView {
    if (!self.callView) {
        self.callView = [[CallView alloc] initWithFrame:CGRectMake(KWidth-20, KHeight/2, 220, 80)];
    }
    self.callView.telNumStr = nil;
    self.callView.hidden = NO;
}

- (void)hideCallView {
    self.callView.hidden = YES;
}

- (void)makeCallWithPhoneNo:(NSString *)phoneNo {
    
    if (isCall) {
        //挂断
        [self.connect HangupCall:0];
        
    }else {
        if (isCanCall) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.isThird=YES;
            [MHNetworkManager postReqeustWithURL:@"http://221.4.250.108:8088/apHttpService/agent/makeCall" params:@{@"entId":@"7593111023", @"agentId":@"1001",@"number":phoneNo, @"ani":@"12345", @"uuid":self.deviceId, @"requestType":@"test" } successBlock:^(NSDictionary *returnData) {
                NSDictionary *dic = returnData;
                NSLog(@"%@",dic);
                if ([[dic objectForKey:@"code"] isEqualToString:@"000"]) {
                    NSLog(@"拨打电话成功");
                }else {
                    [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:nil];
                }
                delegate.isThird = NO;
            } failureBlock:^(NSError *error) {
                delegate.isThird = NO;
                NSLog(@"%@",error);
            } showHUD:NO];
            isCall = !isCall;
        }else {
            [MBProgressHUD showMessag:@"正在集成中，请稍候" toView:[UIApplication sharedApplication].keyWindow];
        }
    }

}

#pragma mark 回调入口
/****************************************************回调实现****************************************************************/
- (void)OnInit:(int)reason
{
    NSLog(@"APP::OnInit()...");
    
    if (reason == 0) {
        //http登陆
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.isThird=YES;
        [MHNetworkManager postReqeustWithURL:@"http://221.4.250.108:8088/apHttpService/agent/login4Butel" params:@{@"entId":@"7593111023", @"agentId":@"1001",@"passWord":@"1001"} successBlock:^(NSDictionary *returnData) {
            delegate.isThird = NO;
            NSDictionary *dic = returnData;
            if ([[dic objectForKey:@"code"] isEqualToString:@"000"]) {
                NSDictionary *extDic = [dic objectForKey:@"ext"];
                NSString *str = [extDic objectForKey:@"dn"];
                NSArray *array = [str componentsSeparatedByString:@":"];
                self.deviceId = [extDic objectForKey:@"nubeUUID"];
                NSString *UUID = [extDic objectForKey:@"nubeAppKey"];
                NSLog(@"%@",dic);
                [self.connect Login:UUID number:[array objectAtIndex:1] deviceId:self.deviceId nickname:@"CONNECT" userUniqueIdentifer:self.deviceId];
            }else {
                [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:nil];
            }
            
        } failureBlock:^(NSError *error) {
            delegate.isThird = NO;
            NSLog(@"%@",error);
        } showHUD:NO];
        
    }
}

- (void)OnLogin:(int)reason
{
    NSLog(@"APP::OnLogin()...");
    
    if (reason == 0) {
        isCanCall = YES;
        //        [RedAlertUtil showAlertWithText:@"登录成功..."];
        NSLog(@"denglu chengg");
        
    }
}
- (void)OnRing:(NSString*)Sid {
    NSLog(@"%@",Sid);
    
}
//打电话成功回调
- (void)OnConnect:(int)mediaFormat Sid:(NSString*)Sid {
    
    self.timerForDuration =nil;
    if (!self.timerForDuration) {
        NSLog(@"开启通话时长计时");
        self.timerForDuration = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(setCallDurationDisp) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timerForDuration forMode:NSDefaultRunLoopMode];
    }
    NSLog(@"%i,%@",mediaFormat,Sid);
}
/**
 *  设置通话时长显示
 */
- (void)setCallDurationDisp
{
    NSString *timeStr = @"00:00";
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    _callDuration ++;
    if (_callDuration > 0){
        minute = _callDuration / 60;
        if (minute < 60) {
            second = _callDuration % 60;
            timeStr = [NSString stringWithFormat:@"%@:%@", [self unitFormat:minute], [self unitFormat:second]];
        } else {
            hour = minute / 60;
            if (hour > 99) { // 最大值
                timeStr =  @"99:59:59";
            } else {
                minute = minute % 60;
                second = _callDuration - hour * 3600 - minute * 60;
                timeStr = [NSString stringWithFormat:@"%@:%@:%@", [self unitFormat:hour], [self unitFormat:minute], [self unitFormat:second]];
            }
        }
    }
}

/**
 *  格式化分秒
 */
- (NSString *)unitFormat:(NSInteger)i
{
    NSString *retStr;
    if (i >= 0 && i < 10){
        retStr = [NSString stringWithFormat:@"0%ld", (long)i];
    } else {
        retStr = [NSString stringWithFormat:@"%ld", (long)i];
    }
    return retStr;
}

- (void)OnNewcall:(NSString*)szCallerNum szCallerNickname:(NSString*)szCallerNickname Sid:(NSString*)Sid  nCallType:(int) nCallType  szExtendSignalInfo:(NSString*)szExtendSignalInfo{
    NSLog(@"%@",szCallerNum);
}

//挂断回调
- (void)OnDisconnect:(int) nReason Sid:(NSString*)Sid{
    isCall = !isCall;
    if (self.timerForDuration) {
        NSLog(@"取消通话计时器");
        _callDuration = 0;
        
        [self.timerForDuration invalidate];
        self.timerForDuration = nil;
    }
}
-(void)OnCdrNotify:(NSString *)cdrInfo {
    
}


//// 登陆
//- (void)loginWithLogin:(NSString *)UUID number:(NSString *)number deviceId:(NSString *)deviceID nickname:(NSString *)nickName userUniqueIdentifer:(NSString *)userID {
//    [self.connect Login:UUID number:number deviceId:deviceID nickname:nickName userUniqueIdentifer:userID];
//}


@end
