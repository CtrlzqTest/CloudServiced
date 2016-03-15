//
//  ActivityRuleViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ActivityRuleViewController.h"

@interface ActivityRuleViewController ()

@property (weak, nonatomic)IBOutlet UITextView *tvConent;
@end

@implementation ActivityRuleViewController

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
    self.tvConent.attributedText = [[NSAttributedString alloc] initWithString:@"【活动参与规则】\n 1.首次注册的用户并认证成功（每位用户限参与一次）；\n 2.通过邀请新用户，新用户注册成功后，赠送邀请人一只猴子（猴子种类随机派分）。\n 3.活动时间内集齐三种不同的猴子方可成功获得创业基金5000元优惠券。\n【兑现规则】\n 凡是在活动期间按照活动规则集满三种不同的小猴子，5000元创业基金优惠劵当日打到云客服优惠劵账户。\n【优惠劵使用规则】\n 车险保费每满1500元可使用100元优惠券，出单是保费满1500元系统会自动将优惠劵转换为积分打到用户积分账户内（积分转换比例为：1:100）" attributes:attributes];
    self.tvConent.textColor = [UIColor lightGrayColor];
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
