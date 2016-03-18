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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation IntergralChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayoutConstraints];
    [self setupViews];
}

- (void)setLayoutConstraints {
    
    self.bottom.constant = 40 * KHeight / 667.0;
    self.viewTop.constant = 40 * KHeight / 667.0;
    
}

- (void)setupViews {
    
    self.title = @"积分兑换";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.backView.layer.cornerRadius = KWidth * 3 / 7 / 2.0;
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    self.intergTotalLabel.font = [UIFont systemFontOfSize:45 * KWidth / 414.0];
    if ([user.totalNum floatValue] >= 100000) {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%.1lf万",[user.totalNum floatValue] / 10000.0];
    }else {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%@",user.totalNum];
    }
    self.maxChangeLabel.text = [NSString stringWithFormat:@"最多可兑换%.0f元",[user.totalNum floatValue] / 100];
    
}

- (IBAction)btnAction:(id)sender {
    [self.intergNumTextFiled becomeFirstResponder];
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
        
    } showHUD:NO];
}

/**
 *  检查输入状态
 */
- (BOOL)checkInputMode
{
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    int useCache = [user.usableNum intValue];
    int cacheNmb = [self.intergNumTextFiled.text intValue];
    BOOL isCacheMatch = cacheNmb >= 10000 && (cacheNmb % 100 == 0);
    if (!isCacheMatch)
    {
        [MBProgressHUD showError:@"现金数目不对" toView:self.view];
        return false;
    }
    if (cacheNmb > useCache) {
        [MBProgressHUD showError:@"可用积分不足" toView:self.view];
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
