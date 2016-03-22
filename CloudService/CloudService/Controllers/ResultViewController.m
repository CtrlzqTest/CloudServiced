//
//  ResultViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultTableViewCell.h"
#import "PersonResultCell.h"
#import <LazyPageScrollView.h>
#import <MJRefresh.h>
#import "SingleHandle.h"
#import "Achievement.h"

@interface ResultViewController ()<LazyPageScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *_dayArray;//当日业绩列表
    NSMutableArray *_weekArray;//本周业绩列表
    NSMutableArray *_monthArray;//本月业绩列表
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
    NSArray *_userAchievementArray;//个人业绩
    UIImageView *_noDataImg;
    UILabel *_lbNoData;
}
@property (strong, nonatomic) LazyPageScrollView *pageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dayArray = [NSMutableArray array];
    _weekArray = [NSMutableArray array];
    _monthArray = [NSMutableArray array];
    
    [self setupNoData];
    if ([[[SingleHandle shareSingleHandle] getUserInfo].roleName isEqualToString:@"团队长"]) {
            [self initPageView];
    }else{
         [self initTableView];
    }
   
   
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title = @"业绩查询";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
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
    _page3=1;
    _pageSize3=6;
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
        [self requestTeamAchievement:@"day"];
    }];
    // 上拉刷新
    _tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"day"];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView1.mj_header.automaticallyChangeAlpha = YES;
    [_tableView1.mj_header beginRefreshing];
    
    [_pageView addTab:@"本日业绩" View:_tableView1 Info:nil];
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
        [self requestTeamAchievement:@"week"];
    }];
    // 上拉刷新
    _tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"week"];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView2.mj_header.automaticallyChangeAlpha = YES;
    [_pageView addTab:@"本周业绩" View:_tableView2 Info:nil];
    
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
        [self requestTeamAchievement:@"month"];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView3.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreTeamAchievement:@"month"];
        
    }];
    [_pageView addTab:@"本月业绩" View:_tableView3 Info:nil];
    
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
        if (_dayArray.count == 0) {
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
        
    }
    if (index == 1) {
        
        if (!_isLoad2) {
            [_tableView2.mj_header beginRefreshing];
            _isLoad2 = YES;
        }
        if (_weekArray.count == 0) {
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
    }
    if (index == 2) {
        if (!_isLoad3) {
            [_tableView3.mj_header beginRefreshing];
            _isLoad3 = YES;
        }
        if (_monthArray.count == 0) {

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
    if ([tableView isEqual:_tableView]) {
        return _userAchievementArray.count;
    }if ([tableView isEqual:_tableView1]) {
        return _dayArray.count;
    }if ([tableView isEqual:_tableView2]) {
        return _weekArray.count;
    }else {
        return _monthArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    if (tableView.tag == 103) {
        PersonResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonResultCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Achievement *achievement = [_userAchievementArray objectAtIndex:indexPath.row];
        cell.lbOrderNum.text = [NSString stringWithFormat:@"%i",achievement.orderNum];
        cell.lbTotalPremium.text = [NSString stringWithFormat:@"%.2f",achievement.totalPremium];
        [cell.resultTime setTitle:achievement.resultTime forState:UIControlStateNormal];
        
        return cell;
    }else{
        ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Achievement *achievement;
        if ([tableView isEqual:_tableView1]) {
             achievement= [_dayArray objectAtIndex:indexPath.row];
        }else if ([tableView isEqual:_tableView2]) {
            achievement = [_weekArray objectAtIndex:indexPath.row];
        }else if ([tableView isEqual:_tableView3]){
            achievement = [_monthArray objectAtIndex:indexPath.row];
        }
        cell.lbOrderNum.text = [NSString stringWithFormat:@"%i",achievement.orderNum];
        cell.lbTotalPremium.text = [NSString stringWithFormat:@"%.2f",achievement.totalPremium];
        cell.lbIdCard.text = achievement.userNum;
        cell.lbName.text = achievement.realName;

        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 103) {
        return 145;
    }else {
        return 103;
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
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
        _tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag = 103;
        // 下拉刷新
        _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestUserAchievement];

        }];
        [_tableView.mj_header beginRefreshing];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        
       
    }
    return _tableView;
}
//获取个人业绩
- (void)requestUserAchievement {
    [self removeNoData];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindUserAchievement];
    NSDictionary *params = @{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId};
    [MHNetworkManager postReqeustWithURL:url params:params successBlock:^(id returnData) {
        
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            
            
            
            NSDictionary *dataDic = [returnData objectForKey:@"data"];
            NSDictionary *dayDic = [dataDic objectForKey:@"day"];
            Achievement *dayAchievement = [[Achievement alloc] init];
            dayAchievement.orderNum = [[dayDic objectForKey:@"orderNum"] intValue];
            dayAchievement.totalPremium = [[dayDic objectForKey:@"totalPremium"] floatValue];
            dayAchievement.resultTime = @"本日业绩";
            
            NSDictionary *monthDic = [dataDic objectForKey:@"month"];
            Achievement *monthAchievement = [[Achievement alloc] init];
            monthAchievement.orderNum = [[monthDic objectForKey:@"orderNum"] intValue];
            monthAchievement.totalPremium = [[monthDic objectForKey:@"totalPremium"] floatValue];
            monthAchievement.resultTime = @"本周业绩";
            
            NSDictionary *weekDic = [dataDic objectForKey:@"week"];
            Achievement *weekAchievement = [[Achievement alloc] init];
            weekAchievement.orderNum = [[weekDic objectForKey:@"orderNum"] intValue];
            weekAchievement.totalPremium = [[weekDic objectForKey:@"totalPremium"] floatValue];
            weekAchievement.resultTime = @"本月业绩";
            
            _userAchievementArray = @[dayAchievement,monthAchievement,weekAchievement];
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            
        }else {
            [_tableView.mj_header endRefreshing];
            [MBProgressHUD showMessag:[returnData objectForKey:@"msg"] toView:self.view];
            [self.tableView addSubview:_noDataImg];
            [self.tableView addSubview:_lbNoData];
        }
        
    } failureBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [self.tableView addSubview:_noDataImg];
        [self.tableView addSubview:_lbNoData];
        
    } showHUD:NO];
}

