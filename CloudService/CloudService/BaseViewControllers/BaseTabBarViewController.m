//
//  BaseTabBarViewController.m
//  91Demo
//
//  Created by zhangqiang on 16/1/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    
    
    UIImage *img1=[UIImage imageNamed:@"tab1.png"];
    UIImage *imgS1=[UIImage imageNamed:@"tab1_.png"];
    item1.selectedImage=[imgS1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image=[img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img2=[UIImage imageNamed:@"tab2.png"];
    UIImage *imgS2=[UIImage imageNamed:@"tab2_.png"];
    item2.selectedImage=[imgS2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image=[img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img3=[UIImage imageNamed:@"tab3.png"];
    UIImage *imgS3=[UIImage imageNamed:@"tab3_.png"];
    item3.selectedImage=[imgS3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image=[img3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img4=[UIImage imageNamed:@"tab4.png"];
    UIImage *imgS4=[UIImage imageNamed:@"tab4_.png"];
    
    item4.selectedImage=[imgS4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image=[img4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
