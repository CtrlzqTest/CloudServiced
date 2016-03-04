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

@interface ResultViewController ()<LazyPageScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) LazyPageScrollView *pageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initPageView];
    [self initTableView];
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

#pragma mark pageView
- (void)initPageView {
    [self.view addSubview:self.pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:38 TabHeight:38 VerticalDistance:0 BkColor:[UIColor whiteColor]];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tag = 100;
    tableView.delegate = self;
    tableView.dataSource = self;
    [_pageView addTab:@"当日业绩" View:tableView Info:nil];
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tag = 101;
    tableView.delegate = self;
    tableView.dataSource = self;
    [_pageView addTab:@"本周业绩" View:tableView Info:nil];
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tag = 102;
    tableView.delegate = self;
    tableView.dataSource = self;
    [_pageView addTab:@"本月业绩" View:tableView Info:nil];
    
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
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    if (tableView.tag == 103) {
        PersonResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonResultCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 103) {
        return 145;
    }else {
        return 81;
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
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag = 103;
    }
    return _tableView;
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
