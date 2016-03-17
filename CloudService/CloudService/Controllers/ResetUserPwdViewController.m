//
//  ResetUserPwdViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/3.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ResetUserPwdViewController.h"
#import "Utility.h"

@interface ResetUserPwdViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwd;

@end

@implementation ResetUserPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    
    self.title = @"修改密码";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.borderWidth = 0.2;
    self.getCodeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.getCodeBtn.highlighted = NO;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)resetPwdAction:(id)sender {
    
    if (![self checkInputMode]) {
        return;
    }
    NSDictionary *dict = @{@"phoneNo":self.phoneNum.text,@"code":self.codeTextFiled.text,@"password":[Utility sha256WithString:self.pwdTextFiled.text]};
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kForgetPwdAPI] params:dict successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:[returnData valueForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}

- (IBAction)getCodeAction:(id)sender {
    
    NSString * regexPhoneNum = @"^1[0-9]{10}$";
    NSPredicate *predicatePhoneNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhoneNum];
    BOOL isPhoneMatch = [predicatePhoneNum evaluateWithObject:self.phoneNum.text];
    if (!isPhoneMatch)
    {
        [MBProgressHUD showError:@"手机号输入错误" toView:self.view];
    }else {
        [self countDownTime:@60];
        [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetCodeAPI] params:@{@"phoneNo":self.phoneNum.text} successBlock:^(id returnData) {
            
        } failureBlock:^(NSError *error) {
            
        } showHUD:NO];
    }
//    [self countDownTime:@60];
    
}

/**
 *  倒计时函数
 */
-(void)countDownTime:(NSNumber *)sourceDate{
    
    //    self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
    self.getCodeBtn.enabled = NO;
    __block int timeout = sourceDate.intValue; //倒计时时间
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 1){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                [weakSelf.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                weakSelf.getCodeBtn.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                NSString *numStr=[NSString stringWithFormat:@"剩余%d秒",timeout];
                //                [weakSelf.getCodeBtn setTitleColor:[UIColor colorWithWhite:0.573 alpha:1.000] forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitle:numStr forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  检查输入状态
 */
- (BOOL)checkInputMode
{
    NSString * regexPhoneNum = @"^1[0-9]{10}$";
    NSPredicate *predicatePhoneNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhoneNum];
    NSString * regexPasswordNum = @"[^\n]{6,16}$";
    NSPredicate *predicatePasswordNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPasswordNum];
    BOOL isPhoneMatch = [predicatePhoneNum evaluateWithObject:self.phoneNum.text];
    BOOL isPasswordMatch = [predicatePasswordNum evaluateWithObject: self.pwdTextFiled.text];
    BOOL ensurePwd = [self.pwdTextFiled.text isEqualToString:self.ensurePwd.text];
    if (!isPhoneMatch)
    {
        [MBProgressHUD showError:@"手机号输入错误" toView:self.view];
        return false;
    }
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
