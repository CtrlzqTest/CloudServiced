//
//  SetUserInfoViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SetUserInfoViewController.h"
#import "SetUserInfoCell.h"
#import "SetUserInfoHeaderView.h"
#import "HZQDatePickerView.h"
#import "HelperUtil.h"
#import "BankInfoData.h"
#import "YWBCityPickerView.h"


static NSString *const cell_id = @"setUserInfoCell";
static NSString *const header_id = @"setUserInfoHeader";
static CGFloat headerHeight = 30;
static NSString *const select_CellID = @"selectCell";
@interface SetUserInfoViewController ()<SetUserInfoCellDelegate,HZQDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_keyArray_User;
    NSArray *_keyArray_Bank;
    NSMutableArray *_valueArray_User;
    NSMutableArray *_valueArray_Bank;
    
    NSIndexPath *_indexPath;
    BOOL _isAnimating;
    
}

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UITableView *selectTableView;
@property(nonatomic,strong) NSArray *selectArray;
@property(nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong)HZQDatePickerView *pickerView;
@property (nonatomic, strong) YWBCityPickerView *cityPickerView;
@property (nonatomic,strong)UIView *maskView;

@end

@implementation SetUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self initData];
    [self setupSelectTableView];
    if (self.rightBtnTitle) {
        [self.rightBtn setTitle:self.rightBtnTitle forState:(UIControlStateNormal)];
    }else {
        [self.rightBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    }
}

-(void)setSelectArray:(NSArray *)selectArray {
    
    if (_selectArray != selectArray) {
        _selectArray = [selectArray copy];
        
    }
}

- (IBAction)saveAction:(id)sender {
    
    [self resignKeyBoardInView:self.view];
    [self getParam];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

// 设置tableView样式
- (void)setupTableView {
    
    self.title = @"填写个人资料";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetUserInfoCell" bundle:nil] forCellReuseIdentifier:cell_id];
    [self.tableView registerClass:[SetUserInfoHeaderView class] forHeaderFooterViewReuseIdentifier:header_id];
}

- (void)initData {
    
    _keyArray_User = @[@"真实姓名",@"证件类型",
                       @"证件号码",@"用户类型",
                       @"原离职公司",@"原职位",
                       @"从业时间",@"工作类型",
                       @"微信号",@"申请销售保险公司",
                       @"销售数据城市"];
    
    _keyArray_Bank = @[@"开户人姓名",@"银行账号",
                       @"开户银行",@"支行名称",
                       @"开户省份",@"开户城市"];
    
    _valueArray_User = [NSMutableArray arrayWithArray:@[@"",@"身份证",@"",@"初级用户",@"",@"",@"2015-01-01",@"销售人员",@"",@"阳光保险",@""]];
    
    _valueArray_Bank = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]];
    
}

- (void)setupSelectTableView {
    
    // 现加上蒙版
    self.maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maskBtn.frame = self.view.bounds;
    [self.maskBtn addTarget:self action:@selector(hidePullDownView) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    self.maskBtn.hidden = YES;
    [self.view addSubview:self.maskBtn];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.selectTableView.dataSource = self;
    self.selectTableView.delegate = self;
    self.selectTableView.backgroundColor = [UIColor grayColor];
    [self.selectTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:select_CellID];
//    self.selectTableView.layer.borderWidth = 0.6;
//    self.selectTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.selectTableView.layer.shadowOpacity = 1;
    self.selectTableView.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.selectTableView.layer.shadowRadius = 3;
    self.tableView.clipsToBounds = NO;
    self.selectTableView.layer.shadowOffset = CGSizeMake(3, 1);
    [self.maskBtn addSubview:self.selectTableView];
}

// 显示下拉列表
- (void)showPullDownViewWithRect:(CGRect )rect {
    
    if (_isAnimating) {
        return ;
    }
    _isAnimating = YES;
    self.maskBtn.hidden = NO;
    [self.selectTableView reloadData];
    CGRect tempRect = rect;
    tempRect.size.height = 0.1;
    self.selectTableView.frame = tempRect;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectTableView.frame = rect;
    } completion:^(BOOL finished) {
        self.selectTableView.frame = rect;
        _isAnimating = NO;
    }];
    
}


// 隐藏下拉列表
- (void)hidePullDownView {
    if (_isAnimating) {
        return;
    }
    CGRect tempRext = self.selectTableView.frame;
    tempRext.size.height = 0.1;
    _isAnimating = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.selectTableView.frame = tempRext;
    } completion:^(BOOL finished) {
       self.maskBtn.hidden = YES;
        _isAnimating = NO;
    }];
//    // 收回列表
//    SetUserInfoCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
//    cell.imageBtn.image = [UIImage imageNamed:@"details-arrow2"];
//    [cell reloadInputViews];
}

- (void)showDataPickerView {
        
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, KWidth, KHeight + 20);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = DateTypeOfStart;
    [_pickerView.datePickerView setMinimumDate:[NSDate date]];
    [self.view addSubview:_pickerView];
    
}

/** 消失键盘*/
- (void)resignKeyBoardInView:(UIView *)view

{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

#pragma mark -- HZQDatePickerViewDelegate
- (void)getSelectDate:(NSDate *)date type:(DateType)type {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];
    _valueArray_User[_indexPath.row] = currentOlderOneDateStr;
    [self.tableView reloadData];
}

#pragma mark -- SetUserInfoCellDelegate
// 确定编辑在哪个cell上
-(void)textFiledShouldBeginEditAtCell:(SetUserInfoCell *)cell {
    
    _indexPath = [self.tableView indexPathForCell:cell];
    if (_indexPath.row) {
        
    }
    
}

