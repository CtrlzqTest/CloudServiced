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
#import "ClientData.h"
#import "UserInfoViewController.h"
#import "Utility.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableDictionary *_dataDict;
    NSArray *_dataKeyArray;
    NSArray *_imageArray;
    NSArray *_scrollImgArray;
    
    BOOL _isHide;
    NSString *_integral; // 积分
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
}

- (void)initData {
    
    _dataKeyArray = @[@"获取数据",@"我的客户",@"创建订单",@"积分商城",@"邀请好友",@"我的积分"];
    _imageArray = @[@"home-icon1",@"home-icon2",@"home-icon3",@"home-icon4",@"home-icon5",@"home-icon6"];
    
    _dataDict = [NSMutableDictionary dictionary];
    [_dataDict setValue:@"获取客户数据" forKey:_dataKeyArray[0]];
    [_dataDict setValue:@"我的客户内容" forKey:_dataKeyArray[1]];
    [_dataDict setValue:@"联系我的订单" forKey:_dataKeyArray[2]];
    [_dataDict setValue:@"商城自选内容" forKey:_dataKeyArray[3]];
    [_dataDict setValue:@"业绩查询" forKey:_dataKeyArray[4]];
    [_dataDict setValue:@"积分明细查询" forKey:_dataKeyArray[5]];
    
    _scrollImgArray = @[@"head-bg.png",@"head-bg.png",@"head-bg.png"];

}
- (IBAction)my:(id)sender {
    [self performSegueWithIdentifier:@"my" sender:self];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(0, 0, KWidth, KHeight - 64);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [HelperUtil
                                                            colorWithHexString:@"1FAAF2"];
    //隐藏导航栏黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.tabBarController.title = @"云客服";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)signAction:(UIButton *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"5e98d681531cd8e201531cd8ec590000" forKey:@"userId"];
    [dict setValue:[Utility location] forKey:@"address"];
    NSLog(@"%@",[[SingleHandle shareSingleHandle] getUserInfo].sign);
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kSignedAPI] params:dict successBlock:^(id returnData) {
            if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
                [sender setBackgroundImage:[UIImage imageNamed:@"home-icon7_"] forState:(UIControlStateNormal)];
                [sender setTitle:@"已签到" forState:(UIControlStateNormal)];
                sender.enabled = NO;
                
            }
    } failureBlock:^(NSError *error) {
            
    } showHUD:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataKeyArray.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomeHeaderView *headerView = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView_ID forIndexPath:indexPath];
        if ([[[SingleHandle shareSingleHandle] getUserInfo].sign isEqualToString:@"0"]) {
            [headerView.sginBtn setBackgroundImage:[UIImage imageNamed:@"home-icon7_"] forState:(UIControlStateNormal)];
            [headerView.sginBtn setTitle:@"已签到" forState:(UIControlStateNormal)];
            headerView.sginBtn.enabled = NO;
        }
        headerView.headImg.userInteractionEnabled = YES;
        [headerView.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderAction)]];
        [headerView.sginBtn addTarget:self action:@selector(signAction:) forControlEvents:(UIControlEventTouchUpInside)];
        headerView.integralLabel.text = _integral;
        User *user = [[SingleHandle shareSingleHandle] getUserInfo];
        [headerView setDataWithDictionary:@{@"userName":user.userName}];
        // 轮播图开始轮播
        [headerView playWithImageArray:_scrollImgArray clickAtIndex:^(NSInteger index) {
            
        }];
        return headerView;
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
            [self performSegueWithIdentifier:@"myClient" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"creatOrder" sender:self];
            break;
        case 3:
        {
            IntergralCityViewController *intergCityVC = [[IntergralCityViewController alloc] init];
            [self.navigationController pushViewController:intergCityVC animated:YES];
        }
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
 *  获取我的积分
 */

- (void)getMyintegralData {
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    __weak typeof(self) weakSelf = self;
    NSLog(@"%@",user.userId);
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetuserIntergralAPI] params:@{@"userId":user.userId} successBlock:^(id returnData) {
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            NSString *str = [returnData[@"data"] valueForKey:@"totalNum"];
            _integral = [NSString stringWithFormat:@"%@",str];
            [weakSelf.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
}

/** 获取数据*/
- (void)getData {
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000"};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kapplyCustomerData];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            ClientData *clientData = [ClientData mj_objectWithKeyValues:dataDic];
            [self performSegueWithIdentifier:@"getData" sender:self];
            
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            
        }
        

    } failureBlock:^(NSError *error) {

    } showHUD:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
//    if ([segue.identifier isEqualToString:@"SendValue"]) {
//        // segue.destinationViewController：获取连线时所指的界面（VC）
//        ReceiveViewController *receive = segue.destinationViewController;
//        receive.name = @"Garvey";
//        receive.age = 110;
//        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
//        //		[self.navigationController pushViewController:receive animated:YES];
//    }
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
