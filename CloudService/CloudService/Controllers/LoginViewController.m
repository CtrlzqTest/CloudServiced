//
//  LoginViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "RestAPI.h"
#import <Masonry.h>
#import "LoginInputView.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LoginInputView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated {
    //导航条滑动返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[HelperUtil colorWithHexString:@"277FD9"]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)remeberPwdAction:(id)sender {
    
    self.choseBtn.selected = !self.choseBtn.selected;
    if (self.choseBtn.selected) {
        [self.choseBtn setBackgroundImage:[UIImage imageNamed:@"login-choose_"] forState:(UIControlStateNormal)];
    }else {
        [self.choseBtn setBackgroundImage:nil forState:(UIControlStateNormal)];
    }
}


- (void)setupView {
    
    [self.view bringSubviewToFront:self.backImg];
    self.inputView.layer.cornerRadius = 3;
    self.inputView.clipsToBounds = YES;
    self.inputView.backgroundColor = [UIColor colorWithRed:0.918 green:0.917
                                                      blue:0.925 alpha:0.600];
    
    UIColor *color = [UIColor colorWithRed:0.263 green:0.561 blue:0.796 alpha:1.000];
    self.UserTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-user"]];
    self.UserTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.UserTextFiled.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"用户名/手机号码/邮箱"
                                                attributes:@{NSForegroundColorAttributeName:color}];
    
    self.pwdTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-key"]];
    self.pwdTextFiled.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];
    self.pwdTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    self.pwdTextFiled.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:@"请输入密码"
                                               attributes:@{NSForegroundColorAttributeName:color}];
    
    
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.clipsToBounds = YES;
    NSLog(@"%@",NSStringFromCGRect(self.choseBtn.frame));
    self.choseBtn.layer.cornerRadius = self.choseBtn.frame.size.width / 2.0;
    
    
    [self.view sendSubviewToBack:self.backImg];
    
}

// 登录
- (IBAction)loginAction:(id)sender {
    
    if (self.UserTextFiled.text.length <= 0) {
        [MBProgressHUD showError:@"用户名不能为空" toView:self.view];
        return;
    }else if (self.pwdTextFiled.text.length <= 0){

        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
//    [self performSegueWithIdentifier:@"login" sender:self];
    
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
