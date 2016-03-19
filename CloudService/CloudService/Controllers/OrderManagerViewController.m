//
//  OrderManagerViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "OrderManagerViewController.h"
#import "OrderManagerCell.h"
#import <MJRefresh.h>
#import "Order.h"
#import "OrderInfoViewController.h"

@interface OrderManagerViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_unfinishedArray;//未完成列表
    NSMutableArray *_waitPayArray;//待支付列表
    NSMutableArray *_alreadyPayArray;//已支付列表
    int _page1;//当前页数
    int _pageSize1;//每页加载数
    int _page2;//当前页数
    int _pageSize2;//每页加载数
    int _page3;//当前页数
    int _pageSize3;//每页加载数
    UITableView *_tableView1;
    UITableView *_tableView2;
    UITableView *_tableView3;
    BOOL _isLoad2;//是否已加载
    BOOL _isLoad3;//是否已加载
    UIImageView *_noDataImg;
    UILabel *_lbNoData;
    Order *_order;
}
@end

@implementation OrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _unfinishedArray = [NSMutableArray array];
    _waitPayArray = [NSMutableArray array];
    _alreadyPayArray = [NSMutableArray array];
    [self initPageView];
    [self setupNoData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"订单管理";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.frame = CGRectMake(0, 0, KWidth, KHeight - 64);
    __weak typeof(self) weakSelf = self;
    [self.tabBarController setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"title-search" selectImage:@"title-search_" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"searchOrder" sender:weakSelf];
    }];

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
    _pageSize1=4;
    _page2=1;
    _pageSize2=4;
    _page3=1;
    _pageSize3=4;
    [self.view addSubview:self.pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:38 TabHeight:38 VerticalDistance:0 BkColor:[UIColor whiteColor]];
    _tableView1 = [[UITableView alloc] init];
    _tableView1.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    _tableView1.showsHorizontalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView1.tag = 100;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    // 下拉刷新
    _tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page1 = 1;
        [self requestTeamAchievement:@"未完成"];
    }];
    // 上拉刷新
    _tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"未完成"];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView1.mj_header.automaticallyChangeAlpha = YES;
    [_tableView1.mj_header beginRefreshing];
    
    [_pageView addTab:@"未完成" View:_tableView1 Info:nil];
    _tableView2 = [[UITableView alloc] init];
    _tableView2.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    _tableView2.showsHorizontalScrollIndicator = NO;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.tag = 101;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    // 下拉刷新
    _tableView2.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page2 = 1;
        [self requestTeamAchievement:@"待支付"];
    }];
    // 上拉刷新
    _tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"待支付"];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView2.mj_header.automaticallyChangeAlpha = YES;
    [_pageView addTab:@"待支付" View:_tableView2 Info:nil];
    
    _tableView3 = [[UITableView alloc] init];
    _tableView3.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    _tableView3.showsHorizontalScrollIndicator = NO;
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView3.tag = 102;
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    // 下拉刷新
    _tableView3.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page3 = 1;
        [self requestTeamAchievement:@"已支付"];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView3.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"已支付"];
        
    }];
    [_pageView addTab:@"已支付" View:_tableView3 Info:nil];
    
    [_pageView enableTabBottomLine:YES LineHeight:2 LineColor:[HelperUtil colorWithHexString:@"277FD9"] LineBottomGap:0 ExtraWidth:50];
    [_pageView setTitleStyle:[UIFont systemFontOfSize:14] SelFont:[UIFont systemFontOfSize:16] Color:[UIColor blackColor] SelColor:[HelperUtil colorWithHexString:@"277FD9"]];    [_pageView generate:^(UIButton *firstTitleControl, UIView *viewTitleEffect) {
        CGRect frame= firstTitleControl.frame;
        frame.size.height-=5;
        frame.size.width-=6;
        viewTitleEffect.frame=frame;
        viewTitleEffect.center=firstTitleControl.center;
    }];
}

