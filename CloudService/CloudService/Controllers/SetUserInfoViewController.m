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
#import "SetUserInfoCell2.h"
#import "PellTableViewSelect.h"
#import "ChooseCompanyViewController.h"

static NSString *const cell_id = @"setUserInfoCell";
static NSString *const cell_Id2 = @"setUserInfoCell2";
static NSString *const header_id = @"setUserInfoHeader";
static CGFloat headerHeight = 30;
static NSString *const select_CellID = @"selectCell";

@interface SetUserInfoViewController ()<SetUserInfoCell2Delegate,SetUserInfoCellDelegate,HZQDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_keyArray_User;
    NSArray *_keyArray_Bank;
    NSMutableArray *_valueArray_User;   // 需要填写的个人信息
    NSMutableArray *_valueArray_Bank;   // 需要填写的银行信息
    NSMutableArray *_companyArray;      // 申请销售数据公司,数据处理数组
    NSMutableArray *_saleCityArray;     // 销售城市数据处理数组
    
    NSIndexPath *_indexPath;            // 正在编辑某一Cell的Indexpath
    
}

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *selectArray;               // 下拉框数据存储数组,多套数据公用一个数组
@property (nonatomic,strong)HZQDatePickerView *pickerView;      // 城市选择

@end

@implementation SetUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self initData];
    self.title = @"个人信息";
    if (self.notEnable) {
        [self.rightBtn setTitle:@"修改" forState:(UIControlStateNormal)];
        return;
    }
    if (self.rightBtnTitle) {
        [self.rightBtn setTitle:self.rightBtnTitle forState:(UIControlStateNormal)];
    }else {
        [self.rightBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
        if (self.rightBtnTitle) {
            [self.rightBtn setTitle:self.rightBtnTitle forState:(UIControlStateNormal)];
        }else {
            [self.rightBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        }
        [self.tableView reloadData];
        return;
    }
    [self resignKeyBoardInView:self.view];
    NSDictionary *dict = [self getParam];
    if (!dict) {
        return ;
    }
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kResetUserInfoAPI] params:dict successBlock:^(id returnData) {
        
        if ([[returnData valueForKey:@"flag"] isEqualToString:@"success"]) {
            [self saveUserInfo:dict];
            if ([self.rightBtn.titleLabel.text isEqualToString:@"提交"]) {
                [MBProgressHUD showSuccess:@"提交成功,一个小时后生效" toView:nil];
            }else {
                [MBProgressHUD showSuccess:@"修改成功" toView:nil];
            }
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

// 设置tableView样式
- (void)setupTableView {
    
    self.title = @"填写个人资料";
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetUserInfoCell" bundle:nil] forCellReuseIdentifier:cell_id];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetUserInfoCell2" bundle:nil] forCellReuseIdentifier:cell_Id2];
    [self.tableView registerClass:[SetUserInfoHeaderView class] forHeaderFooterViewReuseIdentifier:header_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:ChooseSaleCompany object:nil];
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
    _valueArray_User[2] = user.roleName.length <= 0 ? @"普通用户" : user.roleName;
    
    _valueArray_User[3] = [DataSource changeCompanyCodeToText:user.oldCompany];
    _valueArray_User[4] = user.oldPost.length > 0 ? user.oldPost : @"销售职";
    NSString *workDate = user.workStartDate.length > 0 ? [HelperUtil timeFormat:user.workStartDate format:@"yyyy-MM-dd"] : @"2015-01-01";
    _valueArray_User[5] = workDate;
    _valueArray_User[6] = user.chatName;
    // 编码汉字
    _valueArray_User[7] = [DataSource changeSaleCompanyWithCodeString:user.applySaleCompany];
    _valueArray_User[8] = user.saleCityValue;
    
    _valueArray_Bank = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]];
    _valueArray_Bank[0] = user.bankAccountName;
    _valueArray_Bank[1] = user.bankNum;
    _valueArray_Bank[2] = user.bankName;
    _valueArray_Bank[3] = user.subbranchName;
    _valueArray_Bank[4] = user.accountProvinces;
    _valueArray_Bank[5] = user.accountCity;
    
    _companyArray = [NSMutableArray array];
    int i = 0;
    for (NSString *companyCode in [DataSource changeSaleCompanyWithString:user.applySaleCompany]) {
        CodeNameModel *model = [[CodeNameModel alloc] init];
        model.companyName = [DataSource changeCompanyCodeToText:companyCode];
        model.companyCode = companyCode;
        [_companyArray addObject:model];
    }
    _saleCityArray = [NSMutableArray array];
    i = 0;
    // saleCityValue 是城市名,不是编码,对应后台传了saleCity编码
    for (NSString *provinceName in [DataSource changeSaleCompanyWithString:user.saleCityValue]) {
        CodeNameModel *model = [[CodeNameModel alloc] init];
        model.provinceName = provinceName;
        model.provinceCode = [[DataSource provinceCodeDict] valueForKey:provinceName];
        [_saleCityArray addObject:model];
        i ++;
    }
}

