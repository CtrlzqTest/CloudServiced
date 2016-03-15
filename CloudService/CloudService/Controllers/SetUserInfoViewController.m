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
#import "DataSource.h"
#import "Utility.h"
#import "YWBCityPickerView.h"
#import "ZQCityPickerView.h"
#import "LoginViewController.h"
#import "CodeNameModel.h"
#import "ResetPhonePopView.h"

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
    NSMutableArray *_companyArray;
    NSMutableArray *_saleCityArray;
    
    NSIndexPath *_indexPath;
    BOOL _isAnimating;
    
}

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UITableView *selectTableView;
@property(nonatomic,strong) NSArray *selectArray;
@property(nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong)HZQDatePickerView *pickerView;
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
        [self.rightBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    }
    if (self.notEnable) {
        [self.rightBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
    }
}

-(void)setSelectArray:(NSArray *)selectArray {
    
    if (_selectArray != selectArray) {
        _selectArray = [selectArray copy];
        
    }
}

- (IBAction)saveAction:(id)sender {
    
    // 编辑
    if (self.notEnable) {
        self.notEnable = NO;
        [self.tableView reloadData];
        return;
//        typeof(self) weakSelf = self;
//        
//        User *user = [[SingleHandle shareSingleHandle] getUserInfo];
//        __block ResetPhonePopView *popView = [[[NSBundle mainBundle] loadNibNamed:@"ResetPhonePopView" owner:weakSelf options:nil] firstObject];
//        popView.frame = [UIScreen mainScreen].bounds;
//        [popView showViewWithCallBack:^(NSInteger btnIndex) {
//
//            if (btnIndex == 1) {
//                [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kCheckPhoneNumAPI] params:@{@"phoneNo":user.phoneNo,@"code":popView.phoneNum} successBlock:^(id returnData) {
//                    if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
//                        
//                        [weakSelf.rightBtn setTitle:@"提交" forState:(UIControlStateNormal)];
//                        [weakSelf.tableView reloadData];
//                        popView = nil;
//                    }else {
//                        [MBProgressHUD showError:[returnData valueForKey:@"msg"] toView:weakSelf.view];
//                    }
//                    
//                } failureBlock:^(NSError *error) {
//                    
//                } showHUD:YES];
//            }
//        }];
    }
    [self resignKeyBoardInView:self.view];
    NSDictionary *dict = [self getParam];
    if (!dict) {
        return ;
    }
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kResetUserInfoAPI] params:dict successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            
            [MBProgressHUD showSuccess:@"提交成功,一个小时后生效" toView:nil];
            UIViewController *VC = [self.navigationController.viewControllers firstObject];
            if ([[VC class] isSubclassOfClass:[LoginViewController class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginToMenuViewNotice object:nil];
                return ;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadHomeData object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [MBProgressHUD showError:[returnData valueForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
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
    
    _keyArray_User = @[@"真实姓名",
                       @"证件号码",@"用户类型",
                       @"原离职公司",@"原职位",
                       @"从业时间",
                       @"微信号",@"申请销售保险公司",
                       @"销售数据城市"];
    
    _keyArray_Bank = @[@"开户人姓名",@"银行账号",
                       @"开户银行",@"支行名称",
                       @"开户省份",@"开户城市"];
    
    _valueArray_User = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"销售职",@"2015-01-01",@"",@"",@""]];
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    _valueArray_User[0] = user.realName;
    _valueArray_User[1] = user.idCard;
    _valueArray_User[2] = user.roleName;
    _valueArray_User[3] = user.oldCompany;
    _valueArray_User[4] = user.oldPost.length > 0 ? user.oldPost : @"销售职";
    NSString *workDate = user.workStartDate.length > 0 ? [HelperUtil timeFormat:user.workStartDate format:@"yyyy-MM-dd"] : @"2015-01-01";
    _valueArray_User[5] = workDate;
    _valueArray_User[6] = user.chatName;
    // 编码汉字
    _valueArray_User[7] = [DataSource changeSaleCompanyWithCodeString:user.applySaleCompany];
    _valueArray_User[8] = user.saleCityValue;
    
    _valueArray_Bank = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]];
    _valueArray_Bank[0] = user.realName;
    _valueArray_Bank[1] = user.bankNum;
    _valueArray_Bank[2] = user.bankName;
    _valueArray_Bank[3] = user.subbranchName;
    _valueArray_Bank[4] = user.accountProvinces;
    _valueArray_Bank[5] = user.accountCity;
    
    _companyArray = [NSMutableArray array];
    int i = 0;
    for (NSString *companyName in [DataSource changeSaleCompanyWithString:user.applySaleCompany]) {
        CodeNameModel *model = [[CodeNameModel alloc] init];
        model.companyName = companyName;
        model.companyCode = [DataSource insureCommpanyCodeArray][i];
        [_companyArray addObject:model];
        i ++;
    }
    _saleCityArray = [NSMutableArray array];
    i = 0;
    for (NSString *provinceName in [DataSource changeSaleCompanyWithString:user.saleCityValue]) {
        CodeNameModel *model = [[CodeNameModel alloc] init];
        model.provinceName = provinceName;
        model.provinceCode = [[DataSource provinceCodeDict] valueForKey:provinceName];
        [_saleCityArray addObject:model];
        i ++;
    }
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
    self.selectTableView.layer.shadowOpacity = 1;
    self.selectTableView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tableView.clipsToBounds = NO;
    self.selectTableView.layer.shadowOffset = CGSizeMake(3, 1);
    [self.maskBtn addSubview:self.selectTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHidden) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark -- HZQDatePickerViewDelegate
