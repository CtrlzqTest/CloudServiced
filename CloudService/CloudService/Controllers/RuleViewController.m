//
//  RuleViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@property (weak, nonatomic)IBOutlet UITextView *tvConent;
@property (weak, nonatomic)IBOutlet UIImageView *imageView;
@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    if ([self.ruleStr isEqualToString:@"活动2"]) {
        self.imageView.image = [UIImage imageNamed:@"rulebg2"];
        self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动内容】\n 邀请好友注册认证成功后并连续3个月出单，邀请人可获得前3个月的师傅激励。\n【奖励规则】\n 前3个月每个月积分1个点的积分，如：X个积分为：3000万元，邀请人将获得60元积分。\n【兑现规则】\n 优惠劵次月5号前到账（即徒弟注册日起3个月为止）。\n【优惠劵使用规则】\n 车险保费每满1500元可使用100元优惠券，出单是保费满1500元系统会自动将优惠劵转换为积分打到用户积分账户内（积分转换比例为：1:100）\n 活动时间：2016年3月20日零时起-----2016年4月30日24时止。" attributes:attributes];
    }else {
        self.imageView.image = [UIImage imageNamed:@"rulebg1"];
        self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动内容】\n 邀请用户注册成功后，曾送邀请人100元优惠劵卷。\n【兑现规则】\n 优惠劵实时到账。\n【优惠劵使用规则】\n 车险保费每满1500元可使用100元优惠券，出单是保费满1500元系统会自动将优惠劵转换为积分打到用户积分账户内（积分转换比例为：1:100）\n 活动时间：2016年3月20日零时起-----2016年4月30日24时止。" attributes:attributes];
        
    }
    self.tvConent.textColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
