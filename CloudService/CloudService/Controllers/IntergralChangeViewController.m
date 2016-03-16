//
//  IntergralChangeViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "IntergralChangeViewController.h"

@interface IntergralChangeViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *intergTotalLabel;
@property (weak, nonatomic) IBOutlet UITextField *intergNumTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *maxChangeLabel;

@end

@implementation IntergralChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    
    self.title = @"积分兑换";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.backView.layer.cornerRadius = KWidth * 3 / 7 / 2.0;
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    if ([user.totalNum floatValue] >= 100000) {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%.1lf万",[user.totalNum floatValue] / 10000.0];
    }else {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%@",user.totalNum];
    }
    self.maxChangeLabel.text = [NSString stringWithFormat:@"最多可兑换%.0f元",[user.totalNum floatValue] / 1000];
    
}

- (IBAction)changeIntergralAction:(id)sender {
    
    if (![self checkInputMode]) {
        return;
    }
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetExchangeIntergralAPI] params:@{@"userId":user.userId,@"cash":self.intergNumTextFiled.text} successBlock:^(id returnData) {
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:ExchangeIntegralSuccess object:nil];
        }else{
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
    int cacheNmb = [self.intergNumTextFiled.text intValue];
    BOOL isCacheMatch = cacheNmb >= 10000 && (cacheNmb % 100 == 0);
    if (!isCacheMatch)
    {
        [MBProgressHUD showError:@"现金数目不对" toView:self.view];
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
