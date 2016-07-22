//
//  SearchOrderViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/24.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "HZQDatePickerView.h"
#import "PellTableViewSelect.h"
#import <MJRefresh.h>
#import "OrderManagerCell.h"
#import "Order.h"

@interface SearchOrderViewController ()<HZQDatePickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_searchView;//搜索菜单页面
    UIButton *_blackBtn;//背景层
    BOOL isOpen;//菜单是否展开
    UITextField *_tfName;//客户姓名
    UITextField *_tfTel;//客户手机号
    UITextField *_tfCar;//车牌号
    UILabel *_lbStart;//开始时间
    UILabel *_lbEnd;//结束时间
    HZQDatePickerView *_pickerView;//时间选择器
    UILabel *_lbCode;//结束码
    int _page;//当前页数
    int _pageSize;//每页加载数
    UIImageView *_noDataImg;
    UILabel *_lbNoData;
    NSMutableArray *_orderArray;
    NSString *_startTime;
    NSString *_endTime;
    NSString *_codeStr;
}
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@end

@implementation SearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _startTime = @"";
    _endTime = @"";
    _codeStr = @"";
    _orderArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.title=@"订单搜索";
    
    [weakSelf setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"title-search" selectImage:@"title-search_" action:^(AYCButton *button) {
        if (isOpen) {
            [weakSelf upMenu];
        }else {
            [weakSelf downMenu];
        }
        
    }];
    self.tableView.tableFooterView = [UIView new];
    [self addMjRefresh];
    //蒙版
    _blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _blackBtn.backgroundColor = [UIColor blackColor];
    _blackBtn.frame = self.view.frame;
    _blackBtn.alpha = 0.5f;
    [_blackBtn addTarget:self action:@selector(upMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_blackBtn];
    //加载搜索试图
    [self initSearchMenu];
    
    [self downMenu];
    // Do any additional setup after loading the view.
}



/** 搜索菜单*/
- (void)initSearchMenu {
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, -310, KWidth, 310)];
    _searchView.backgroundColor = [HelperUtil colorWithHexString:@"#F4F4F4"];
    [self.view addSubview:_searchView];
    
    UILabel *lbName = [UILabel new];
    lbName.textColor = [UIColor darkGrayColor];
    lbName.font = [UIFont systemFontOfSize:14];
    lbName.text = @"姓名";
    [_searchView addSubview:lbName];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(50, 34));
        //添加左边距约束
        make.left.mas_equalTo(20);
        //添加上边距约束
        make.top.mas_equalTo(15);
    }];
    
    _tfName = [UITextField new];
    _tfName.placeholder = @"请输入客户姓名";
    [_tfName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_tfName setFont:[UIFont systemFontOfSize:14]];
    _tfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfName.borderStyle = UITextBorderStyleRoundedRect;
    [_searchView addSubview:_tfName];
    [_tfName mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加左边距约束(距离左边label的距离)
        make.left.mas_equalTo(90);
        //添加右边距约束
        make.right.mas_equalTo(-20);
        //添加上边距约束
        make.top.mas_equalTo(15);
        
        
    }];
    
    UILabel *lbTel = [UILabel new];
    lbTel.textColor = [UIColor darkGrayColor];
    lbTel.font = [UIFont systemFontOfSize:14];
    lbTel.text = @"手机号";
    [_searchView addSubview:lbTel];
    
    [lbTel mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(50, 34));
        //添加左边距约束
        make.left.mas_equalTo(20);
        //添加上边距约束（上边距 = lbName的下边框 + 偏移量15）
        make.top.equalTo(lbName.mas_bottom).offset(15);
    }];
    
    _tfTel = [UITextField new];
    _tfTel.placeholder = @"请输入客户手机号";
    [_tfTel setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_tfTel setFont:[UIFont systemFontOfSize:14]];
    _tfTel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfTel.borderStyle = UITextBorderStyleRoundedRect;
    [_searchView addSubview:_tfTel];
    [_tfTel mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加左边距约束(距离左边label的距离)
        make.left.mas_equalTo(90);
        //添加右边距约束
        make.right.mas_equalTo(-20);
        //添加上边距约束
        make.top.equalTo(_tfName.mas_bottom).offset(15);
 
    }];
    
    UILabel *lbCar = [UILabel new];
    lbCar.textColor = [UIColor darkGrayColor];
    lbCar.font = [UIFont systemFontOfSize:14];
    lbCar.text = @"车牌号";
    [_searchView addSubview:lbCar];
    
    [lbCar mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(50, 34));
        //添加左边距约束
        make.left.mas_equalTo(20);
        //添加上边距约束（上边距 = lbName的下边框 + 偏移量15）
        make.top.equalTo(lbTel.mas_bottom).offset(15);
    }];
    
    _tfCar = [UITextField new];
    _tfCar.placeholder = @"请输入车牌号";
    [_tfCar setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_tfCar setFont:[UIFont systemFontOfSize:14]];
    _tfCar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfCar.borderStyle = UITextBorderStyleRoundedRect;
    [_searchView addSubview:_tfCar];
    [_tfCar mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加左边距约束(距离左边label的距离)
        make.left.mas_equalTo(90);
        //添加右边距约束
        make.right.mas_equalTo(-20);
        //添加上边距约束
        make.top.equalTo(_tfTel.mas_bottom).offset(15);
        
    }];
    
    UILabel *lbState = [UILabel new];
    lbState.textColor = [UIColor darkGrayColor];
    lbState.font = [UIFont systemFontOfSize:14];
    lbState.text = @"结束码";
    [_searchView addSubview:lbState];
    
    [lbState mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(50, 34));
        //添加左边距约束
        make.left.mas_equalTo(20);
        //添加上边距约束（上边距 = lbName的下边框 + 偏移量15）
        make.top.equalTo(lbCar.mas_bottom).offset(15);
    }];
    
    _lbCode = [UILabel new];
