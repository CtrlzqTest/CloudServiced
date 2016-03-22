//
//  AppDelegate.m
//  CloudService
//
//  Created by zhangqiang on 16/2/22.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNaviViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "Utility.h"
#import "MHAsiNetworkHandler.h"
#import "FireData.h"

#define MObAppKey     @"100082c56c5c0"
#define WXAppID       @"wx125bcc153468cc36"
#define WXAppSecret   @"5d792862f07b6ff0b27eaced2ffbd01d"
@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate> {
    BOOL _isSetCity;
}

@end

@implementation AppDelegate
@synthesize window =_window;

@synthesize isThird;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    // Override point for customization after application launch.
    
    //检测网络状态
    if ([[HelperUtil getNetWorkStates] isEqualToString:@"2G"]) {
        [MBProgressHUD showMessag:@"当前处于2G网络，您当前所有操作可能会有延迟！" toView:nil];
    }
    
    // 检查版本号
    [Utility checkNewVersion:^(BOOL hasNewVersion) {
        if (hasNewVersion) {
            [Utility saveVersion:hasNewVersion];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"系统检测有新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"点击进入下载", nil];
            [alertView show];
        }
    }];
    
    // 注册shareSDK
    [self registerShareSDK];
    // 注册通知
    [self registerNotifications];
    // 注册定位
    [self registerLocation];
    
    //设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self registerFireData];
    return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.eyunkf.com/html/download.html"]];
    }
}

/**
 *  数据统计
 */
-(void)registerFireData {
    // 配置统计 SDK
    [[FireData sharedInstance] initWithHost:@"139.198.0.125" AppId:@"YUNKFD3SXE" distributors:@"ios"];
    [FireData sharedInstance].debugMode = NO;
    [FireData sharedInstance].enableCrashReport = YES;
    [FireData sharedInstance].enableLocationReport = YES;
    [FireData sharedInstance].sendTimeInterval = 2;
    [FireData sharedInstance].enableIDFA = NO;

    [[FireData sharedInstance] loginWithUserid:@"user1" uvar:@"UvarsJson"];
    [FireData sharedInstance].refcode = @"refcode100000";
}

- (void)registerShareSDK {
    [ShareSDK registerApp:MObAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXAppID
                                       appSecret:WXAppSecret];
                 break;
             default:
                 break;
         }
     }];
}

- (void)registerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginToMenu) name:LoginToMenuViewNotice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:LogOutViewNotice object:nil];
    
}
- (void)registerLocation {
    
    self.locateManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    //如果没有授权则请求用户授权
    //设置代理
    self.locateManager.delegate = self;
    //设置定位精度
    self.locateManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=100.0;//十米定位一次
    self.locateManager.distanceFilter=distance;
    //启动跟踪定位
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locateManager requestWhenInUseAuthorization];
//        [self registerLocation];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
   
        [self.locateManager startUpdatingLocation];
    }
}

- (void)loginToMenu {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNaviViewController *menuVC = [storyBoard instantiateViewControllerWithIdentifier:@"MenuNavi"];
//    [UIView transitionFromView:self.window.rootViewController.view toView:menuVC.view duration:0.3 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
//    }];
    UIViewController *oldVC = self.window.rootViewController;
    oldVC = nil;
    self.window.rootViewController = menuVC;
    
}

- (void)logOut {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNavi"];
    UIViewController *oldVC = self.window.rootViewController;
    oldVC = nil;
    self.window.rootViewController = loginVC;
    
}

#pragma mark -- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placeMark = nil;
//    __weak typeof(self) weakSelf = self;
    [geoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (_isSetCity) {
            return ;
        }
        if (placemarks.count > 0) {
            placeMark = [placemarks firstObject];
            NSString *city = [NSString stringWithFormat:@"%@%@",placeMark.locality,placeMark.subLocality];
            [Utility saveLocation:city];
            _isSetCity = YES;
        }
    }];
    //如果不需要实时定位，使用完即使关闭定位服务
    [self.locateManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status  {
    
    if(status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locateManager startUpdatingLocation];
    }
}

#pragma mark AppDelegate
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [application ];
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([Utility isNewVersion]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"系统检测有新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"点击进入下载", nil];
        [alertView show];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
