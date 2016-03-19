//
//  CouponsViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponsTableViewCell.h"
#import <LazyPageScrollView.h>
#import <MJRefresh.h>
#import "Coupons.h"
#import "CouponsDistributeViewController.h"
@interface CouponsViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int _page1;//当前页数
    int _pageSize1;//每页加载数
    int _page2;//当前页数
    int _pageSize2;//每页加载数
    NSMutableArray *_userArray;//我的优惠券列表
    NSMutableArray *_teamArray;//团队优惠券列表
    UITableView *_tableView1;
    UITableView *_tableView2;
    BOOL _isLoad;//是否已加载
    NSIndexPath *_teamIndexPath;//点击哪行优惠券
    UIImageView *_noDataImg;
    UILabel *_lbNoData;
}
@property (strong, nonatomic) LazyPageScrollView *pageView;

@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userArray = [NSMutableArray array];
    _teamArray = [NSMutableArray array];
    [self setupNoData];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [weakSelf setRightTextBarButtonItemWithFrame:CGRectMake(0, 0, 80, 30) title:@"使用规则" titleColor:[UIColor whiteColor] backImage:@"" selectBackImage:@"" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"couponsRule" sender:weakSelf];
        
    }];
    if ([[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"团队长"]) {
        [self initPageView];
    }else{
        [self initTableView];
    }
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)initTableView {
    [self.view addSubview:self.tableView];
}

- (void)setupNoData {
    _noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-30, KHeight/2-80, 75, 85)];
    _noDataImg.image = [UIImage imageNamed:@"pix2"];
    _lbNoData = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-20, KHeight/2+10, 60, 25)];
    _lbNoData.text = @"暂无数据";
    _lbNoData.font = [UIFont systemFontOfSize:14];
    _lbNoData.textColor = [UIColor lightGrayColor];
}
- (void)removeNoData {
    [_noDataImg removeFromSuperview];
    [_lbNoData removeFromSuperview];
}

#pragma mark pageView
- (void)initPageView {
    _page1=1;
    _pageSize1=6;
    _page2=1;
    _pageSize2=6;
    [self.view addSubview:self.pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:38 TabHeight:38 VerticalDistance:0 BkColor:[UIColor whiteColor]];
    _tableView1 = [[UITableView alloc] init];
    _tableView1.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 下拉刷新
    _tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page1 = 1;
        [self requestPersonalData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView1.mj_header.automaticallyChangeAlpha = YES;
        [_tableView1.mj_header beginRefreshing];
    
    // 上拉刷新
    _tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMorePersonalData];
        
    }];
    
    _tableView1.tag = 100;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    [_pageView addTab:@"个人优惠券" View:_tableView1 Info:nil];
    _tableView2 = [[UITableView alloc] init];
    _tableView2.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 下拉刷新
    _tableView2.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page2 = 1;
        [self requestGroupData];
        

    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView2.mj_header.automaticallyChangeAlpha = YES;
  
    
    
    // 上拉刷新
    _tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreGroupData];
        
    }];
    _tableView2.tag = 101;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    [_pageView addTab:@"团队优惠券" View:_tableView2 Info:nil];

    
    [_pageView enableTabBottomLine:YES LineHeight:2 LineColor:[HelperUtil colorWithHexString:@"277FD9"] LineBottomGap:0 ExtraWidth:60];
    //    [_pageView enableBreakLine:YES Width:2 TopMargin:0 BottomMargin:0 Color:[UIColor lightGrayColor]];
    [_pageView setTitleStyle:[UIFont systemFontOfSize:14] SelFont:[UIFont systemFontOfSize:16] Color:[UIColor blackColor] SelColor:[HelperUtil colorWithHexString:@"277FD9"]];
    [_pageView generate:^(UIButton *firstTitleControl, UIView *viewTitleEffect) {
        CGRect frame= firstTitleControl.frame;
        frame.size.height-=5;
        frame.size.width-=6;
        viewTitleEffect.frame=frame;
        viewTitleEffect.center=firstTitleControl.center;
    }];
}

- (void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex TitleEffectView:(UIView *)viewTitleEffect SelControl:(UIButton *)selBtn {
    if (index == 1) {
    
        if (!_isLoad) {
            [_tableView2.mj_header beginRefreshing];
            _isLoad = YES;
        }
    }
    NSLog(@"之前下标：%ld 当前下标：%ld",preIndex,index);
}

-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        NSLog(@"left");
      
    }
    else
    {
        NSLog(@"right");
    }
}

