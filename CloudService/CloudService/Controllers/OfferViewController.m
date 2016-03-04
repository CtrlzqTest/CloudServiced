//
//  OfferViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/29.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "OfferViewController.h"
#import "SetUserInfoHeaderView.h"
#import "OfferTableViewCell.h"
static NSString *const header_id = @"setUserInfoHeader";
static CGFloat headerHeight = 30;
@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_footView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self initFootView];
    [self.tableView registerClass:[SetUserInfoHeaderView class] forHeaderFooterViewReuseIdentifier:header_id];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    self.title = @"立即报价";
    
}
- (void)initFootView {
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 60)];
    _footView.backgroundColor = [UIColor colorWithWhite:0.919 alpha:1.000];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave setBackgroundImage:[UIImage imageNamed:@"btn8"] forState:UIControlStateNormal];
    [_footView addSubview:btnSave];
    
    UIButton *btnOffer = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOffer setTitle:@"报价" forState:UIControlStateNormal];
    btnOffer.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnOffer setBackgroundImage:[UIImage imageNamed:@"btn4"] forState:UIControlStateNormal];
    [_footView addSubview:btnOffer];
    // 给左边视图添加约束
    [btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.mas_equalTo(10);
        // 添加左边距约束（距离当前主视图左边的距离）
        make.left.mas_equalTo(20);
        // 添加右边距约束（距离第二个按键左边的距离）
        make.right.equalTo(btnOffer.mas_left).with.offset(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(40);
        // 添加宽度（宽度跟右边按键一样）
        make.width.equalTo(btnOffer);
    }];
    
    // 给右边视图添加约束
    [btnOffer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.mas_equalTo(10);
        // 添加左边距约束（距离左边按键的距离）
        make.left.equalTo(btnSave.mas_right).with.offset(20);
        // 添加右边距约束（距离当前主视图右边的距离）
        make.right.mas_equalTo(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(40);
        // 添加宽度（宽度跟左边按键一样）
        make.width.equalTo(btnSave);
    }];
}

#pragma mark tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId=@"cell";
    
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OfferTableViewCell" owner:self options:nil];
        if (indexPath.section == 0) {
            cell = [array objectAtIndex:0];
        }else{
            cell = [array objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SetUserInfoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_id];
    headerView.titleLabel.text = section == 0 ? @"个人信息" : @"银行信息";
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        return _footView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else{
        return 60;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 279;
    }else{
        return 105;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return headerHeight;
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
