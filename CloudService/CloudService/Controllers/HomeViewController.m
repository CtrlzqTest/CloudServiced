//
//  HomeViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "HomeHeaderView.h"
#import "IntergralCityViewController.h"
#import "SingleHandle.h"
#import "UserInfoViewController.h"
#import "Utility.h"
#import "OrderInfoViewController.h"
#import "FireData.h"
#import "RuleViewController.h"
#import "Order.h"
#import "SetUserInfoViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *_dataDict;
    NSArray *_dataKeyArray;
    NSArray *_imageArray;
    NSArray *_scrollImgArray;
    NSString *_integral;
    BOOL _isHide;
    Order *_order;//获取数据
    HomeHeaderView *_headerView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *cell_id = @"menuCell";
static NSString *headerView_ID = @"headerView";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.tabBarController.tabBar setBackgroundColor:[UIColor blackColor]];
    [self initData];
    [self setupViews];
    // 获取我的积分
    [self getMyintegralData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyintegralData) name:ExchangeIntegralSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView:) name:ReloadHomeData object:nil];

    
}

- (void)initData {
    
    _dataKeyArray = @[@"获取数据",@"我的客户",@"创建订单",@"积分商城",@"邀请好友",@"我的积分"];
    _imageArray = @[@"home-icon1",@"home-icon2",@"home-icon3",@"home-icon4",@"home-icon5",@"home-icon6"];
    
    _dataDict = [NSMutableDictionary dictionary];
    [_dataDict setValue:@"获取客户数据" forKey:_dataKeyArray[0]];
    [_dataDict setValue:@"我的客户明细" forKey:_dataKeyArray[1]];
    [_dataDict setValue:@"创建我的订单" forKey:_dataKeyArray[2]];
    [_dataDict setValue:@"积分兑换商城" forKey:_dataKeyArray[3]];
    [_dataDict setValue:@"邀请我的好友" forKey:_dataKeyArray[4]];
    [_dataDict setValue:@"积分明细查看" forKey:_dataKeyArray[5]];
    
    _scrollImgArray = @[@"banner",@"activity3",@"activity2"];

}
- (IBAction)my:(id)sender {
    [self performSegueWithIdentifier:@"my" sender:self];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:cell_id];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView_ID];
    
    CGFloat inset = 8;
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.minimumInteritemSpacing = inset;
    flowLayOut.minimumLineSpacing = 2 * inset;
    flowLayOut.sectionInset = UIEdgeInsetsMake(2 * inset, inset, 2 * inset, inset);
    flowLayOut.itemSize = CGSizeMake((KWidth - 4 * inset) / 3.0, (KWidth - 4 * inset) / 3.0 * 12 / 11.0);
    flowLayOut.headerReferenceSize = CGSizeMake(KWidth, 240 * KHeight / 667.0);
    self.collectionView.collectionViewLayout = flowLayOut;
    
}


- (void)viewWillAppear:(BOOL)animated {
    //导航条滑动返回
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.frame = CGRectMake(0, 0, KWidth, KHeight - 64);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [HelperUtil
                                                            colorWithHexString:@"1FAAF2"];

    //隐藏导航栏黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.tabBarController.title = @"首页";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)signAction:(UIButton *)sender {
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    if ([user.roleName isEqualToString:@"普通用户"] || user.roleName.length <= 0) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户为普通用户,不能签到,请到个人中心认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    
        [alterView show];
        return ;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:user.userId forKey:@"userId"];
    [dict setValue:[Utility location] forKey:@"address"];
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kSignedAPI]
                                  params:dict
                            successBlock:^(id returnData) {
                                
            if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
                [sender setBackgroundImage:[UIImage imageNamed:@"home-icon7_"] forState:(UIControlStateNormal)];
                [sender setTitle:@"已签到" forState:(UIControlStateNormal)];
                sender.enabled = NO;
                user.sign = @"1";
                [[SingleHandle shareSingleHandle] saveUserInfo:user];
                
            }
    } failureBlock:^(NSError *error) {
    
    } showHUD:YES];
    
}
//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (buttonIndex == 1) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SetUserInfoViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"setUserInfo"];
        setUserInfoVC.rightBtnTitle = @"提交";
        [self.navigationController pushViewController:setUserInfoVC animated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataKeyArray.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        _headerView = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView_ID forIndexPath:indexPath];
        if ([[[SingleHandle shareSingleHandle] getUserInfo].sign isEqualToString:@"1"]) {
            [_headerView.sginBtn setBackgroundImage:[UIImage imageNamed:@"home-icon7_"] forState:(UIControlStateNormal)];
            [_headerView.sginBtn setTitle:@"已签到" forState:(UIControlStateNormal)];
            _headerView.sginBtn.enabled = NO;
        }
        
        User *user = [[SingleHandle shareSingleHandle] getUserInfo];
        _headerView.headImg.userInteractionEnabled = YES;
        [_headerView.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderAction)]];
        [_headerView.sginBtn addTarget:self action:@selector(signAction:) forControlEvents:(UIControlEventTouchUpInside)];
        if ([_integral floatValue] >= 100000) {
            _headerView.integralLabel.text = [NSString stringWithFormat:@"%.1lf万",[_integral floatValue] / 10000.0];
        }else {
            if (_integral.length <= 0) {
                _headerView.integralLabel.text = [NSString stringWithFormat:@"%@",@""];
            }else {
                _headerView.integralLabel.text = [NSString stringWithFormat:@"%@",_integral];
            }
        }
