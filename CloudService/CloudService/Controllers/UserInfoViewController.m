//
//  UserInfoViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/2/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SetUserInfoCell.h"
#import "SetUserInfoViewController.h"
#import "ResetPhonePopView.h"
#import "Utility.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_keyArray;
    NSMutableArray *_valueArray;
    
    BOOL _isTosetUserInfo;
}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isTosetUserInfo = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_isTosetUserInfo) {
        if (!self.isFromhomeVC) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        }
    }
}

- (IBAction)resetUserInfoAction:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetUserInfoViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"setUserInfo"];
    _isTosetUserInfo = YES;
    setUserInfoVC.rightBtnTitle = @"保存";
    [self.navigationController pushViewController:setUserInfoVC animated:YES];
    
}


- (void)initData {
    
    _keyArray = @[@"头像",@"名字",@"手机号",@"身份证号",@"微信号",@"银行账号"];
    _valueArray = [NSMutableArray array];
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    
    // 从user中获取
//    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kGetuserInfoAPI] params:@{@"userId":user.userId} successBlock:^(id returnData) {
//        
//    } failureBlock:^(NSError *error) {

//    } showHUD:YES];
    
    _valueArray[0] = @"";
    if (user.realName.length > 0) {
        _valueArray[1] = user.realName;
    }else {
        _valueArray[1] = user.userName;
    }
    _valueArray[2] = user.phoneNo;
    _valueArray[3] = user.idCard;
    _valueArray[4] = user.chatName;
    _valueArray[5] = user.bankNum;
    
}

- (void)setupViews {
    
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
//
//    [self setRightTextBarButtonItemWithFrame:CGRectMake(10, 0, 40, 30) title:@"更多" titleColor:[UIColor whiteColor] backImage:nil selectBackImage:nil action:^(AYCButton *button) {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SetUserInfoViewController *setUserInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"setUserInfo"];
//        _isTosetUserInfo = YES;
//        setUserInfoVC.notEnable = YES;
//        setUserInfoVC.rightBtnTitle = @"保存";
//        [weakSelf.navigationController pushViewController:setUserInfoVC animated:YES];
//    }];

    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain    ];
    self.tableView.backgroundColor = [HelperUtil colorWithHexString:@"F4F4F4"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SetUserInfoCell" bundle:nil] forCellReuseIdentifier:@"setUserInfoCell"];
    [self.view addSubview:self.tableView];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        SetUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setUserInfoCell" forIndexPath:indexPath];
        cell.textFiled.hidden = YES;
        cell.label.text = @"头像";
        cell.imageHeight.constant = 40;
        [cell.imageBtn setImage:[UIImage imageNamed:@"head1"]];
        return cell;
    }else if(indexPath.section == 1) {
        static NSString *cell_ID = @"cell_Pwd";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"修改密码";
        return cell;
    }else{
        static NSString *cell_ID = @"cell_ID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_ID];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = _keyArray[indexPath.row];
        NSString *text =  [_valueArray[indexPath.row] length] ? _valueArray[indexPath.row] : @"未填写";
        cell.detailTextLabel.text = text;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60 / 667.0 * KHeight;
    }else {
        return 50 / 667.0 * KHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"verifyCode_push" sender:self];
        _isTosetUserInfo = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
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