- (void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex TitleEffectView:(UIView *)viewTitleEffect SelControl:(UIButton *)selBtn {
    [self removeNoData];
    if (index == 0) {
        if (_unfinishedArray.count == 0) {
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
    }
    if (index == 1) {
        
        if (!_isLoad2) {
            [_tableView2.mj_header beginRefreshing];
            _isLoad2 = YES;
        }
        if (_waitPayArray.count == 0) {
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
    }
    if (index == 2) {
        if (!_isLoad3) {
            [_tableView3.mj_header beginRefreshing];
            _isLoad3 = YES;
        }
        if (_alreadyPayArray.count == 0) {
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
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
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableView1]) {
        return _unfinishedArray.count;
    }if ([tableView isEqual:_tableView2]) {
        return _waitPayArray.count;
    }else {
        return _alreadyPayArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    OrderManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderManagerCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    Order *order;
    if ([tableView isEqual:_tableView1]) {
        order= [_unfinishedArray objectAtIndex:indexPath.row];
    }else if ([tableView isEqual:_tableView2]) {
        order = [_waitPayArray objectAtIndex:indexPath.row];
    }else if ([tableView isEqual:_tableView3]){
        order = [_alreadyPayArray objectAtIndex:indexPath.row];
    }
    cell.lbLicenseNo.text = [NSString stringWithFormat:@"车牌号：%@",order.licenseNo];
    [cell.btnOrderStatus setTitle:order.orderStatus forState:UIControlStateNormal];
    cell.lbCustomerName.text = [NSString stringWithFormat:@"客户姓名：%@",order.customerName];
    cell.lbBiPremium.text = order.biPremium;
    cell.lbCiPremium.text = order.ciPremium;
    cell.lbVehicleTaxPremium.text = order.vehicleTaxPremium;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:_tableView1]) {
        _order= [_unfinishedArray objectAtIndex:indexPath.row];
    }else if ([tableView isEqual:_tableView2]) {
        _order = [_waitPayArray objectAtIndex:indexPath.row];
    }else if ([tableView isEqual:_tableView3]){
        _order = [_alreadyPayArray objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"orderInfo" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    
    if ([segue.identifier isEqualToString:@"orderInfo"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        OrderInfoViewController *receive = segue.destinationViewController;
        receive.order = _order;
        NSLog(@"%@",receive.order);
    }
}
#pragma mark 加载订单
- (void)requestTeamAchievement:(NSString *)type {
    NSDictionary *paramsDic;
    if ([type isEqualToString:@"未完成"]) {
        
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page1],
                    @"orderStatus":type};
    }if ([type isEqualToString:@"待支付"]) {

        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@
                    "pageNo":[NSString stringWithFormat:@"%i",_page2],
                    @"orderStatus":type};
    }if ([type isEqualToString:@"已支付"]) {
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize3],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page3],
                    @"orderStatus":type};
    }
    
    [self removeNoData];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindMainOrder];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            
            
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            //如果有数据显示数据，如果没有数据则显示暂无数据
            if (totalCount>0) {
                [self removeNoData];
            }else{
                [self.pageView addSubview:_noDataImg];
                [self.pageView addSubview:_lbNoData];
            }
            if ([type isEqualToString:@"未完成"]) {
                [_unfinishedArray removeAllObjects];
                if (totalCount-_pageSize1*_page1<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView1.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_unfinishedArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"待支付"]) {
                [_waitPayArray removeAllObjects];
                if (totalCount-_pageSize2*_page2<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView2.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_waitPayArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"已支付"]) {
                [_alreadyPayArray removeAllObjects];
                if (totalCount-_pageSize3*_page3<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView3.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_alreadyPayArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }
            
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
        if ([type isEqualToString:@"未完成"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_header endRefreshing];
      
        }if ([type isEqualToString:@"待支付"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_header endRefreshing];
     
        }if ([type isEqualToString:@"已支付"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_header endRefreshing];
    
        }
        
        
    } failureBlock:^(NSError *error) {
        [self.pageView addSubview:_noDataImg];
        [self.pageView addSubview:_lbNoData];
        
        if ([type isEqualToString:@"未完成"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_header endRefreshing];
        }if ([type isEqualToString:@"待支付"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_header endRefreshing];
        }if ([type isEqualToString:@"已支付"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_header endRefreshing];
        }
    } showHUD:YES];
}
- (void)requestMoreTeamAchievement:(NSString *)type {
    NSDictionary *paramsDic;
    if ([type isEqualToString:@"未完成"]) {
        _page1++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page1],
                    @"orderStatus":type};
    }if ([type isEqualToString:@"待支付"]) {
        _page2++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page2],
                    @"orderStatus":type};
    }if ([type isEqualToString:@"已支付"]) {
        _page3++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize3],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page3],
                    @"orderStatus":type};
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindMainOrder];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            if ([type isEqualToString:@"未完成"]) {
                if (totalCount-_pageSize1*_page1<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView1.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_unfinishedArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"待支付"]) {
                if (totalCount-_pageSize2*_page2<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView2.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_waitPayArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"已支付"]) {
                if (totalCount-_pageSize3*_page3<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView3.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_alreadyPayArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            }
            
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
        }
        if ([type isEqualToString:@"未完成"]) {
            [_tableView1 reloadData];
       
        }if ([type isEqualToString:@"待支付"]) {
            [_tableView2 reloadData];
     
        }if ([type isEqualToString:@"已支付"]) {
            [_tableView3 reloadData];
      
        }
        
    } failureBlock:^(NSError *error) {
        if ([type isEqualToString:@"未完成"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_footer endRefreshing];
        }if ([type isEqualToString:@"待支付"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_footer endRefreshing];
        }if ([type isEqualToString:@"已支付"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_footer endRefreshing];
        }
    } showHUD:YES];
}



//懒加载
- (LazyPageScrollView *)pageView {
    if (!_pageView) {
        _pageView = [[LazyPageScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
        
    }
    return _pageView;
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