//        _headerView.integralLabel.text = _integral;·
        NSString *userName = nil;
        userName = user.realName.length > 0 ? user.realName : user.userName;
        [_headerView setDataWithDictionary:@{@"userName":userName}];
        // 轮播图开始轮播
        [_headerView playWithImageArray:_scrollImgArray clickAtIndex:^(NSInteger index) {
            if (index == 0) {
                [self performSegueWithIdentifier:@"activity" sender:self];
            }
            if (index == 1) {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RuleViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"RuleVC"];
                vc.ruleStr = @"活动2";
                [self.navigationController pushViewController:vc animated:YES];

            }
            if (index == 2) {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RuleViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"RuleVC"];
                vc.ruleStr = @"活动3";
                [self.navigationController pushViewController:vc animated:YES];

            }
        }];
        return _headerView;
    }else {
        return [[UICollectionReusableView alloc] init];
    }
    return nil;
}

- (void)tapHeaderAction {
    
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoViewController *userInfoVC = [stroyBoard instantiateViewControllerWithIdentifier:@"userInfoVC"];
    userInfoVC.isFromhomeVC = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    cell.titleLabel.text = _dataKeyArray[indexPath.row];
    cell.detailTitleLabel.text = [_dataDict valueForKey:_dataKeyArray[indexPath.row]];
    cell.titleImg.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self getData];

            break;
        case 1:
            [[FireData sharedInstance] eventWithCategory:@"我的客户" action:@"获取数据" name:@"" value:@"" attributes:nil];
            [self performSegueWithIdentifier:@"myClient" sender:self];
            break;
        case 2:
//            [self performSegueWithIdentifier:@"creatOrder" sender:self];
            [MBProgressHUD showMessag:@"程序猿正在火力开发中" toView:self.view];
            break;
        case 3:
//        {
//            IntergralCityViewController *intergCityVC = [[IntergralCityViewController alloc] init];
//            [self.navigationController pushViewController:intergCityVC animated:YES];
//        }
            [MBProgressHUD showMessag:@"程序猿正在火力开发中" toView:self.view];
            break;
        case 4:
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"InviteFriendsVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            [self performSegueWithIdentifier:@"myIntergralVC_push" sender:self];
            break;
            
        default:
            break;
    }
}

/**
 *  刷新数据
 */

-(void)reloadCollectionView:(id)notice {
    [self.collectionView reloadData];
}

/**
 *  获取我的积分
 */

- (void)getMyintegralData {
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetuserIntergralAPI]
                                  params:@{@"userId":user.userId}
                            successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            NSString *str = [returnData[@"data"] valueForKey:@"totalNum"];
            _integral = [NSString stringWithFormat:@"%@",str];
            [weakSelf.collectionView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

/** 获取数据*/
- (void)getData {
    
    if ([[[SingleHandle shareSingleHandle] getUserInfo].sign isEqualToString:@"1"]) {
        
        NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId};
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kapplyCustomerData];
        
        [MHNetworkManager postReqeustWithURL:url
                                      params:paramsDic
                                successBlock:^(id returnData) {
                                    
            NSDictionary *dic = returnData;
            if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                _order = [Order mj_objectWithKeyValues:dataDic];
                [self performSegueWithIdentifier:@"getData" sender:self];
                
            }else {
                [MBProgressHUD showMessag:[dic objectForKey:@"msg"] toView:self.view];
            }
            
        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
    }else {
        [MBProgressHUD showMessag:@"您还未签到，不能获取数据" toView:self.view];
    }
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"getData"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        OrderInfoViewController *receive = segue.destinationViewController;
        receive.order = _order;
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
