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

@end

@implementation MyIntergralViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupLayoutConstranints];
    [self setupViews];
}

- (void)setupLayoutConstranints {
    
    self.intergTop.constant = 70.0 * KHeight / 640;
    self.inset.constant = 50.0 * KHeight / 640;
    self.btnBottom.constant = 35.0 * KHeight / 640;
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
- (IBAction)intergralCityAction:(id)sender {
    
    IntergralCityViewController *VC = [[IntergralCityViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