- (void)reloadTableView {
    _valueArray_User[_indexPath.row] = [self changeStrArraytoTextString:_companyArray];
    [self.tableView reloadData];
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

#pragma mark -- SetUserInfoCell2Delegate
-(void)didDeleteTextForCompany:(SetUserInfoCell2 *)cell {
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

#pragma mark -- SetUserInfoCellDelegate
// 确定编辑在哪个cell上
-(void)textFiledShouldBeginEditAtCell:(SetUserInfoCell *)cell {
    
    _indexPath = [self.tableView indexPathForCell:cell];
    
}

-(void)textFiledDidEndEdit:(NSString *)text {
    
    if (_indexPath.section == 0) {
        _valueArray_User[_indexPath.row] = text;
        if (_indexPath.row == 1) {
            if (![HelperUtil checkUserIdCard:_valueArray_User[1]]) {
                [MBProgressHUD showMessag:@"身份证号输入不正确" toView:self.view];
                return ;
            }
        }
    }else {
        _valueArray_Bank[_indexPath.row] = text;
    }
    if (_indexPath.section == 1 && (_indexPath.row == 1)) {
        if (![HelperUtil checkBankCard:text]) {
            [MBProgressHUD showError:@"你输入的银行卡号无效,请重新输入" toView:self.view];
        }else {
            NSString *bankBin = [text substringToIndex:6];
            if ([self getBankNameWithBankbin:bankBin].length <= 0) {
                [MBProgressHUD showError:@"查不到你的银行卡信息,请手动输入开户银行" toView:self.view];
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

    if (section == 0) {
        return _valueArray_User.count;
    }else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isCell2 = (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8) ? 1 : 0;
    // 个人信息,带下拉框
    if (indexPath.section == 0 && isCell2) {

        SetUserInfoCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:cell_Id2 forIndexPath:indexPath];
        cell2.titleLabelWidth.constant = 80;
        cell2.titleLabel.text = _keyArray_User[indexPath.row];
        cell2.delegate = self;
        cell2.contentLabel.text = _valueArray_User[indexPath.row];
        [cell2 isPullDown:NO];
            
        if (self.notEnable) {
            if(indexPath.row == 8 || indexPath.row == 7) {
                cell2.titleLabelWidth.constant = 120;
            }
            return cell2;
        }
        [cell2 isPullDown:YES];
        if (indexPath.row == 8) {
            cell2.titleLabelWidth.constant = 120;
            if (cell2.contentLabel.text.length > 0) {
                [cell2 setDeleteImage:YES];
            }else{
                [cell2 setDeleteImage:NO];
            }
        }
        if (indexPath.row == 7) {
            cell2.titleLabelWidth.constant = 120;
            cell2.imgView.image = [UIImage imageNamed:@"details-arrow1"];
        }
        return cell2;
    }
    // 个人信息，不带下拉框
    SetUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[SetUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.label.text = indexPath.section == 0 ? _keyArray_User[indexPath.row] : _keyArray_Bank[indexPath.row];
    cell.textFiled.text = indexPath.section == 0 ? _valueArray_User[indexPath.row] : _valueArray_Bank[indexPath.row];
    cell.delegate = self;
    cell.textFiled.enabled = YES;
    cell.textFiled.keyboardType = UIKeyboardTypeDefault;
    
    if (self.notEnable) {
        cell.textFiled.enabled = NO;
        return cell;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.textFiled.keyboardType = UIKeyboardTypeDefault;
        }else if(indexPath.row == 2 || indexPath.row == 5)
        {
            cell.textFiled.enabled = NO;
        }
    }
    
//  银行信息
    if (indexPath.section == 1)
    {
        if(indexPath.row == 1){
            cell.textFiled.keyboardType = UIKeyboardTypePhonePad;
        }
        if (indexPath.row == 4 || indexPath.row == 5)
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
    [self resignKeyBoardInView:self.view];
    _indexPath = indexPath;
    BOOL isCell2 = (indexPath.section == 0) && (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8) ? 1 : 0;
    CGRect tempRect = CGRectZero;
    CGRect cellFrame = CGRectZero;
    if (!isCell2 || indexPath.section == 1) {
        SetUserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        tempRect = [cell.contentView convertRect:cell.textFiled.frame fromView:self.view];
        cellFrame = cell.frame;
    }else {
        SetUserInfoCell2 *cell = [tableView cellForRowAtIndexPath:indexPath];
        tempRect = [cell.contentView convertRect:cell.contentLabel.frame fromView:self.view];
        cellFrame = cell.frame;
    }
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 3:{
                        _selectArray = [DataSource insureCommpanyNameArray];
                        CGRect rect3 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cellFrame) - self.tableView.contentOffset.y + 64, tempRect.size.width, 4 * 40);
//                        [self showPullDownViewWithRect:rect3];
                
                        [PellTableViewSelect addPellTableViewSelectWithWindowFrame:rect3 selectData:_selectArray action:^(NSInteger index) {
                            _valueArray_User[_indexPath.row] = _selectArray[index];
                            [self.tableView reloadData];
                        } animated:YES];
                    }
                        break;
            case 5:
                        [self showDataPickerView];
                        break;
            case 4:{
                        _selectArray = @[@"销售职",@"销售管理职",@"其他"];
                        CGRect rect4 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cellFrame) - self.tableView.contentOffset.y + 64, tempRect.size.width, 3 * 40);
//                        [self showPullDownViewWithRect:rect4];
                            [PellTableViewSelect addPellTableViewSelectWithWindowFrame:rect4 selectData:_selectArray action:^(NSInteger index) {
                                _valueArray_User[_indexPath.row] = _selectArray[index];
                                [self.tableView reloadData];
                            } animated:YES];
                    }
                        break;
            case 7:{
                
                ChooseCompanyViewController *chooseVC = [[ChooseCompanyViewController alloc] init];
                chooseVC.selectArray = _companyArray;
                [self getChooseDataArray];
                chooseVC.dataArray = [NSMutableArray arrayWithArray:[self getChooseDataArray]];
                [self.navigationController pushViewController:chooseVC animated:YES];
                
//                        _selectArray = [DataSource insureCommpanyNameArray];
//                        CGRect rect7 = CGRectMake(tempRect.origin.x, CGRectGetMaxY(cellFrame) - self.tableView.contentOffset.y + 64, tempRect.size.width, 4 * 40);
////                        [self showPullDownViewWithRect:rect7];
//                            [PellTableViewSelect addPellTableViewSelectWithWindowFrame:rect7 selectData:_selectArray action:^(NSInteger index) {
//                                NSString *code = [[DataSource insureCommpanyCodeArray] objectAtIndex:index];
//                                // 可以用二分查找
//                                for (CodeNameModel *model in _companyArray) {
//                                    if ([model.companyCode isEqualToString:code]) {
//                                        return;
//                                    }
//                                }
//                                CodeNameModel *model = [[CodeNameModel alloc] init];
//                                model.companyName = _selectArray[index];
//                                model.companyCode = code;
//                                [_companyArray addObject:model];
//                                _valueArray_User[_indexPath.row] = [self changeStrArraytoTextString:_companyArray];
//                                [self.tableView reloadData];
//                            } animated:YES];
                        break;
                    }
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
    
    if (indexPath.section == 0 && indexPath.row == 7) {
        return 50;
    }else {
        return 50;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return headerHeight;
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
    [dict setValue:[DataSource changeCompanyTextToCode:_valueArray_User[3]] forKey:@"oldCompany"];
    NSString *saleCity = _saleCityArray.count > 0 ? [self changeStrArraytoCodeString:_saleCityArray] : user.saleCity;
    [dict setValue:saleCity forKey:@"saleCity"];
    [dict setValue:[self changeStrArraytoCodeString:_companyArray] forKey:@"applySaleCompany"];
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


/**
 *  获取未选中的销售公司
 */
- (NSArray *)getChooseDataArray {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *companyName in [DataSource insureCommpanyNameArray]) {
        
        if ([_valueArray_User[7] containsString:companyName]) {
            continue;
        }
        CodeNameModel *model = [[CodeNameModel alloc] init];
        model.companyCode = [DataSource changeCompanyTextToCode:companyName];
        model.companyName = companyName;
        [dataArray addObject:model];
    }
    return dataArray;
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
        [self.tableView reloadData];
        cityPickerView = nil;
    }];
    
}

/**
 *  时间选择
 */
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

// 填写银行卡号后,自动显示银行卡信息
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

// 提交后保存用户信息到本地
- (void)saveUserInfo:(NSDictionary *)dict {
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    [user setValuesForKeysWithDictionary:dict];
    user.workStartDate = [HelperUtil getDateWithDateStr:user.workStartDate];
    user.saleCityValue = [self changeStrArraytoTextString:_saleCityArray];
    [[SingleHandle shareSingleHandle] saveUserInfo:user];
}
/*
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
