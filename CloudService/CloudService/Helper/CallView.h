//
//  CallView.h
//  CloudService
//
//  Created by zhangqiang on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallView : UIView

@property (nonatomic,copy)NSString *telNumStr;

/**
 *  释放拨打界面,同时退出青牛
 */
- (void)dismissCallView;

/**
 *  打电话成功回调开始计时
 */
- (void)OnConnectSuccess;


/**
 *  挂断成功回调停止计时
 */
- (void)OnDisconnect;
@end
