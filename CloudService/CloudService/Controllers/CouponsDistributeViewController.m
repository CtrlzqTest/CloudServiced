//
//  CouponsDistributeViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/8.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CouponsDistributeViewController.h"
#import "CouponsDistributeCell.h"
#import "TeamMember.h"

@interface CouponsDistributeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *_headView;
    UIView *_footView;
    UIImageView *_checkImg;
    NSMutableArray *_teamMemberArray;//数据源数组

    int checkCount;
    BOOL isAllCheck;
}
@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, weak)IBOutlet UIImageView *allCheckImg;
@property (nonatomic, weak)IBOutlet UITapGestureRecognizer *allCheckTap;
@end

@implementation CouponsDistributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _teamMemberArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.allCheckTap addTarget:self action:@selector(allCheckTap:)];
    [self requestMember];
    [self setupFoot];
    self.tableView.tableFooterView = _footView;
    // Do any additional setup after loading the view.
}
- (void)requestMember {
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindTeamMember];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
        
            
            NSArray *listArray = [dataDic objectForKey:@"list"];
            _teamMemberArray =[TeamMember mj_objectArrayWithKeyValuesArray:listArray];
    
            NSLog(@"%@",_teamMemberArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
        }
        [self.tableView reloadData];

    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"服务器异常" toView:self.view];
    } showHUD:YES];

}

- (void)setupFoot {
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 60)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 12, KWidth-20, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"btn10"] forState:UIControlStateNormal];
    [button setTitle:@"派发优惠券" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(distributeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:button];
}
- (void)distributeClick:(UIButton *)sender {
    
}
#pragma  mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _teamMemberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell"];
    CouponsDistributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CouponsDistributeCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TeamMember *teamMember = [_teamMemberArray objectAtIndex:indexPath.row];
    if (teamMember.isCheck) {
        [cell.checkImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox_"]];
    }else {
        [cell.checkImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox"]];
    }
    cell.checkImg.tag = indexPath.row;
    [cell.checkTap addTarget:self action:@selector(checkTap:)];
    cell.tfMoney.tag = indexPath.row;
    cell.tfMoney.delegate = self;
    if (teamMember.moneyNum==0) {
        cell.tfMoney.text = @"";
    }else {
        cell.tfMoney.text = [NSString stringWithFormat:@"%i",teamMember.moneyNum];
    }
    
    return cell;
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)checkTap:(UITapGestureRecognizer *)tap {
    TeamMember *teamMember = [_teamMemberArray objectAtIndex:tap.view.tag];
    teamMember.isCheck = !teamMember.isCheck;
    checkCount = 0;
    for (TeamMember *teamMember1 in _teamMemberArray) {
        if (teamMember1.isCheck) {
            checkCount ++;
        }
    }
    if (checkCount == _teamMemberArray.count) {
        isAllCheck=YES;
        [self.allCheckImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox_"]];
    }else{
        [self.allCheckImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox"]];
    }
    [self.tableView reloadData];
}

- (void)allCheckTap:(UITapGestureRecognizer *)tap {
    isAllCheck = !isAllCheck;
    if (isAllCheck) {
        [self.allCheckImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox_"]];
        for (TeamMember *teamMember1 in _teamMemberArray) {
            teamMember1.isCheck=YES;
            [self.tableView reloadData];
        }
    }else{
        [self.allCheckImg setImage:[UIImage imageNamed:@"youhuiquan-checkbox"]];
        for (TeamMember *teamMember1 in _teamMemberArray) {
            teamMember1.isCheck=NO;
            [self.tableView reloadData];
        }
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    TeamMember *teamMember = [_teamMemberArray objectAtIndex:textField.tag];
    teamMember.moneyNum = [textField.text intValue];
   
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
