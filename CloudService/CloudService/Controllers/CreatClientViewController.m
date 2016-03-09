//
//  CreatClientViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CreatClientViewController.h"
#import "OfferViewController.h"

@interface CreatClientViewController ()
@property (weak, nonatomic)IBOutlet UITextField *tfName;
@property (weak, nonatomic)IBOutlet UITextField *tfPhone;
@property (weak, nonatomic)IBOutlet UITextField *tfLicenseNo;
@property (weak, nonatomic) IBOutlet UIButton *isNewCarBtn;
@end

@implementation CreatClientViewController

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
    }else {
        [self performSegueWithIdentifier:@"offer" sender:self];
        
    }
}

- (IBAction)newCarAction:(id)sender {
    NSLog(@"%d",self.isNewCarBtn.selected);
    if (self.isNewCarBtn.selected)
    {
        [self.isNewCarBtn setImage:[UIImage imageNamed:@"checkbox"] forState:(UIControlStateNormal)];
    }else
    {
        [self.isNewCarBtn setImage:[UIImage imageNamed:@"checkbox_"] forState:(UIControlStateNormal)];
    }
    self.isNewCarBtn.selected = !self.isNewCarBtn.selected;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"创建客户";
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"offer"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        OfferViewController *offerVC = segue.destinationViewController;
        offerVC.carCode = _tfLicenseNo.text;
        offerVC.phoneNo = _tfPhone.text;
        offerVC.custName = _tfName.text;
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