- (void)getSelectDate:(NSDate *)date type:(DateType)type {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];
    _valueArray_User[_indexPath.row] = currentOlderOneDateStr;
    [self.tableView reloadData];
    _pickerView = nil;
}

#pragma mark -- SetUserInfoCellDelegate
// 确定编辑在哪个cell上
-(void)textFiledShouldBeginEditAtCell:(SetUserInfoCell *)cell {
    
    _indexPath = [self.tableView indexPathForCell:cell];
    
}

-(void)didDeleteText:(SetUserInfoCell *)cell {
    
    [self resignKeyBoardInView:self.view];
    _indexPath = [self.tableView indexPathForCell:cell];
    if (_indexPath.row == 7)
    {
        [_companyArray removeAllObjects];
    }
    else if(_indexPath.row == 8)
    {
        [_saleCityArray removeAllObjects];
    }
    _valueArray_User[_indexPath.row] = @"";
    [self.tableView reloadData];
}

-(void)textFiledDidEndEdit:(NSString *)text {
    
    if (_indexPath.section == 0) {
        _valueArray_User[_indexPath.row] = text;
    }else {
        _valueArray_Bank[_indexPath.row] = text;
    }
    if (_indexPath.section == 1 && (_indexPath.row == 1)) {
        if (![HelperUtil checkBankCard:text]) {
            [MBProgressHUD showError:@"你输入的银行卡号无效,请重新输入" toView:self.view];
        }else {
            NSString *bankBin = [text substringToIndex:6];
            if ([self getBankNameWithBankbin:bankBin].length <= 0) {
                [MBProgressHUD showError:@"你输入的银行卡号无效,请重新输入" toView:self.view];
            }else {
                _valueArray_Bank[2] = [self getBankNameWithBankbin:bankBin];
            }
        }
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
        return _valueArray_User.count;
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
    if (self.notEnable) {
        cell.textFiled.enabled = NO;
        return cell;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.textFiled.keyboardType = UIKeyboardTypePhonePad;
        }
        if (indexPath.row == 4 || indexPath.row == 3)
        {
            [cell isPullDown:YES];
        }else if(indexPath.row == 2 || indexPath.row == 5)
        {
            cell.textFiled.enabled = NO;
        }else if(indexPath.row == 8 || indexPath.row == 7)
        {
            [cell isPullDown:YES];
            if (cell.textFiled.text.length > 0) {
                [cell setDeleteImage:YES];
            }else{
                [cell setDeleteImage:NO];
            }
        }
    }else if(indexPath.row == 1){
        cell.textFiled.keyboardType = UIKeyboardTypePhonePad;
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
    
    if (self.notEnable) {
        return ;
    }
    if ([tableView isEqual:self.selectTableView]) {
        [self hidePullDownView];
        if (_indexPath.row == 3 || _indexPath.row == 4) {
            _valueArray_User[_indexPath.row] = _selectArray[indexPath.row];
        }else{
            
            NSString *code = [[DataSource insureCommpanyCodeArray] objectAtIndex:indexPath.row];
            // 可以用二分查找
            for (CodeNameModel *model in _companyArray) {
                if ([model.companyCode isEqualToString:code]) {
                    return;
                }
            }
            CodeNameModel *model = [[CodeNameModel alloc] init];
            model.companyName = _selectArray[indexPath.row];
            model.companyCode = code;
            [_companyArray addObject:model];
            _valueArray_User[_indexPath.row] = [self changeStrArraytoTextString:_companyArray];
        }
        [self.tableView reloadData];
        return;
    }
    [self resignKeyBoardInView:self.view];
    _indexPath = indexPath;
    SetUserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect tempRect = [cell.contentView convertRect:cell.textFiled.frame fromView:self.view];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 3:     _selectArray = [DataSource insureCommpanyNameArray];
                        CGRect rect3 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, 4 * 30);
                        [self showPullDownViewWithRect:rect3];
                        break;
            case 5:
                        [self showDataPickerView];
                        break;
            case 4:     _selectArray = @[@"销售职",@"销售管理职",@"其他"];
                        CGRect rect4 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, 3 * 30);
                        [self showPullDownViewWithRect:rect4];
                        break;
            case 7:     _selectArray = [DataSource insureCommpanyNameArray];
                        CGRect rect7 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cell.frame) - self.tableView.contentOffset.y, 150, 4 * 30);
                        [self showPullDownViewWithRect:rect7];
                        break;
                
            case 8:     [self showCityPickerViewWithCount:1];
                        break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 4 || indexPath.row == 5)
        {
            [self showCityPickerViewWithCount:2];
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
#pragma mark -- 私有方法
- (NSDictionary *)getParam {
    
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
    if (![HelperUtil checkUserIdCard:_valueArray_User[1]]) {
        [MBProgressHUD showMessag:@"身份证号输入不正确" toView:self.view];
        return nil;
    }
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    NSString *idCord = _valueArray_User[1];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:user.userId forKey:@"userId"];
    [dict setValue:user.userName forKey:@"userName"];
    [dict setValue:user.phoneNo forKey:@"phoneNo"];
    [dict setValue:[HelperUtil getSexWithIdcord:idCord] forKey:@"sex"];
    [dict setValue:[HelperUtil getBorthDayWithIdCord:idCord] forKey:@"age"];
    [dict setValue:_valueArray_User[0] forKey:@"realName"];
    [dict setValue:_valueArray_User[6] forKey:@"chatName"];
//
    [dict setValue:_valueArray_User[5] forKey:@"workStartDate"];
    [dict setValue:_valueArray_User[4] forKey:@"oldPost"];
    [dict setValue:_valueArray_User[3] forKey:@"oldCompany"];
    NSString *saleCity = _saleCityArray.count > 0 ? [self changeStrArraytoCodeString:_saleCityArray] : user.saleCity;
    [dict setValue:saleCity forKey:@"saleCity"];
    [dict setValue:[self changeStrArraytoTextString:_companyArray] forKey:@"applySaleCompany"];
    [dict setValue:idCord forKey:@"idCard"];

    // 银行信息
    [dict setValue:_valueArray_Bank[0] forKey:@"bankAccountName"];
    [dict setValue:_valueArray_Bank[2] forKey:@"bankName"];
    [dict setValue:_valueArray_Bank[1] forKey:@"bankNum"];
    [dict setValue:_valueArray_Bank[3] forKey:@"subbranchName"];
    [dict setValue:_valueArray_Bank[4] forKey:@"accountProvinces"];
    [dict setValue:_valueArray_Bank[5] forKey:@"accountCity"];
    
    return dict;
}

