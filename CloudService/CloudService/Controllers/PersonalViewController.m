//
//  PersonalViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalViewCell.h"
#import "SingleHandle.h"
#import "UserInfoViewController.h"
#import "SetUserInfoViewController.h"
#import "InviteFriendViewController.h"

@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSArray *_dataArray;
    NSMutableDictionary *_dataDict;
}

@property (weak, nonatomic) IBOutlet UIImageView *headIconImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *cell_id = @"personalCell";

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupViews];
    
    
}

- (void)initData {
    
    NSArray *array1 = @[@"个人中心",@"我的团队",@"积分管理",@"用户认证",@"团队成员邀请",@"好友邀请"];
    NSArray *array2 = @[@"我的优惠券"];
    NSArray *array3 = @[@"关于应用"];
    
    _dataArray = [NSArray arrayWithObjects:array1,array2,array3, nil];
    
    _dataDict = [NSMutableDictionary dictionary];
    [_dataDict setValue:@"userInfo" forKey:array1[0]];
    [_dataDict setValue:@"user-icon1" forKey:array1[1]];
    [_dataDict setValue:@"user-icon2" forKey:array1[2]];
    [_dataDict setValue:@"user-icon3" forKey:array1[3]];
    [_dataDict setValue:@"user-icon4" forKey:array1[4]];
    [_dataDict setValue:@"user-icon5" forKey:array1[5]];
    [_dataDict setValue:@"user-icon6" forKey:array2[0]];
    [_dataDict setValue:@"user-icon7" forKey:array3[0]];
//    [_dataDict setValue:@"user-icon8" forKey:array3[1]];
    
}

- (void)setupViews {
    
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalViewCell" bundle:nil] forCellReuseIdentifier:cell_id];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadicon)];
    [self.headIconImg addGestureRecognizer:tap];
}

// 退出登录
- (void)logOutAction {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutViewNotice object:nil];
}

- (void)tapHeadicon {
    [self performSegueWithIdentifier:@"userinfoVC" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.frame = [UIScreen mainScreen].bounds;
    [super viewWillAppear:animated];
    self.tabBarController.title = @"个人中心";
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSString *userName = nil;
    userName = user.realName.length > 0 ? user.realName : user.userName;
    self.userNameLabel.text = userName;
    self.phoneNumLabel.text = user.phoneNo;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _dataArray.count) {
        return 1;
    }else {
        return [_dataArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == _dataArray.count) {
#warning cell宽度有问题,可能是没有启动图
        static NSString *cell_ID = @"logOutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_ID];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight / 667.0  * 44)];
            label.textColor = [UIColor colorWithRed:0.128 green:0.496 blue:0.867 alpha:1.000];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"退出登录";
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    PersonalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    cell.titleLabel.text = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.titleImage.image = [UIImage imageNamed:[_dataDict valueForKey:[_dataArray[indexPath.section] objectAtIndex:indexPath.row]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KHeight / 667.0  * 50;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogOutViewNotice object:nil];
        return;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
                case 0:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SetUserInfoViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"setUserInfo"];
                setUserInfoVC.rightBtnTitle = @"保存";
                [self.navigationController pushViewController:setUserInfoVC animated:YES];
            }
                break;
            case 1:
            {
                if ([[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"团队长"]||[[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"认证用户"]) {
                   [self performSegueWithIdentifier:@"pushMyTeam" sender:self];
                }else{
                    [MBProgressHUD showMessag:@"对不起，您还没有自己的团队" toView:self.view];
                }
                
            }
                break;
            case 2:
            {
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"MyIntergVC"];
                [self.navigationController pushViewController:setUserInfoVC animated:YES];
                
            }
                break;
            case 3:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SetUserInfoViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"setUserInfo"];
                setUserInfoVC.rightBtnTitle = @"提交";
                User *user = [[SingleHandle shareSingleHandle] getUserInfo];
                if (![user.roleName isEqualToString:@"普通用户"]) {
                    [MBProgressHUD showMessag:@"用户已认证,修改请到个人中心" toView:self.view];
                    return;
                }
                [self.navigationController pushViewController:setUserInfoVC animated:YES];
            }
                break;
            case 4:
            {
                if ([[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"团队长"]||[[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"团队成员"]) {
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    InviteFriendViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"InviteFriendsVC"];
                    vc.isTeamInvite = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [MBProgressHUD showMessag:@"您还没有团队" toView:self.view];
                }
                
            }
                break;
            case 5:
            {
                [self performSegueWithIdentifier:@"invateFriend_push" sender:self];
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"coupons" sender:self];
    }
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"aboutApp_push" sender:self];
    }
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
