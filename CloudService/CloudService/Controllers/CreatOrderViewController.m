//
//  CreatOrderViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/24.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CreatOrderViewController.h"
#import "ZQCityPickerView.h"
#import "AppDelegate.h"
#import "OrderH5ViewController.h"
// baseId 25961588
@interface CreatOrderViewController ()
@property (weak, nonatomic)IBOutlet UITextField *tfName;
@property (weak, nonatomic)IBOutlet UITextField *tfPhone;
@property (weak, nonatomic)IBOutlet UITextField *tfLicenseNo;
@property (weak, nonatomic)IBOutlet UITextField *tfCarCity;

@end

@implementation CreatOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    // Do any additional setup after loading the view.
}
- (IBAction)nextAction:(id)sender {
    
    if ([_tfName.text isEqualToString:@""]) {
        [MBProgressHUD showMessag:@"请输入客户姓名" toView:self.view];
    }else if ([_tfPhone.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入客户手机号" toView:self.view];
    }else if ([_tfLicenseNo.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入车牌号" toView:self.view];
    }else if ([_tfCarCity.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入汽车所在省市" toView:self.view];
    }else if ([HelperUtil checkTelNumber:_tfPhone.text]){
        [MBProgressHUD showMessag:@"手机号格式不正确" toView:self.view];
    }else {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.isLogin=YES;
        /**
         *  dataType 01:创建订单,获取新数据 02:创建客户
         */
        NSDictionary *params = @{@"operType":@"测试",@"msg":@"",@"sendTime":@"",@"sign":@"",@"data":@{@"proportion":@"0.8",@"customerName":@"寇凯强",@"phoneNo":@"18637092233",@"dataType":@"01",@"comeFrom":@"YPT",@"activeType":@"1",@"macAdress":@"28:f0:76:18:c1:08",@"engineNo":@"jhg345325b135",@"vehicleFrameNo":@"dg3452",@"licenseNo":@"京A46456",@"vehicleModelName":@"阿斯顿马丁",@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"accountType":@"3",@"cityCode":@"28504700"}};
        
        __weak typeof(self) weakSelf = self;
        [MHNetworkManager postReqeustWithURL:kZhiKe params:params successBlock:^(id returnData) {
            
            NSLog(@"%@",returnData);
            delegate.isLogin=NO;
            if ([returnData[@"state"] isEqualToString:@"0"]) {
                NSString *url = [returnData[@"data"] valueForKey:@"retPage"];
                NSString *baseId = [returnData[@"data"] valueForKey:@"baseId"];
                [weakSelf createOrderWithBaseId:baseId pushUrl:url];
            }
            
        } failureBlock:^(NSError *error) {
            delegate.isLogin=NO;
            
        } showHUD:YES];
    }
}

- (void)createOrderWithBaseId:(NSString *)baseId pushUrl:(NSString *)url{
    
    NSDictionary *params = @{@"baseId":baseId,@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"custName":_tfName.text,@"phoneNo":_tfPhone.text,@"licenseNo":_tfLicenseNo.text};
    
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:ksaveOrder] params:params successBlock:^(id returnData) {
        
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            OrderH5ViewController *orderH5VC = [[OrderH5ViewController alloc] init];
            orderH5VC.url = url;
            [weakSelf.navigationController pushViewController:orderH5VC animated:YES];
        }else {
            [MBProgressHUD showError:[returnData objectForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

- (IBAction)showCityPickerView:(id)sender {
    
    [self resignKeyBoardInView:self.view];
    
    __block ZQCityPickerView *cityPickerView = [[ZQCityPickerView alloc] initWithProvincesArray:nil cityArray:nil componentsCount:2];
    
    [cityPickerView showPickViewAnimated:^(NSString *province, NSString *city,NSString *cityCode,NSString *provinceCode) {
        self.tfCarCity.text = [NSString stringWithFormat:@"%@ %@",province,city];
        NSLog(@"%@",cityCode);
        cityPickerView = nil;
    }];
    


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
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title=@"创建订单";
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