// 二分查找卡户银行
- (NSString *)getBankNameWithBankbin:(NSString *)bankBin {
    
    NSArray *bankBinArray = [DataSource bankBin];
    NSArray *bankNameArray = [DataSource bankNameArray];
    int low = 0;
    int high = (int)(bankBinArray.count-1);
    while(low <= high)
    {
        int middle = (low + high) / 2;
        if([bankBin isEqualToString:bankBinArray[middle]])
        {
            return bankNameArray[middle];
        }
        else if([bankBin compare:bankBinArray[middle]] == NSOrderedAscending)
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

- (void)showCityPickerViewWithCount:(NSInteger )count {
    
    [self resignKeyBoardInView:self.view];
    
    __block ZQCityPickerView *cityPickerView = [[ZQCityPickerView alloc] initWithProvincesArray:nil cityArray:nil componentsCount:count];
    
    [cityPickerView showPickViewAnimated:^(NSString *province, NSString *city,NSString *cityCode,NSString *provinceCode) {
        if (_indexPath.section == 0)
        {
            if (_saleCityArray.count > 3) {
                [MBProgressHUD showSuccess:@"城市选择不能超过四个" toView:self.view];
                return ;
            }
            
            // 可以用二分查找
            for (CodeNameModel *model in _saleCityArray) {
                if ([model.provinceName isEqualToString:province]) {
                    return;
                }
            }
            CodeNameModel *model = [[CodeNameModel alloc] init];
            model.provinceName = province;
            model.provinceCode = provinceCode;
            [_saleCityArray addObject:model];
            _valueArray_User[8] = [self changeStrArraytoTextString:_saleCityArray];
            
        }else
        {
            _valueArray_Bank[4] = province;
            _valueArray_Bank[5] = city;
        }
        NSLog(@"%@",cityCode);
        [self.tableView reloadData];
        cityPickerView = nil;
    }];
    
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
    [_pickerView.datePickerView setMaximumDate:[NSDate date]];
    [_pickerView showDateViewWithDelegate:self];
    
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

- (void)keyBoardDidHidden {
    if ([_valueArray_Bank[2] length] <= 0) {
        return;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 通过数组模型得到城市或公司字符串
- (NSString *)changeStrArraytoTextString:(NSArray *)array {
    
    
    NSMutableString *resultStr = [NSMutableString string];
    for (CodeNameModel *model in array) {
        if (model.provinceName.length > 0)
        {
            [resultStr appendString:model.provinceName];
        }else
        {
            [resultStr appendString:model.companyName];
        }
        [resultStr appendString:@","];
    }
    return [resultStr substringToIndex:resultStr.length - 1];
}

// 通过数组模型得到城市或公司编码
- (NSString *)changeStrArraytoCodeString:(NSArray *)array {
    
    
    NSMutableString *resultStr = [NSMutableString string];
    for (CodeNameModel *model in array) {
        if (model.provinceName.length > 0)
        {
            [resultStr appendString:model.provinceCode];
        }else
        {
            [resultStr appendString:model.companyCode];
        }
        [resultStr appendString:@","];
    }
    return [resultStr substringToIndex:resultStr.length - 1];
}

/*
 User *user = [[SingleHandle shareSingleHandle] getUserInfo];
 [[SingleHandle shareSingleHandle] saveUserInfo:user];
 user.realName = _valueArray_User[0];
 user.workStartDate = _valueArray_User[5];
 user.oldPost = _valueArray_User[4];
 user.oldCompany = _valueArray_User[3];
 user.saleCityValue =   _valueArray_User[8];
 if (_saleCityArray.count > 0) {
 user.saleCity = [self changeStrArraytoCodeString:_saleCityArray];
 }
 user.chatName  = _valueArray_User[6];
 if (_companyArray.count > 0) {
 // 用户显示汉字
 user.applySaleCompany = [self changeStrArraytoTextString:_companyArray];
 }
 user.bankAccountName = _valueArray_Bank[0];
 user.bankNum = _valueArray_Bank[1];
 user.bankName = _valueArray_Bank[2];
 user.subbranchName = _valueArray_Bank[3];
 user.accountProvinces = _valueArray_Bank[4];
 user.accountCity = _valueArray_Bank[5];
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
