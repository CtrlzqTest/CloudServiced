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

@interface RegisterViewController ()<CLLocationManagerDelegate> {
    BOOL _isSetCity;
}

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property(nonatomic,strong)CLLocationManager *locateManager;
@property (weak, nonatomic) IBOutlet UIButton *locateBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwd;

@property (nonatomic, strong) YWBCityPickerView *cityPickerView;
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
    self.registerBtn.layer.cornerRadius = 2;
    
}

- (void)registerLocation {
    
    self.locateManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"");
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locateManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        self.locateManager.delegate = self;
        //设置定位精度
        self.locateManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=100.0;//十米定位一次
        self.locateManager.distanceFilter=distance;
        //启动跟踪定位
        [self.locateManager startUpdatingLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 注册定位
    [self registerLocation];
}

// 注册
- (IBAction)registerAction:(id)sender {
    
    [self resignKeyBoardInView:self.view];
    if ([self checkInputMode]) {
        [self performSegueWithIdentifier:RegisterSuccess sender:self];
    }
}

// 定位按钮
- (IBAction)locateAction:(id)sender {
    
    [self resignKeyBoardInView:self.view];
    if (!self.cityPickerView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0.363 green:0.380 blue:0.373 alpha:0.500];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCityPickerView:)]];
        [self.view addSubview:_maskView];
        self.cityPickerView = [[YWBCityPickerView alloc] init];
        self.cityPickerView.backgroundColor = [UIColor whiteColor];
        self.cityPickerView.frame = CGRectMake(0, self.view.frame.size.height, KWidth, 300);
    }
    [self showCityPickerView];
    
}

- (IBAction)getCodeAction:(id)sender {
    [self countDownTime:@60];
}

- (void)hideCityPickerView:(UIGestureRecognizer *)sender {
    
    self.locateBtn.selected = !self.locateBtn.selected;
    NSString *cityStr = [NSString stringWithFormat:@"%@%@",self.cityPickerView.province,self.cityPickerView.city];
    [self.locateBtn setTitle:cityStr forState:(UIControlStateNormal)];
    _maskView.hidden = YES;
    [self.cityPickerView hiddenPickerView];
}

- (void)showCityPickerView {
    
    _maskView.hidden = NO;
    [self.cityPickerView showInView:self.maskView];
    
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

#pragma mark -- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placeMark = nil;
    __weak typeof(self) weakSelf = self;
    [geoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (_isSetCity) {
            return ;
        }
        if (placemarks.count > 0) {
            placeMark = [placemarks firstObject];
            NSString *city = [NSString stringWithFormat:@"%@%@",placeMark.locality,placeMark.subLocality];
            NSLog(@"%@",city);
            [weakSelf.locateBtn setTitle:city forState:(UIControlStateNormal)];
            _isSetCity = YES;
        }
    }];
    //如果不需要实时定位，使用完即使关闭定位服务
    [self.locateManager stopUpdatingLocation];
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
