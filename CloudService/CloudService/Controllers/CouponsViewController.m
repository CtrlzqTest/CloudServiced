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
#import <MJExtension.h>
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
}
@property (strong, nonatomic) IBOutlet LazyPageScrollView *pageView;
@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self initPageView];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark pageView
- (void)initPageView {
    _page1=1;
    _pageSize1=6;
    _page2=1;
    _pageSize2=6;
    
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
#pragma mark 加载个人优惠券
- (void)requestPersonalData {
    _userArray = nil;
    _userArray = [NSMutableArray array];
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],@"pageNo":[NSString stringWithFormat:@"%i",_page1]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kUserCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_userArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_userArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
        }
        
        [_tableView1 reloadData];
        [_tableView1.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView1.mj_header endRefreshing];
    } showHUD:YES];
}
- (void)requestMorePersonalData {
    _page1++;

    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize1],@"pageNo":[NSString stringWithFormat:@"%i",_page1]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kUserCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_userArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_userArray);
        [_tableView1 reloadData];
        [_tableView1.mj_footer endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView1.mj_footer endRefreshing];
    } showHUD:YES];
}
#pragma mark 加载团队优惠券
- (void)requestGroupData {
    _teamArray = nil;
    _teamArray = [NSMutableArray array];
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@"pageNo":[NSString stringWithFormat:@"%i",_page2]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kTeamCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_teamArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_teamArray);
        [_tableView2 reloadData];
        [_tableView2.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView2.mj_header endRefreshing];
    } showHUD:YES];
}
- (void)requestMoreGroupData {
    _page2++;
    
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize2],@"pageNo":[NSString stringWithFormat:@"%i",_page2]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kTeamCouponsList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_teamArray addObjectsFromArray:[Coupons mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_teamArray);
        [_tableView2 reloadData];
        [_tableView2.mj_footer endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView2.mj_footer endRefreshing];
    } showHUD:YES];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableView1]) {
        return _userArray.count;
    }else {
        return _teamArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CouponsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([tableView isEqual:_tableView1]) {
        Coupons *coupons = [_userArray objectAtIndex:indexPath.row];
        cell.lbCouponNum.text = [NSString stringWithFormat:@"%i",coupons.couponNum];
        cell.lbEndTime.text = [self timeFormat:coupons.endTime];
    }else{
        Coupons *coupons = [_teamArray objectAtIndex:indexPath.row];
        cell.lbCouponNum.text = [NSString stringWithFormat:@"%i",coupons.couponNum];
        cell.lbEndTime.text = [self timeFormat:coupons.endTime];
    }
    
  
    return cell;
}
- (NSString *)timeFormat:(NSString *)date
{

    
    NSTimeInterval time=([date doubleValue]+28800)/1000;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
