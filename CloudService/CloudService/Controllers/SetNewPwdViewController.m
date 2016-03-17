//
//  SetNewPwdViewController.m
//  CloudService
//
//  Created by zhangqiang on 15/1/1.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "SetNewPwdViewController.h"
#import "Utility.h"

@interface SetNewPwdViewController ()
{
    BOOL _isEye;
}
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *enSurePwdTextFiled;
@property (strong, nonatomic)UIImageView *eyeImg;
@end

@implementation SetNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
    self.eyeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];
    
    self.pwdTextFiled.rightView = self.eyeImg;
    self.pwdTextFiled.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eyeTap:)];
    [self.pwdTextFiled.rightView addGestureRecognizer:tap];

    self.pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    self.enSurePwdTextFiled.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];
    self.enSurePwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
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
- (IBAction)resetPwdAction:(id)sender {
    
    if (![self checkInputMode]) {
        return;
    }
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSDictionary *dict = @{@"password":[Utility sha256WithString:[Utility passWord]] ,@"newPwd":[Utility sha256WithString:self.pwdTextFiled.text],@"userId":user.userId};
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kResetPwdAPI] params:dict successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"])
        {
            [Utility saveUserName:[Utility userName] passWord:self.pwdTextFiled.text];
            NSArray *VCArrary = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[VCArrary objectAtIndex:1] animated:YES];
        }else
        {
            [MBProgressHUD showError:[returnData valueForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}

/**
 *  检查输入状态
 */
- (BOOL)checkInputMode
{
    NSString * regexPasswordNum = @"[^\n]{6,16}$";
    NSPredicate *predicatePasswordNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPasswordNum];
    BOOL isPasswordMatch = [predicatePasswordNum evaluateWithObject: self.pwdTextFiled.text];
    BOOL ensurePwd = [self.pwdTextFiled.text isEqualToString:self.enSurePwdTextFiled.text];
    if (!isPasswordMatch)
    {
        [MBProgressHUD showError:@"密码格式错误,请输入6到16位密码" toView:self.view];
        return false;
    }
    if (!ensurePwd)
    {
        [MBProgressHUD showError:@"两次输入密码不一致" toView:self.view];
        return false;
    }
    return true;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:YES];
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
