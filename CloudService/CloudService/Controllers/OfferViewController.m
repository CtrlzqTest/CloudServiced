//
//  OfferViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/29.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "OfferViewController.h"
#import "SetUserInfoHeaderView.h"
#import "OfferTableViewCell.h"
#import "MyClientViewController.h"
#import "AppDelegate.h"
#import "OrderH5ViewController.h"
#import "Order.h"

static NSString *const header_id = @"setUserInfoHeader";
static CGFloat headerHeight = 30;
@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *_footView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self initFootView];
    [self.tableView registerClass:[SetUserInfoHeaderView class] forHeaderFooterViewReuseIdentifier:header_id];
    self.tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeInteractive;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"客户信息";
    
}
- (void)initFootView {
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 60)];
    _footView.backgroundColor = [UIColor colorWithWhite:0.919 alpha:1.000];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSave setBackgroundImage:[UIImage imageNamed:@"btn8"] forState:UIControlStateNormal];
    [_footView addSubview:btnSave];
    
    UIButton *btnOffer = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOffer setTitle:@"报价" forState:UIControlStateNormal];
    btnOffer.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnOffer addTarget:self action:@selector(offerAction) forControlEvents:(UIControlEventTouchUpInside)];
    [btnOffer setBackgroundImage:[UIImage imageNamed:@"btn4"] forState:UIControlStateNormal];
    [_footView addSubview:btnOffer];
    
    
    // 给右边视图添加约束
    [btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.mas_equalTo(10);
        // 添加左边距约束（距离左边按键的距离）
        make.left.equalTo(btnOffer.mas_right).with.offset(20);
        // 添加右边距约束（距离当前主视图右边的距离）
        make.right.mas_equalTo(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(40);
        // 添加宽度（宽度跟左边按键一样）
        make.width.equalTo(btnOffer);
    }];
    
    // 给左边视图添加约束
    [btnOffer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //添加上边距约束
        make.top.mas_equalTo(10);
        // 添加左边距约束（距离当前主视图左边的距离）
        make.left.mas_equalTo(20);
        // 添加右边距约束（距离第二个按键左边的距离）
        make.right.equalTo(btnSave.mas_left).with.offset(-20);
        // 添加当前按钮的高度
        make.height.mas_equalTo(40);
        // 添加宽度（宽度跟右边按键一样）
        make.width.equalTo(btnSave);
    }];
}

// 保存
- (void)saveAction {
    
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
    OfferTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:path1];

    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
    OfferTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:path2];
    NSLog(@"%@%@",cell2.carUserCard.text,cell2.carUserName.text);

    
    
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSLog(@"%@,%@%@%@",self.order.baseId,self.order.customerId,self.order.cityCode,self.order.phoneNo);
    
    NSLog(@"%@",cell1.carCode.text);
    NSDictionary *myServerDict = @{@"userId":user.userId,
                                   @"baseId":self.order.baseId<=0?@"":self.order.baseId,
                                   @"id":self.order.customerId<=0?@"":self.order.customerId,
                                   @"orderType":@"",
                                   @"cityCode":self.order.cityCode,
                                   @"custName":cell2.carUserName.text,
                                   @"phoneNo":self.order.phoneNo,
                                   @"licenseNo":self.order.licenseNo,
                                   @"engineNo":cell1.engine.text,
                                   @"frameNo":cell1.carFrameCode.text,
                                   @"cappld":cell2.carUserCard.text,
                                   @"date":cell1.firstTime.text,
                                   @"vehicleModelName":cell1.engineType.text
                                   };
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kEstablishCustBySelf] params:myServerDict
        successBlock:^(id returnData) {
        MyClientViewController *VC = self.navigationController.viewControllers[1];
        VC.isSaveCarInfo = YES;
        [self.navigationController popToViewController:VC animated:YES];
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
}

