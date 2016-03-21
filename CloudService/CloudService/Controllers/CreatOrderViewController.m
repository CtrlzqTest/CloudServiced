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
@interface CreatOrderViewController ()<UITextFieldDelegate>
{
    NSString *_cityCode;
}
@property (weak, nonatomic)IBOutlet UITextField *tfName;
@property (weak, nonatomic)IBOutlet UITextField *tfPhone;
@property (weak, nonatomic)IBOutlet UITextField *tfLicenseNo;
@property (weak, nonatomic)IBOutlet UITextField *tfCarCity;
@property (weak, nonatomic)IBOutlet UIButton *isNewCarBtn;

@end

@implementation CreatOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.tfLicenseNo.delegate = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    // Do any additional setup after loading the view.
}
- (IBAction)nextAction:(id)sender {
    if ([_tfName.text isEqualToString:@""]) {
        [MBProgressHUD showMessag:@"请输入客户姓名" toView:self.view];
        return ;
    }
    if ([_tfPhone.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入客户手机号" toView:self.view];
        return ;
    }
    if (!self.isNewCarBtn.selected && [_tfLicenseNo.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入车牌号" toView:self.view];
        return ;
    }
    if ([_tfCarCity.text isEqualToString:@""]){
        [MBProgressHUD showMessag:@"请输入汽车所在城市" toView:self.view];
        return ;
    }
    
    
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.isThird=YES;
        /**
         *  dataType 01:创建订单,获取新数据 02:创建客户
         */
        User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSString *licenseNo = self.tfLicenseNo.text;
    if ([self.tfLicenseNo.text isEqualToString:@""]) {
        licenseNo = @"新车";
    }
        NSDictionary *params = @{@"operType":@"测试",
                                 @"msg":@"",
                                 @"sendTime":@"",
                                 @"sign":@"",
                                 @"data":@{@"proportion":@"0.8",
                                           @"customerName":_tfName.text,
                                           @"phoneNo":_tfPhone.text,
                                           @"dataType":@"01",
                                           @"comeFrom":@"YPT",
                                           @"activeType":@"1",
                                           @"macAdress":@"28:f0:76:18:c1:08",
                                           @"agentCode":@"",
                                           @"engineNo":@"jhg345325b135",
                                           @"vehicleFrameNo":@"dg3452",
                                           @"licenseNo":licenseNo,
                                           @"vehicleModelName":@"阿斯顿马丁",
                                           @"userId":user.userId,
                                           @"accountType":@"3",
                                           @"cityCode":_cityCode}
                                 };
        
        __weak typeof(self) weakSelf = self;
        [MHNetworkManager postReqeustWithURL:kZhiKe params:params successBlock:^(id returnData) {
            
            delegate.isThird=NO;
            if ([returnData[@"state"] isEqualToString:@"0"]) {
                NSString *url = [returnData[@"data"] valueForKey:@"retPage"];
                NSString *baseId = [returnData[@"data"] valueForKey:@"baseId"];
                [weakSelf createOrderWithBaseId:baseId pushUrl:url];
            }
            
        } failureBlock:^(NSError *error) {
            delegate.isThird=NO;
            
        } showHUD:YES];
    
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
- (IBAction)newCarAction:(id)sender {
    NSLog(@"%d",self.isNewCarBtn.selected);
    if (self.isNewCarBtn.selected)
    {
        [self.isNewCarBtn setImage:[UIImage imageNamed:@"checkbox"] forState:(UIControlStateNormal)];
        self.tfLicenseNo.enabled = YES;
        self.tfLicenseNo.placeholder = @"请输入车牌号";
    }else
    {
        [self.isNewCarBtn setImage:[UIImage imageNamed:@"checkbox_"] forState:(UIControlStateNormal)];
        self.tfLicenseNo.enabled = NO;
        self.tfLicenseNo.placeholder = @"暂无车牌号";
    }
    self.isNewCarBtn.selected = !self.isNewCarBtn.selected;
    
}
- (IBAction)showCityPickerView:(id)sender {
    
    [HelperUtil resignKeyBoardInView:self.view];
    
    __block ZQCityPickerView *cityPickerView = [[ZQCityPickerView alloc] initWithProvincesArray:nil cityArray:nil componentsCount:2];
    
    [cityPickerView showPickViewAnimated:^(NSString *province, NSString *city,NSString *cityCode,NSString *provinceCode) {
        self.tfCarCity.text = [NSString stringWithFormat:@"%@ %@",province,city];
        _cityCode = cityCode;
        cityPickerView = nil;
    }];
    


}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.tfLicenseNo]) {
        self.tfLicenseNo.text = [textField.text uppercaseString];
    }
    if ([textField isEqual:self.tfPhone]) {
        if (![HelperUtil checkTelNumber:self.tfPhone.text]){
            [MBProgressHUD showMessag:@"手机号格式不正确" toView:self.view];
            return ;
        }
    }
    
    if ([textField isEqual:self.tfLicenseNo]) {
        if (![self.tfLicenseNo.text isEqualToString:@""] && ![HelperUtil validateCarNo:self.tfLicenseNo.text]){
            [MBProgressHUD showMessag:@"车牌号格式不正确" toView:self.view];
            return ;
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
