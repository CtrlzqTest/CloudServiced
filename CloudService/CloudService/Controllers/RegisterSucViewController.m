//
//  RegisterSucViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RegisterSucViewController.h"

@interface RegisterSucViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *inputBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushMenuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconHeadImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenSize_H;

@end

@implementation RegisterSucViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}



- (void)setupViews {
    
    self.title = @"注册成功";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    self.inputBtn.layer.cornerRadius = 3;
    self.inputBtn.layer.borderWidth = 0.6;
    self.inputBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.pushMenuBtn.layer.cornerRadius = 3;
    self.pushMenuBtn.layer.borderWidth = 0.6;
    self.pushMenuBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (IBAction)gotoMenuAction:(id)sender {
    
//    [self performSegueWithIdentifier:@"gotoMenu" sender:self];
//    __weak typeof(self) weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//    });
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginToMenuViewNotice object:nil];
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
