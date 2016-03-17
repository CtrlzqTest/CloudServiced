//
//  MyIntergralViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MyIntergralViewController.h"
#import "IntergralCityViewController.h"

@interface MyIntergralViewController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *intergTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *intergUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *intergUnuseLabel;

// 间距适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intergTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usableLeadIng;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@end

@implementation MyIntergralViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupLayoutConstranints];
    [self setupViews];
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:ExchangeIntegralSuccess object:nil];
}

- (void)getData {
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    __weak typeof(self) weakSelf = self;
    NSLog(@"%@",user.userId);
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetuserIntergralAPI] params:@{@"userId":user.userId} successBlock:^(id returnData) {
        NSDictionary *dict = [returnData valueForKey:@"data"];
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            user.totalNum = dict[@"totalNum"];
            user.frozenNum = dict[@"frozenNum"];
            user.usableNum = dict[@"usableNum"];
            [[SingleHandle shareSingleHandle] saveUserInfo:user];
            [weakSelf reloadViews];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showMessag:@"数据刷新失败" toView:self.view];
    } showHUD:NO];
}

- (void)setupLayoutConstranints {
    
    self.intergTop.constant = 70.0 * KHeight / 640;
    self.inset.constant = 50.0 * KHeight / 640;
    self.btnBottom.constant = 35.0 * KHeight / 640;
    self.usableLeadIng.constant = 80 * KWidth / 414.0 - 10;
    self.trailing.constant = 50 * KWidth / 414.0 - 10;
    self.intergTotalLabel.font = [UIFont systemFontOfSize:45 * KWidth / 414.0];
    self.intergUseLabel.font = [UIFont systemFontOfSize:19 * KWidth / 414.0];
    self.intergUnuseLabel.font = [UIFont systemFontOfSize:19 * KWidth / 414.0];
    
}

- (void)setupViews {
    
    self.title = @"我的积分";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.backView.layer.cornerRadius = KWidth * 3 / 7 / 2.0;
    
    [weakSelf setRightTextBarButtonItemWithFrame:CGRectMake(0, 0, 80, 30) title:@"积分明细" titleColor:[UIColor whiteColor] backImage:@"" selectBackImage:@"" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"integral" sender:weakSelf];
       
    }];
}

- (void)reloadViews {
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    if ([user.totalNum floatValue] >= 100000) {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%.1lf万",[user.totalNum floatValue] / 10000.0];
    }else {
        self.intergTotalLabel.text = [NSString stringWithFormat:@"%@",user.totalNum];
    }
    if ([user.usableNum floatValue] >= 100000) {
        self.intergUseLabel.text = [NSString stringWithFormat:@"%.1lf万",[user.usableNum floatValue] / 10000.0];
    }else {
        self.intergUseLabel.text = [NSString stringWithFormat:@"%@",user.usableNum];
    }
    if ([user.frozenNum floatValue] >= 100000) {
        self.intergUnuseLabel.text = [NSString stringWithFormat:@"%.1lf万",[user.frozenNum floatValue] / 10000.0];
    }else {
        self.intergUnuseLabel.text = [NSString stringWithFormat:@"%@",user.frozenNum];
    }
}

- (IBAction)intergralCityAction:(id)sender {
    [MBProgressHUD showMessag:@"程序猿正在火力开发中" toView:self.view];
//    IntergralCityViewController *VC = [[IntergralCityViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
