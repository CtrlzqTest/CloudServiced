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
#import "RequestEntity.h"
#import "MHNetwrok.h"
#import "Utility.h"
#import "User.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    BOOL _isRemenberPwd;
}

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
        _isRemenberPwd = YES;
    }else {
        _isRemenberPwd = NO;
        [self.choseBtn setBackgroundImage:nil forState:(UIControlStateNormal)];
    }
}

- (void)setupView {
    
    [self.view bringSubviewToFront:self.backImg];
    self.inputView.layer.cornerRadius = 3;
    self.inputView.clipsToBounds = YES;
    self.inputView.backgroundColor = [UIColor colorWithRed:0.918 green:0.917
                                                      blue:0.925 alpha:0.600];
    
    NSDictionary *userPwdDict = [Utility getUserNameAndPwd];
    UIColor *color = [UIColor colorWithRed:0.263 green:0.561 blue:0.796 alpha:1.000];
    self.UserTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-user"]];
    self.UserTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.UserTextFiled.text = userPwdDict[@"userName"];
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
    self.pwdTextFiled.text = userPwdDict[@"pwd"];
    
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.clipsToBounds = YES;
    self.choseBtn.layer.cornerRadius = self.choseBtn.frame.size.width / 2.0;
    
    
    [self.view sendSubviewToBack:self.backImg];
    
}

// 登录
- (IBAction)loginAction:(id)sender {
    
//    if (self.UserTextFiled.text.length <= 0) {
//        [MBProgressHUD showError:@"用户名不能为空" toView:self.view];
//        return;
//    }else if (self.pwdTextFiled.text.length <= 0){
//
//        [MBProgressHUD showError:@"请输入密码" toView:self.view];
//        return;
//    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"liangming" forKey:@"userName"];
    [dict setValue:@"123456" forKey:@"password"];
    NSString *address = [Utility location];
    if (address) {
        [dict setValue:address forKey:@"address"];
    }else {
//        [MBProgressHUD showError:@"无法获取定位信息,系统默认您的的登录城市为北京市" toView:self.view];
        [MBProgressHUD showMessag:@"无法获取定位信息,系统默认您的的登录城市为北京市" toView:self.view];
        [dict setValue:@"北京市" forKey:@"address"];
    }
    
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kLoginAPI] params:dict successBlock:^(id returnData) {
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
//            [Utility saveUserInfo:[returnData valueForKey:@"data"]];
            User *user = [User mj_objectWithKeyValues:[returnData valueForKey:@"data"]];
            [[SingleHandle shareSingleHandle] saveUserInfo:user];
            if (weakSelf.choseBtn.selected) {
                [Utility remenberUserAndPwd:@{@"userName":weakSelf.UserTextFiled.text,@"pwd":weakSelf.pwdTextFiled.text}];
            }else {
                [Utility remenberUserAndPwd:@{@"userName":weakSelf.UserTextFiled.text,@"pwd":@""}];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginToMenuViewNotice object:nil];
        }else if([[returnData valueForKey:@"flag"] isEqualToString:@"error"]){
            [MBProgressHUD showError:[returnData valueForKey:@"msg"] toView:self.view];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
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
