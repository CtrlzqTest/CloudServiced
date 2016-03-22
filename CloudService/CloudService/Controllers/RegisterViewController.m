//
//  RegisterViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RestAPI.h"
#import "YWBCityPickerView.h"
#import "Utility.h"
#import "ZQCityPickerView.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *locateBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwd;
@property (weak, nonatomic) IBOutlet UITextField *invateCode;
@property (nonatomic,strong)UIView *maskView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.borderWidth = 0.2;
    self.getCodeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.getCodeBtn.highlighted = NO;
    NSString *location = [Utility location];
    if (location) {
        [self.locateBtn setTitle:location forState:(UIControlStateNormal)];
    }else {
        [self.locateBtn setTitle:@"获取不到定位信息" forState:(UIControlStateNormal)];
    }
    self.registerBtn.layer.cornerRadius = 2;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

// 注册
- (IBAction)registerAction:(id)sender {
    
    [self resignKeyBoardInView:self.view];
    if ([self checkInputMode]) {
        NSString *location = self.locateBtn.titleLabel.text;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.phoneNum.text forKey:@"phoneNo"];
        [dict setValue:[Utility sha256WithString:self.pwdText.text] forKey:@"password"];
        [dict setValue:location forKey:@"address"];
        [dict setValue:self.codeText.text forKey:@"code"];
        [dict setValue:self.invateCode.text forKey:@"inviteCode"];
        __weak typeof(self) weakSelf = self;
    
        [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kRegisterAPI] params:dict successBlock:^(id returnData) {
            NSDictionary *dict = returnData;
            if ([dict[@"flag"] isEqualToString:@"success"]) {
                [Utility saveUserName:self.phoneNum.text passWord:@""];
                User *user = [User mj_objectWithKeyValues:[returnData valueForKey:@"data"]];
                [[SingleHandle shareSingleHandle] saveUserInfo:user];
                [weakSelf performSegueWithIdentifier:RegisterSuccess sender:weakSelf];
            }else {
                [MBProgressHUD showMessag:dict[@"msg"] toView:self.view];
            }
        } failureBlock:^(NSError *error) {

        } showHUD:YES];
    }
}

// 定位按钮
- (IBAction)locateAction:(id)sender {
    
    [self resignKeyBoardInView:self.view];

    __block ZQCityPickerView *cityPickerView = [[ZQCityPickerView alloc] initWithProvincesArray:nil cityArray:nil componentsCount:2];
    [cityPickerView showPickViewAnimated:^(NSString *province, NSString *city, NSString *cityCode, NSString *provinceCode) {
        self.locateBtn.selected = !self.locateBtn.selected;
        NSString *cityStr = [NSString stringWithFormat:@"%@%@",province,city];
        [self.locateBtn setTitle:cityStr forState:(UIControlStateNormal)];
        cityPickerView = nil;
    }];
    
}

- (IBAction)getCodeAction:(id)sender {
    
    NSString * regexPhoneNum = @"^1[0-9]{10}$";
    NSPredicate *predicatePhoneNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhoneNum];
    BOOL isPhoneMatch = [predicatePhoneNum evaluateWithObject:self.phoneNum.text];
    if (!isPhoneMatch)
    {
        [MBProgressHUD showMessag:@"手机号输入错误" toView:self.view];
    }else {
        [self countDownTime:@60];
        [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetCodeAPI] params:@{@"phoneNo":self.phoneNum.text} successBlock:^(id returnData) {
            if ([returnData[@"flag"] isEqualToString:@"success"]) {
                [MBProgressHUD showMessag:@"已发送验证码" toView:self.view];
            }
        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
    }
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

/** 消失键盘*/
- (void)resignKeyBoardInView:(UIView *)view

{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
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
    BOOL isPasswordMatch = [predicatePasswordNum evaluateWithObject: self.pwdText.text];
    BOOL ensurePwd = [self.pwdText.text isEqualToString:self.ensurePwd.text];
    if (!isPhoneMatch)
    {
        [MBProgressHUD showMessag:@"手机号输入错误" toView:self.view];
        return false;
    }
    if (!isPasswordMatch)
    {
        [MBProgressHUD showMessag:@"密码格式错误,请输入6到16位密码" toView:self.view];
        return false;
    }
    if (!ensurePwd)
    {
        [MBProgressHUD showMessag:@"两次输入密码不一致" toView:self.view];
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
