//
//  OrderInfoViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/25.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderInfoTableViewCell.h"


@interface OrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIView *footView;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    self.title=@"订单详情";
    
}


#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    OrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.callBtn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.priceBtn addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.appointmentBtn addTarget:self action:@selector(appointmentClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 214;
}
/** 拨打电话*/
- (void)callClick:(UIButton *)sender {
    
}
/** */
- (void)priceClick:(UIButton *)sender {
    
}
/** */
- (void)appointmentClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"appointment" sender:self];
}
/** */
/** */
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
