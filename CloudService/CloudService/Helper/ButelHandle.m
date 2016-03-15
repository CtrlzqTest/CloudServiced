//
//  ButelHandle.m
//  CloudService
//
//  Created by 安永超 on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ButelHandle.h"
#import "CallView.h"


static ButelHandle *singleHandle = nil;
@implementation ButelHandle
{
    CallView *callView;
}

+ (ButelHandle *)shareButelHandle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleHandle = [[ButelHandle alloc] init];
        
    });
    return singleHandle;
}
- (void)initCallView {
    callView = [[CallView alloc] initWithFrame:CGRectMake(KWidth-20, KHeight/2, 220, 80)];
}
- (void)isHidden:(BOOL)hidden tel:(NSString *)telNum {
    [callView isHidden:hidden tel:telNum];
}



//// 登陆
//- (void)loginWithLogin:(NSString *)UUID number:(NSString *)number deviceId:(NSString *)deviceID nickname:(NSString *)nickName userUniqueIdentifer:(NSString *)userID {
//    [self.connect Login:UUID number:number deviceId:deviceID nickname:nickName userUniqueIdentifer:userID];
//}


@end
