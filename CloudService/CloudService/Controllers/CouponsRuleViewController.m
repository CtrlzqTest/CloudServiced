//
//  CouponsRuleViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/17.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CouponsRuleViewController.h"

@interface CouponsRuleViewController ()

@property (weak, nonatomic)IBOutlet UITextView *tvContent;
@end

@implementation CouponsRuleViewController

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

    self.tvContent.attributedText = [[NSAttributedString alloc] initWithString:@"【优惠券使用规则】\n单张车险保费每满1500元即可使用100元优惠券，出单时保费每满1500元系统会自动将优惠券转换为积分打到用户积分账户内（积分转换比例为：1:100）。优惠券到期日期以单张优惠券标注时间为准。优惠券扣除规则按到期时间优先扣除。" attributes:attributes];
    
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
