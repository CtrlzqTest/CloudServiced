//
//  AppDelegate.h
//  CloudService
//
//  Created by zhangqiang on 16/2/22.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL isThird;
@property(nonatomic,strong)CLLocationManager *locateManager;

@end