-(void)textFiledDidEndEdit:(NSString *)text {
    if (_indexPath.section == 0) {
        _valueArray_User[_indexPath.row] = text;
    }else {
        _valueArray_Bank[_indexPath.row] = text;
    }
    _indexPath = nil;
}

#pragma mark -- UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self resignKeyBoardInView:self.view];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.selectTableView]) {
        return _selectArray.count;
    }
    if (section == 0) {
        return 11;
    }else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 下拉的tableView
    if ([tableView isEqual:self.selectTableView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:select_CellID];
        cell.textLabel.text = _selectArray[indexPath.row];
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
    
    SetUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    cell.delegate = self;
    cell.label.text = indexPath.section == 0 ? _keyArray_User[indexPath.row] : _keyArray_Bank[indexPath.row];
    cell.textFiled.text = indexPath.section == 0 ? _valueArray_User[indexPath.row] : _valueArray_Bank[indexPath.row];
    [cell isPullDown:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 9) {
            [cell isPullDown:YES];
        }else if(indexPath.row == 6){
            cell.textFiled.enabled = NO;
        }
    }else if(indexPath.row == 1){
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5)
        {
            cell.textFiled.enabled = NO;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView isEqual:self.selectTableView]) {
        [self hidePullDownView];
        _valueArray_User[_indexPath.row] = _selectArray[indexPath.row];
        [self.tableView reloadData];
        return;
    }
    
//    if (_indexPath) {
//        SetUserInfoCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
//        [cell.textFiled resignFirstResponder];
//    }
    [self resignKeyBoardInView:self.view];
    _indexPath = indexPath;
    SetUserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect tempRect = [cell.contentView convertRect:cell.textFiled.frame fromView:self.view];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:    {
                _selectArray = @[@"身份证",@"军人证"];
                CGRect rect1 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, _selectArray.count * 30);
//                [UIView animateWithDuration:0.5 animations:^{
//                    cell.imageBtn.transform = CGAffineTransformMakeRotation(M_PI);
//                }];
//                [cell reloadInputViews];
                [self showPullDownViewWithRect:rect1];
                
            }
                        break;
            case 3:     _selectArray = @[@"身份证",@"军人证"];
                        CGRect rect3 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, _selectArray.count * 30);
                        [self showPullDownViewWithRect:rect3];
                        break;
            case 6:
                        [self showDataPickerView];
                        break;
            case 7:     _selectArray = @[@"身份证",@"军人证"];
                        CGRect rect7 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, _selectArray.count * 30);
                        [self showPullDownViewWithRect:rect7];
                        break;
                
            case 9:     _selectArray = @[@"身份证",@"军人证"];
                        CGRect rect9 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, _selectArray.count * 30);
                        [self showPullDownViewWithRect:rect9];
                        break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 4 || indexPath.row == 5)
        {
            [self showCityPickerView];
        }
       
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SetUserInfoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_id];
    headerView.titleLabel.text = section == 0 ? @"个人信息" : @"银行信息";
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.selectTableView]) {
        return 30;
    }
    return 50;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.selectTableView]) {
        return 0.1;
    }
    return headerHeight;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([tableView isEqual:self.selectTableView]) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.selectTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.selectTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.selectTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.selectTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSDictionary *)getParam {
    
    //    NSMutableDictionary *dic
    for (int i = 0; i < _valueArray_User.count; i ++) {
        
        if ([_valueArray_User[i] length] <= 0) {
            [MBProgressHUD showMessag:[NSString stringWithFormat:@"%@不能为空",_keyArray_User[i]] toView:self.view];
            return nil;
        }
    }
    for (int i = 0; i < _valueArray_Bank.count; i ++) {
        if ([_valueArray_Bank[i] length] <= 0) {
            [MBProgressHUD showMessag:[NSString stringWithFormat:@"%@不能为空",_keyArray_Bank[i]] toView:self.view];
            return nil;
        }
    }
    if (![HelperUtil checkUserIdCard:_valueArray_User[2]]) {
        [MBProgressHUD showMessag:@"省份证号输入不正确" toView:self.view];
    }
    return nil;
}

// 二分查找卡户银行
- (NSString *)getBankNameWithBankbin:(NSString *)bankBin {
    
    NSArray *bankBinArray = [BankInfoData bankBin];
    NSArray *bankNameArray = [BankInfoData bankNameArray];
    int low = 0;
    int high = (int)(bankBinArray.count-1);
    while(low <= high)
    {
        int middle = (low + high) / 2;
        if([bankBin isEqualToString:bankBinArray[middle]])
        {
            return bankNameArray[middle];
        }
        else if(bankBin < bankBinArray[middle])
        {
            high = middle - 1;
        }
        else
        {
            low = middle + 1;
        }
    }
    return nil;
}


- (void)hideCityPickerView:(UIGestureRecognizer *)sender {
    
    _valueArray_Bank[4] = self.cityPickerView.province;
    _valueArray_Bank[5] = self.cityPickerView.city;
    [self.tableView reloadData];
    _maskView.hidden = YES;
    [self.cityPickerView hiddenPickerView];
}

- (void)showCityPickerView {
    
    [self resignKeyBoardInView:self.view];
    if (!self.cityPickerView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0.363 green:0.380 blue:0.373 alpha:0.500];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCityPickerView:)]];
        [self.view addSubview:_maskView];
        self.cityPickerView = [[YWBCityPickerView alloc] init];
        self.cityPickerView.backgroundColor = [UIColor whiteColor];
        self.cityPickerView.frame = CGRectMake(0, self.view.frame.size.height, KWidth, 300);
    }
    _maskView.hidden = NO;
    [self.cityPickerView showInView:self.maskView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