//懒加载
- (LazyPageScrollView *)pageView {
    if (!_pageView) {
        _pageView = [[LazyPageScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
        
    }
    return _pageView;
}
- (UITableView *)tableView {
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
        _tableView1.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
        _tableView1.showsHorizontalScrollIndicator = NO;
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.tag = 103;
        // 下拉刷新
        _tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestPersonalData];
            
        }];
        [_tableView1.mj_header beginRefreshing];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _tableView1.mj_header.automaticallyChangeAlpha = YES;
        
        
    }
    return _tableView1;
}

#pragma mark 加载个人优惠券
- (void)requestPersonalData {
    [self removeNoData];
  
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],@"pageNo":[NSString stringWithFormat:@"%i",_page1]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kUserCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            [_userArray removeAllObjects];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            //如果有数据显示数据，如果没有数据则显示暂无数据
            if (totalCount>0) {
                [self removeNoData];
            }else{
                [_tableView1 addSubview:_noDataImg];
                [_tableView1 addSubview:_lbNoData];
            }

            if (totalCount-_pageSize1*_page1<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView1.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView1.mj_footer endRefreshing];
            }

            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_userArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_userArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            [_tableView1 addSubview:_noDataImg];
            [_tableView1 addSubview:_lbNoData];
        }
        
        [_tableView1 reloadData];
        [_tableView1.mj_header endRefreshing];
   
    } failureBlock:^(NSError *error) {
        [_tableView1 addSubview:_noDataImg];
        [_tableView1 addSubview:_lbNoData];
        [_tableView1.mj_header endRefreshing];
    } showHUD:YES];
}
//加载更多个人优惠券数据
- (void)requestMorePersonalData {
    _page1++;

    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],@"pageNo":[NSString stringWithFormat:@"%i",_page1]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kUserCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            if (totalCount-_pageSize1*_page1<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView1.mj_footer endRefreshingWithNoMoreData];
            }else{
                //有数据，则结束刷新状态，以便下次能够刷新
                [_tableView1.mj_footer endRefreshing];
            }

        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_userArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_userArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
        }
        [_tableView1 reloadData];
 
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView1.mj_footer endRefreshing];
    } showHUD:YES];
}
#pragma mark 加载团队优惠券
- (void)requestGroupData {
    [self removeNoData];

    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@"pageNo":[NSString stringWithFormat:@"%i",_page2]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kTeamCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            [_teamArray removeAllObjects];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            //如果有数据显示数据，如果没有数据则显示暂无数据
            if (totalCount>0) {
                [self removeNoData];
            }else{
                [_tableView2 addSubview:_noDataImg];
                [_tableView2 addSubview:_lbNoData];
            }
            
            
            if (totalCount-_pageSize2*_page2<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView2.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView2.mj_footer endRefreshing];
            }

        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_teamArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            
            [_tableView2 addSubview:_noDataImg];
            [_tableView2 addSubview:_lbNoData];
        }
        [_tableView2 reloadData];
        [_tableView2.mj_header endRefreshing];

    } failureBlock:^(NSError *error) {
        [_tableView2 addSubview:_noDataImg];
        [_tableView2 addSubview:_lbNoData];
        [_tableView2.mj_header endRefreshing];
    } showHUD:YES];
}
//加载更多团队优惠券数据
- (void)requestMoreGroupData {
    _page2++;
    
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@"pageNo":[NSString stringWithFormat:@"%i",_page2]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kTeamCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            if (totalCount-_pageSize2*_page2<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView2.mj_footer endRefreshingWithNoMoreData];
            }else{
                //有数据，则结束刷新状态，以便下次能够刷新
                [_tableView2.mj_footer endRefreshing];
            }

        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_teamArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_teamArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
        }
        [_tableView2 reloadData];

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView2.mj_footer endRefreshing];
    } showHUD:YES];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableView2]) {
        return _teamArray.count;
    }else {
        return _userArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CouponsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    if ([tableView isEqual:_tableView2]) {
        Coupons *coupons = [_teamArray objectAtIndex:indexPath.row];
        cell.lbCouponNum.text = [NSString stringWithFormat:@"%i",coupons.amount];
        cell.lbEndTime.text = [NSString stringWithFormat:@"有效期至%@",[HelperUtil timeFormat:coupons.endTime format:@"yyyy-MM-dd"]];
        
     
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Coupons *coupons = [_userArray objectAtIndex:indexPath.row];
        cell.lbCouponNum.text = [NSString stringWithFormat:@"%i",coupons.couponNum];
        cell.lbEndTime.text = [NSString stringWithFormat:@"有效期至%@",[HelperUtil timeFormat:coupons.endTime format:@"yyyy-MM-dd"]];
    }
    
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_tableView2]) {
        _teamIndexPath = indexPath;
        [self performSegueWithIdentifier:@"distribute" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"distribute"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        CouponsDistributeViewController *receive = segue.destinationViewController;
        receive.coupons = [_teamArray objectAtIndex:_teamIndexPath.row];
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
