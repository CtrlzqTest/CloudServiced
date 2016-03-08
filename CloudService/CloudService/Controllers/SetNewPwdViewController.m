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

@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *enSurePwdTextFiled;

@end

@implementation SetNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
    self.pwdTextFiled.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];
    self.pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    self.enSurePwdTextFiled.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-line"]];
    self.enSurePwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)resetPwdAction:(id)sender {
    
    if (![self checkInputMode]) {
        return;
    }
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSDictionary *dict = @{@"password":@"111111" ,@"newPwd":self.pwdTextFiled.text,@"userId":user.userId};
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kResetPwdAPI] params:dict successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
