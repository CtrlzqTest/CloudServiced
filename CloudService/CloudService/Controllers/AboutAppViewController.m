//
//  AboutAppViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel1;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel2;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    double currentVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] doubleValue];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号 V%.2f",currentVersion];
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
