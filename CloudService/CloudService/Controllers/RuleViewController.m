//
//  RuleViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic)IBOutlet UITextView *tvConent;
@property (weak, nonatomic)IBOutlet UIImageView *imageView;
@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (KHeight == 736) {
        self.topLayout.constant = 190.f;
    }else if (KHeight == 667) {
        self.topLayout.constant = 170.f;
    }else {
        self.topLayout.constant = 150.f;
    }
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
    if ([self.ruleStr isEqualToString:@"活动1"]) {
        self.imageView.image = [UIImage imageNamed:@"rulebg1"];
        self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动参与规则】\n 1.首次注册的用户并认证成功（每位用户限参与一次）；\n 2.通过邀请新用户，（注册时必须要填写邀请人的邀请码，否则邀请人无法正常获取猴子）新用户注册成功后，赠送邀请人一只猴子（猴子种类随机派分）。\n 3.活动时间内集齐三种不同的猴子方可成功获得创业基金5000元优惠券。\n【兑现规则】\n 凡是在活动期间按照活动规则集满三种不同的小猴子，5000元创业基金优惠劵当日打到云客服优惠劵账户。\n【优惠劵使用规则】\n 车险保费每满1500元可使用100元优惠券，出单时保费满1500元系统会自动将优惠劵转换为积分打到用户积分账户内（积分转换比例为：1:100）\n【活动时间】\n2016年3月20日00时起\n2016年4月30日24时止。" attributes:attributes];
    }else if ([self.ruleStr isEqualToString:@"活动2"]) {
        self.imageView.image = [UIImage imageNamed:@"rulebg2"];
        self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动内容】\n 邀请好友注册成功后（注册时必须要填写邀请人的邀请码，否则无法正常获得优惠券），赠送邀请人100元优惠劵。\n【兑现规则】\n 优惠劵实时到账。\n【优惠劵使用规则】\n 车险保费每满1500元可使用100元优惠券，出单时保费满1500元系统会自动将优惠劵转换为积分打到用户积分账户内（积分转换比例为：1:100）。\n【活动时间】\n2016年3月20日00时起\n2016年4月30日24时止。" attributes:attributes];
        
    }else {
        self.imageView.image = [UIImage imageNamed:@"rulebg3"];
        self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动内容】\n 邀请好友注册认证成功后（注册时必须要填写邀请人的邀请码，否则邀请人无法获得师傅激励）并连续3个月出单，邀请人可获得前3个月的师傅激励。\n【奖励规则】\n 师傅可获得徒弟前三个月积分的1个点的积分奖励，如：徒弟的积分为：30000积分（积分转换比例为：1:100），邀请人将获得300积分！\n【兑现规则】\n 激励积分次月5号前到账（即徒弟注册日起3个月为止）。\n【活动时间】\n2016年3月20日00时起\n2016年4月30日24时止。" attributes:attributes];
        
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
