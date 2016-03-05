//
//  IntegralViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralTableViewCell.h"
#import <MJRefresh.h>
#import "Integral.h"

@interface IntegralViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _page;//当前页数
    int _pageSize;//每页加载数
    NSMutableArray *_integralArray;
}
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [weakSelf setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"title-search" selectImage:@"title-search_" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"intergralSearch" sender:weakSelf];
    }];
    [self addMjRefresh];
    // Do any additional setup after loading the view.
}
- (void)addMjRefresh {
    _page=1;
    _pageSize=7;
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreData];
        
    }];
}
- (void)requestData {
    _integralArray = nil;
    _integralArray = [NSMutableArray array];
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindUserCreditsRecord];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_integralArray addObjectsFromArray:[Integral mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_integralArray);
        }else {
        [MBProgressHUD showError:[dic objectForKey:@"msg"] toView:self.view];

        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    } showHUD:YES];

}

- (void)requestMoreData {
    _page++;
    
    NSDictionary *paramsDic=@{@"userId":@"5e98d681531cd8e201531cd8ec590000",@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindUserCreditsRecord];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_integralArray addObjectsFromArray:[Integral mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_integralArray);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    } showHUD:YES];

}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    IntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"IntegralTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
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
