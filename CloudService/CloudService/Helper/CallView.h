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

- (void)isHidden:(BOOL)hidden tel:(NSString *)telNum;
/**
 *  释放拨打界面,同时退出青牛
 */
- (void)dismissCallView;

/**
 *  拨号
 */

@end