//    _lbCode.textAlignment = NSTextAlignmentCenter;
    _lbCode.textColor = [UIColor lightGrayColor];
    _lbCode.font = [UIFont systemFontOfSize:14];
    _lbCode.text = @"初始";
    _lbCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeClick:)];
    [_lbCode addGestureRecognizer:startTap];
    [_searchView addSubview:_lbCode];
    [_lbCode mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加左边距约束(距离左边label的距离)
        make.left.mas_equalTo(90);
        //添加右边距约束
        make.right.mas_equalTo(-20);
        //添加上边距约束
        make.top.equalTo(_tfCar.mas_bottom).offset(15);
        
    }];
    
    
    
    UILabel *lbTime = [UILabel new];
    lbTime.textColor = [UIColor darkGrayColor];
    lbTime.font = [UIFont systemFontOfSize:14];
    lbTime.text = @"起止时间";
    [_searchView addSubview:lbTime];
    
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(60, 34));
        //添加左边距约束
        make.left.mas_equalTo(20);
        //添加上边距约束（上边距 = lbName的下边框 + 偏移量15）
        make.top.equalTo(lbState.mas_bottom).offset(15);
    }];
    
    _lbStart = [UILabel new];
    _lbStart.textAlignment = NSTextAlignmentCenter;
    _lbStart.textColor = [UIColor lightGrayColor];
    _lbStart.font = [UIFont systemFontOfSize:14];
    _lbStart.text = @"起始时间";
    _lbStart.userInteractionEnabled = YES;
    UITapGestureRecognizer *codeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startDateClick:)];
    [_lbStart addGestureRecognizer:codeTap];
    [_searchView addSubview:_lbStart];
    
    _lbEnd = [UILabel new];
    _lbEnd.textAlignment = NSTextAlignmentCenter;
    _lbEnd.textColor = [UIColor lightGrayColor];
    _lbEnd.font = [UIFont systemFontOfSize:14];
    _lbEnd.text = @"终止时间";
    _lbEnd.userInteractionEnabled = YES;
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endDateClick:)];
    [_lbEnd addGestureRecognizer:endTap];
    [_searchView addSubview:_lbEnd];
    [_lbStart mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加上边距约束
        make.top.equalTo(_lbCode.mas_bottom).offset(15);
        // 添加左边距约束（距离当前主视图左边的距离）
        make.left.equalTo(lbTime.mas_right).offset(15);
        // 添加右边距约束（距离第二个按键左边的距离）
        make.right.equalTo(_lbEnd.mas_left).with.offset(-20);

        // 添加宽度（宽度跟右边按键一样）
        make.width.equalTo(_lbEnd);
    }];
    
    
    [_lbEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加高约束
        make.height.mas_equalTo(34);
        //添加上边距约束
        make.top.equalTo(_lbCode.mas_bottom).offset(15);
        // 添加左边距约束（距离左边按键的距离）
        make.left.equalTo(_lbStart.mas_right).with.offset(20);
        // 添加右边距约束（距离当前主视图右边的距离）
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        
        // 添加宽度（宽度跟右边按键一样）
        make.width.equalTo(_lbStart);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_searchView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加大小约束
        make.size.mas_equalTo(CGSizeMake(10, 1));
        //添加左边距约束
         make.left.equalTo(_lbStart.mas_right).with.offset(5);
        //添加上边距约束（上边距 = lbName的下边框 + 偏移量15）
        make.top.equalTo(lbState.mas_bottom).offset(31);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.layer.cornerRadius = 5.0f;
    btnCancel.layer.masksToBounds = YES;
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    btnCancel.backgroundColor = [UIColor lightGrayColor];
    [btnCancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:btnCancel];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.layer.cornerRadius = 5.0f;
    btnSearch.layer.masksToBounds = YES;
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:14];
    btnSearch.backgroundColor = [HelperUtil colorWithHexString:@"FF6271"];
    [btnSearch addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:btnSearch];
    
    // 给左边视图添加约束
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.equalTo(_lbStart.mas_bottom).offset(15);
        // 添加左边距约束（距离当前主视图左边的距离）
        make.left.equalTo(self.view.mas_left).with.offset(20);
        // 添加右边距约束（距离第二个按键左边的距离）
        make.right.equalTo(btnSearch.mas_left).with.offset(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(34);
        // 添加宽度（宽度跟右边按键一样）
        make.width.equalTo(btnSearch);
    }];
    
    // 给右边视图添加约束
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.equalTo(_lbEnd.mas_bottom).offset(15);
        // 添加左边距约束（距离左边按键的距离）
        make.left.equalTo(btnCancel.mas_right).with.offset(20);
        // 添加右边距约束（距离当前主视图右边的距离）
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(34);
        // 添加宽度（宽度跟左边按键一样）
        make.width.equalTo(btnCancel);
    }];
    

}