#pragma mark 加载团队业绩
- (void)requestTeamAchievement:(NSString *)type {
    NSDictionary *paramsDic;
    if ([type isEqualToString:@"day"]) {
     
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page1],
                    @"type":type};
    }if ([type isEqualToString:@"week"]) {
    
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@
                    "pageNo":[NSString stringWithFormat:@"%i",_page2],
                    @"type":type};
    }if ([type isEqualToString:@"month"]) {
     
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize3],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page3],
                    @"type":type};
    }
    
    [self removeNoData];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindTeamAchievement];
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
            if ([type isEqualToString:@"day"]) {
                [_dayArray removeAllObjects];
                if (totalCount-_pageSize1*_page1<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView1.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_dayArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"week"]) {
                [_weekArray removeAllObjects];
                if (totalCount-_pageSize2*_page2<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView2.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_weekArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"month"]) {
                [_monthArray removeAllObjects];
                if (totalCount-_pageSize3*_page3<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView3.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_monthArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }
            
        }else {
            [MBProgressHUD showMessag:[dic objectForKey:@"msg"] toView:self.view];
            [self.pageView addSubview:_noDataImg];
            [self.pageView addSubview:_lbNoData];
        }
        if ([type isEqualToString:@"day"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_header endRefreshing];
      
        }if ([type isEqualToString:@"week"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_header endRefreshing];
        
        }if ([type isEqualToString:@"month"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_header endRefreshing];
          
        }
        
       
    } failureBlock:^(NSError *error) {
        [self.pageView addSubview:_noDataImg];
        [self.pageView addSubview:_lbNoData];
   
        if ([type isEqualToString:@"day"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_header endRefreshing];
        }if ([type isEqualToString:@"week"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_header endRefreshing];
        }if ([type isEqualToString:@"month"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_header endRefreshing];
        }
    } showHUD:YES];
}
- (void)requestMoreTeamAchievement:(NSString *)type {
    NSDictionary *paramsDic;
    if ([type isEqualToString:@"day"]) {
         _page1++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page1],
                    @"type":type};
    }if ([type isEqualToString:@"week"]) {
        _page2++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page2],
                    @"type":type};
    }if ([type isEqualToString:@"month"]) {
        _page3++;
        paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                    @"pageSize":[NSString stringWithFormat:@"%i",_pageSize3],
                    @"pageNo":[NSString stringWithFormat:@"%i",_page3],
                    @"type":type};
    }
    
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindTeamAchievement];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            NSLog(@"总条数：%i",totalCount);
            if ([type isEqualToString:@"day"]) {
                if (totalCount-_pageSize1*_page1<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView1.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_dayArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"week"]) {
                if (totalCount-_pageSize2*_page2<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView2.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_weekArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }if ([type isEqualToString:@"month"]) {
                if (totalCount-_pageSize3*_page3<=0) {
                    //没有数据，直接提示没有更多数据
                    [_tableView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //有数据，则结束刷新状态，以便下次能够刷新
                    [_tableView3.mj_footer endRefreshing];
                }
                NSArray *listArray = [dataDic objectForKey:@"list"];
                [_monthArray addObjectsFromArray:[Achievement mj_objectArrayWithKeyValuesArray:listArray]];
            }

        }else {
            [MBProgressHUD showMessag:[dic objectForKey:@"msg"] toView:self.view];
        }
        if ([type isEqualToString:@"day"]) {
            [_tableView1 reloadData];
        }if ([type isEqualToString:@"week"]) {
            [_tableView2 reloadData];
        
        }if ([type isEqualToString:@"month"]) {
            [_tableView3 reloadData];
         
        }

    } failureBlock:^(NSError *error) {
        if ([type isEqualToString:@"day"]) {
            [_tableView1 reloadData];
            [_tableView1.mj_footer endRefreshing];
        }if ([type isEqualToString:@"week"]) {
            [_tableView2 reloadData];
            [_tableView2.mj_footer endRefreshing];
        }if ([type isEqualToString:@"month"]) {
            [_tableView3 reloadData];
            [_tableView3.mj_footer endRefreshing];
        }
    } showHUD:YES];
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
