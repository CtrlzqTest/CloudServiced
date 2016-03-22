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
//#import "ButelHandle.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    BOOL _isRemenberPwd;
    BOOL _isEye;
}

@property (weak, nonatomic) IBOutlet LoginInputView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (strong, nonatomic)UIImageView *eyeImg;

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
    
    UIColor *color = [UIColor colorWithRed:0.263 green:0.561 blue:0.796 alpha:1.000];
    self.UserTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-user"]];
    self.UserTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.UserTextFiled.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"用户名/手机号码/邮箱"
                                                attributes:@{NSForegroundColorAttributeName:color}];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.UserTextFiled];
    
    self.pwdTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-key"]];
    self.eyeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];

    self.pwdTextFiled.rightView = self.eyeImg;
    self.pwdTextFiled.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eyeTap:)];
    [self.pwdTextFiled.rightView addGestureRecognizer:tap];
    self.pwdTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    self.pwdTextFiled.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:@"请输入密码"
                                               attributes:@{NSForegroundColorAttributeName:color}];
    
    self.UserTextFiled.text = [Utility userName];
    if ([Utility isRemberPassWord]) {
        self.pwdTextFiled.text = [Utility passWord];
        self.choseBtn.selected = YES;
        [self.choseBtn setBackgroundImage:[UIImage imageNamed:@"login-choose_"] forState:(UIControlStateNormal)];
    }
    
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.clipsToBounds = YES;
    self.choseBtn.layer.cornerRadius = self.choseBtn.frame.size.width / 2.0;
    [self.view sendSubviewToBack:self.backImg];
    
}

- (void)eyeTap:(UITapGestureRecognizer *)sender {
    _isEye = !_isEye;
    if (_isEye) {

        self.eyeImg.image = [UIImage imageNamed:@"login-line_"];
        self.pwdTextFiled.secureTextEntry = NO;
    }else {

        self.eyeImg.image = [UIImage imageNamed:@"login-line"];
        self.pwdTextFiled.secureTextEntry = YES;
    }
}

// 登录
- (IBAction)loginAction:(id)sender {
    
    if (![self checkInputMode]) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.UserTextFiled.text forKey:@"userName"];
    [dict setValue:[Utility sha256WithString:self.pwdTextFiled.text] forKey:@"password"];
    NSString *address = [Utility location];
    if (address) {
        [dict setValue:address forKey:@"address"];
    }else {
//        [MBProgressHUD showMessag:@"无法获取定位信息,系统默认您的的登录城市为北京市" toView:self.view];
        [dict setValue:@"北京市" forKey:@"address"];
    }

    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kLoginAPI] params:dict successBlock:^(id returnData) {
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            User *user = [User mj_objectWithKeyValues:[returnData valueForKey:@"data"]];
            [[SingleHandle shareSingleHandle] saveUserInfo:user];
            [Utility saveUserName:self.UserTextFiled.text passWord:self.pwdTextFiled.text];
            if (weakSelf.choseBtn.selected) {
                [Utility remberPassWord:YES];
            }else {
                [Utility remberPassWord:NO];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginToMenuViewNotice object:nil];
        }else if([[returnData valueForKey:@"flag"] isEqualToString:@"error"]){
            [MBProgressHUD showMessag:[returnData valueForKey:@"msg"] toView:self.view];
        }
    } failureBlock:^(NSError *error) {
 
    } showHUD:YES];
}

/**
 *  检查输入状态
 */
- (BOOL)checkInputMode
{
    
    if (self.UserTextFiled.text.length <= 0) {
        [MBProgressHUD showMessag:@"用户名不能为空" toView:self.view];
        return false;
    }else if (self.pwdTextFiled.text.length <= 0){
        
        [MBProgressHUD showMessag:@"请输入密码" toView:self.view];
        return false;
    }
    
    NSString * regexPasswordNum = @"[^\n]{6,16}$";
    NSPredicate *predicatePasswordNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPasswordNum];
    BOOL isPasswordMatch = [predicatePasswordNum evaluateWithObject: self.pwdTextFiled.text];
    if (!isPasswordMatch)
    {
        [MBProgressHUD showMessag:@"密码格式错误,请输入6到16位密码" toView:self.view];
        return false;
    }
    return true;
}

-(void)dealloc {
    _inputView = nil;
    _loginBtn = nil;
    _UserTextFiled = nil;
    _backImg = nil;
    _pwdTextFiled = nil;
    _choseBtn = nil;
    _eyeImg = nil;
}



- (void)textFieldChanged:(NSNotificationCenter *)sender {
    if ([self.UserTextFiled.text isEqualToString:@""]) {
        self.pwdTextFiled.text = @"";
    }
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