- (void)cancelClick:(UIButton *)sender {
    [self upMenu];
 
}

- (void)sureClick:(UIButton *)sender {
    [self upMenu];
    [self.tableView.mj_header beginRefreshing];
}
/** 结束码下拉*/
-  (void)codeClick:(UITapGestureRecognizer *)tap {
    [HelperUtil resignKeyBoardInView:self.view];
    NSArray *array = [[SingleHandle shareSingleHandle] getEndCodeArray];
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(80, 260, 200, 200) selectData:
     
     array
                                                        action:^(NSInteger index) {
                                                            _lbCode.textColor = [UIColor blackColor];
                                                            _lbCode.text = [array objectAtIndex:index];
                                                            _codeStr = [array objectAtIndex:index];
                                                        } animated:YES];

}

/** 下拉菜单*/
- (void)downMenu {
   isOpen = !isOpen;
    [UIView animateWithDuration:0.5 animations:^{
        _searchView.frame = CGRectMake(0, 0, KWidth, 310);
        _blackBtn.hidden = NO;
    }];
}
/** 收回菜单*/
- (void)upMenu {
    [HelperUtil resignKeyBoardInView:self.view];
    isOpen = !isOpen;
    [UIView animateWithDuration:0.5 animations:^{
        _searchView.frame = CGRectMake(0, -310, KWidth, 310);
        _blackBtn.hidden = YES;
    }];
}
// 开始时间
- (void)startDateClick:(UITapGestureRecognizer *)tap {
    [HelperUtil resignKeyBoardInView:self.view];
    [self setupDateView:DateTypeOfStart];
    
}