- (void)offerAction {
    [MBProgressHUD showMessag:@"程序猿正在火力开发中" toView:self.view];

//    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
//    OfferTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:path1];
//
//    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
//    OfferTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:path2];
//    NSLog(@"%@%@",cell2.carUserCard.text,cell2.carUserName.text);
//
//    
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    delegate.isThird=YES;
//    /**
//     *  dataType 01:创建订单,获取新数据 02:创建客户
//     */
//    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
//    NSString *licenseNo = self.order.licenseNo;
//    if ([self.order.licenseNo isEqualToString:@""]) {
//        licenseNo = @"新车";
//    }
//    NSDictionary *params = @{@"operType":@"测试",
//                             @"msg":@"",
//                             @"sendTime":@"",
//                             @"sign":@"",
//                             @"data":@{@"proportion":@"0.8",
//                                       @"customerName":cell2.carUserName.text,
//                                       @"phoneNo":self.order.phoneNo,
//                                       @"dataType":@"02",
//                                       @"comeFrom":@"YPT",
//                                       @"activeType":@"1",
//                                       @"macAdress":@"",
//                                       @"agentCode":@"",
//                                       @"engineNo":cell1.engine.text,
//                                       @"vehicleFrameNo":cell1.carFrameCode.text,
//                                       @"licenseNo":licenseNo,
//                                       @"vehicleModelName":cell1.engineType.text,
//                                       @"userId":user.userId,
//                                       @"accountType":@"3",
//                                       @"cityCode":self.order.cityCode,
//                                       @"registerDate":cell1.firstTime.text}
//                             };
//    
//
//    __weak typeof(self) weakSelf = self;
//    [MHNetworkManager postReqeustWithURL:kZhiKe params:params successBlock:^(id returnData) {
//        
//        NSLog(@"%@",returnData);
//        delegate.isThird=NO;
//        if ([returnData[@"state"] isEqualToString:@"0"]) {
//            NSString *url = [returnData[@"data"] valueForKey:@"retPage"];
//            NSString *baseId = [returnData[@"data"] valueForKey:@"baseId"];
//            NSDictionary *myServerDict = @{
//                                           @"userId":user.userId,
//                                           @"baseId":baseId,
//                                           @"id":self.order.customerId,
//                                           @"orderType":@"",
//                                           @"cityCode":self.order.cityCode,
//                                           @"custName":cell2.carUserName.text,
//                                           @"phoneNo":self.order.phoneNo,
//                                           @"licenseNo":self.order.licenseNo,
//                                           @"engineNo":cell1.engine.text,
//                                           @"frameNo":cell1.carFrameCode.text,
//                                           @"cappld":cell2.carUserCard.text,
//                                           @"date":cell1.firstTime.text,
//                                           @"vehicleModelName":cell1.engineType.text
//                                           };
//            OrderH5ViewController *cliteVC = [[OrderH5ViewController alloc] init];
//            cliteVC.url = url;
//            [weakSelf createOrderWithParam:myServerDict pushUrl:url];
//        }else{
//            [MBProgressHUD showMessag:returnData[@"msg"] toView:self.view];
//        }
//        
//    } failureBlock:^(NSError *error) {
//        delegate.isThird=NO;
//        
//    } showHUD:YES];
}

- (void)createOrderWithParam:(NSDictionary *)param pushUrl:(NSString *)url{
    
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:ksaveOrder] params:param successBlock:^(id returnData) {
        
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            OrderH5ViewController *orderH5VC = [[OrderH5ViewController alloc] init];
            orderH5VC.url = url;
            [weakSelf.navigationController pushViewController:orderH5VC animated:YES];
        }else {
            [MBProgressHUD showMessag:[returnData objectForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId=@"cell";
    
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OfferTableViewCell" owner:self options:nil];

            if (indexPath.section == 0) {
                cell = [array objectAtIndex:0];
                if (![self.order.licenseNo isEqualToString:@""]) {
                    cell.carCode.text = self.order.licenseNo;
                }else {
                    cell.carCode.text = @"新车";
                }
                cell.engine.text = self.order.engineNo;
                cell.carFrameCode.text = self.order.frameNo;
                cell.engineType.text = self.order.vehicleModelName;
                NSLog(@"%@",self.order.primaryDate);
                if (self.order.primaryDate.length>0) {
                    cell.firstTime.text = [HelperUtil timeFormat:self.order.primaryDate format:@"yyyy-MM-dd"];
                }
                
           
                
            }else{
                cell = [array objectAtIndex:1];
                cell.carUserName.text = self.order.customerName;
                cell.carUserCard.text = self.order.cappld;
                cell.carUserPhone.text = self.order.phoneNo;
            }

        
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SetUserInfoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_id];
    headerView.titleLabel.text = section == 0 ? @"车辆信息" : @"车主信息";
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        return _footView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else{
        return 60;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 279;
    }else{
        return 161;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return headerHeight;
}

#pragma mark textField
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
    OfferTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:path1];
    
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
    OfferTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:path2];
    if ([textField isEqual:cell1.engine]) {
        if (![cell1.engine.text isEqualToString:@""]) {
            if (![HelperUtil validateEngineNo:cell1.engine.text]) {
                [MBProgressHUD showMessag:@"发动机号格式错误" toView:self.view];
                return ;
            }
        }
    }
    if ([textField isEqual:cell1.carFrameCode]) {
        if (![cell1.carFrameCode.text isEqualToString:@""]) {
            if (![HelperUtil validateCarFrame:cell1.carFrameCode.text]) {
                [MBProgressHUD showMessag:@"车架号格式错误" toView:self.view];
                return ;
            }
        }
    }
    if ([textField isEqual:cell2.carUserCard]) {
        if (![cell2.carUserCard.text isEqualToString:@""]) {
            if (![HelperUtil checkUserIdCard:cell2.carUserCard.text]) {
                [MBProgressHUD showMessag:@"身份证号格式错误" toView:self.view];
                return ;
            }
        }
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
