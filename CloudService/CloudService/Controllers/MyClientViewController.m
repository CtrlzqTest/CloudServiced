//
//  MyClientViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/29.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MyClientViewController.h"
#import "MyClientTableViewCell.h"
#import <MJRefresh.h>
#import "Order.h"
#import "OfferViewController.h"
#import "OrderInfoViewController.h"

@interface MyClientViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    int _page;//当前页数
    int _pageSize;//每页加载数
    NSMutableArray *_clientArray;
    NSString *_conditon;//模糊搜索
    Order *_order;
}
@property (weak, nonatomic)IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@end

@implementation MyClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //客户数组
    _clientArray = [NSMutableArray array];
    //模糊搜索
    _conditon = @"";
    //滑动tableview隐藏键盘
    self.tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.tableFooterView = [UIView new];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self addMjRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"我的客户";
    __weak typeof(self) weakSelf = self;
    [weakSelf setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"head-add" selectImage:@"head-add" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"creatClient" sender:weakSelf];
    }];
    if (self.isSaveCarInfo) {
        _conditon = @"";
        [self.tableView.mj_header beginRefreshing];
    }
}
//添加mj
- (void)addMjRefresh {
    _page=1;
    _pageSize=7;
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestData:_conditon];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreData:_conditon];
        
    }];
}

- (void)requestData:(NSString *)condition{

    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page],@"condition":condition};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindPersonCustList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *dic = returnData;
         NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            [_clientArray removeAllObjects];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
    
            if (totalCount-_pageSize*_page<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
           
            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_clientArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_clientArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    } showHUD:YES];
    
}

- (void)requestMoreData:(NSString *)condition{
    _page++;
    
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page],@"condition":condition};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindPersonCustList];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
            if (totalCount-_pageSize*_page<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                //有数据，则结束刷新状态，以便下次能够刷新
                [_tableView.mj_footer endRefreshing];
            }
            
            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_clientArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_clientArray);
        }else {
            [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];
            
        }

        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    } showHUD:YES];
    
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _clientArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    MyClientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyClientTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    Order *order = [_clientArray objectAtIndex:indexPath.row];
    cell.lbCustName.text = order.customerName;
    cell.lbLicenseNo.text = order.licenseNo;
    cell.lbInfo.layer.borderColor = [[HelperUtil colorWithHexString:@"FDB164"]CGColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _order = [_clientArray objectAtIndex:indexPath.row];
    if ([_order.baseId isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"offerInfo" sender:self];
    }else{
        [self performSegueWithIdentifier:@"clientOrder" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"offerInfo"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        OfferViewController *receive = segue.destinationViewController;
        receive.order = _order;
    }
    if ([segue.identifier isEqualToString:@"clientOrder"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        OrderInfoViewController *receive = segue.destinationViewController;
        receive.order = _order;
    }
}
#pragma mark searchBar
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    
    _conditon = searchBar.text;
    [self.tableView.mj_header beginRefreshing];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _conditon = searchBar.text;
    [self.tableView.mj_header beginRefreshing];
    [searchBar resignFirstResponder];
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
