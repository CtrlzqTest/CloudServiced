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
    NSMutableArray *_integralArray;//积分明细数组
    UIImageView *_noDataImg;
    UILabel *_lbNoData;
}

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _integralArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [weakSelf setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"title-search" selectImage:@"title-search_" action:^(AYCButton *button) {
        [weakSelf performSegueWithIdentifier:@"intergralSearch" sender:weakSelf];
    }];
    [self addMjRefresh];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)setupNoData {
    _noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-30, KHeight/2-80, 75, 85)];
    _noDataImg.image = [UIImage imageNamed:@"pix2"];
    _lbNoData = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-20, KHeight/2+10, 60, 25)];
    _lbNoData.text = @"暂无数据";
    _lbNoData.font = [UIFont systemFontOfSize:14];
    _lbNoData.textColor = [UIColor lightGrayColor];
    [self.tableView addSubview:_noDataImg];
    [self.tableView addSubview:_lbNoData];
}
- (void)removeNoData {
    [_noDataImg removeFromSuperview];
    [_lbNoData removeFromSuperview];
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
    [self removeNoData];

    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindUserCreditsRecord];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
           
            [_integralArray removeAllObjects];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //取出总条数
            int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
    
            if (totalCount>0) {
                [self removeNoData];
            }else {
                [self setupNoData];
            }
            if (totalCount-_pageSize*_page<=0) {
                //没有数据，直接提示没有更多数据
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }

            NSArray *listArray = [dataDic objectForKey:@"list"];
            [_integralArray addObjectsFromArray:[Integral mj_objectArrayWithKeyValuesArray:listArray]];
        }else {
        [MBProgressHUD showMessag:[dic objectForKey:@"msg"] toView:self.view];
            [self setupNoData];
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        [self setupNoData];
        [self.tableView.mj_header endRefreshing];
    } showHUD:YES];

}

- (void)requestMoreData {
    _page++;
    
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,@"pageSize":[NSString stringWithFormat:@"%i",_pageSize],@"pageNo":[NSString stringWithFormat:@"%i",_page]};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindUserCreditsRecord];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        
        NSDictionary *dic = returnData;
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
        [_integralArray addObjectsFromArray:[Integral mj_objectArrayWithKeyValuesArray:listArray]];
        [self.tableView reloadData];
     
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    } showHUD:YES];

}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _integralArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    IntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"IntegralTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    Integral *integral = [_integralArray objectAtIndex:indexPath.row];
    cell.lbComment.text = integral.comment;
    cell.lbTime.text = [HelperUtil timeFormat:integral.time format:@"yyyy-MM-dd HH:mm"];
    cell.lbReason.text = integral.reason;
    cell.lbCreditsNum.text = [NSString stringWithFormat:@"%i",integral.creditsNum];
    
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