// 结束时间
- (void)endDateClick:(UITapGestureRecognizer *)tap {
    [HelperUtil resignKeyBoardInView:self.view];
    [self setupDateView:DateTypeOfEnd];
    
}
#pragma mark HZQDatePickerView
- (void)setupDateView:(DateType)type {
    
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, KWidth, KHeight + 20);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = type;
    [_pickerView.datePickerView setMinimumDate:[NSDate date]];
    [self.view addSubview:_pickerView];
    
}

- (void)getSelectDate:(NSDate *)date type:(DateType)type {
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];

    switch (type) {
        case DateTypeOfStart:
            _lbStart.textColor = [UIColor blackColor];
            _lbStart.text = currentOlderOneDateStr;
            _startTime = currentOlderOneDateStr;
            break;
            
        case DateTypeOfEnd:
            _lbEnd.textColor = [UIColor blackColor];
            _lbEnd.text = currentOlderOneDateStr;
            _endTime = currentOlderOneDateStr;
            break;
            
        default:
            break;
    }
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
    
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestMoreData];
        
    }];
}
- (void)requestData {
    [self removeNoData];
    
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                              @"pageSize":[NSString stringWithFormat:@"%i",_pageSize],
                              @"pageNo":[NSString stringWithFormat:@"%i",_page],
                              @"startDate":_startTime,
                              @"endData":_endTime,
                              @"custName":_tfName.text,
                              @"phoneNo":_tfTel.text,
                              @"licenseNo":_tfCar.text,
                              @"endCode":_codeStr};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindOrderByCondition];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *dic = returnData;
        if ([[dic objectForKey:@"flag"] isEqualToString:@"success"]) {
            [_orderArray removeAllObjects];
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
            [_orderArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
            NSLog(@"%@",_orderArray);
        }else {
            [MBProgressHUD showMessag:[dic objectForKey:@"msg"] toView:self.view];
            [self setupNoData];
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    
    } failureBlock:^(NSError *error) {
        [self setupNoData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } showHUD:YES];
    
}

- (void)requestMoreData {
    _page++;
    
    NSDictionary *paramsDic=@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId,
                              @"pageSize":[NSString stringWithFormat:@"%i",_pageSize],
                              @"pageNo":[NSString stringWithFormat:@"%i",_page],
                              @"startDate":_startTime,
                              @"endData":_endTime,@"custName":_tfName.text,
                              @"phoneNo":_tfTel.text,
                              @"licenseNo":_tfCar.text,
                              @"endCode":_codeStr};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindOrderByCondition];
    [MHNetworkManager postReqeustWithURL:url params:paramsDic successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
        NSDictionary *dic = returnData;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        //取出总条数
        int totalCount=[[[dataDic objectForKey:@"pageVO"] objectForKey:@"recordCount"] intValue];
        NSLog(@"总条数：%i",totalCount);
        if (totalCount-_pageSize*_page<=0) {
            //没有数据，直接提示没有更多数据
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            //有数据，则结束刷新状态，以便下次能够刷新
            [_tableView.mj_footer endRefreshing];
        }
        
        NSArray *listArray = [dataDic objectForKey:@"list"];
        [_orderArray addObjectsFromArray:[Order mj_objectArrayWithKeyValuesArray:listArray]];
        NSLog(@"%@",_orderArray);
        [self.tableView reloadData];

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    } showHUD:YES];
    
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    OrderManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderManagerCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    Order *order = [_orderArray objectAtIndex:indexPath.row];
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
    
}


-(void)dealloc {
    NSLog(@"搜索界面已销毁");
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
