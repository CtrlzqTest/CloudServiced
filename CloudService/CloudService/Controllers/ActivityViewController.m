//
//  ActivityViewController.m
//  CloudService
//
//  Created by 安永超 on 16/3/12.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ActivityViewController.h"
#import "HoriCardFlowLayout2.h"
#import "ActivityCollectionCell.h"
#import "ActifityModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "RuleViewController.h"

static NSString *cellID = @"cellID";
@interface ActivityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

{
    ActifityModel *actifityModel;
    NSString *_linkUrl;

    NSString *_personInviteCode;
}

@property (strong, nonatomic)UICollectionView *collectionView;
@property (weak, nonatomic)IBOutlet UIButton *button1;
@property (weak, nonatomic)IBOutlet UIButton *button2;
@property (weak, nonatomic)IBOutlet UIButton *button3;
@property (weak, nonatomic)IBOutlet UIButton *btnNum1;
@property (weak, nonatomic)IBOutlet UIButton *btnNum2;
@property (weak, nonatomic)IBOutlet UIButton *btnNum3;
@property (weak, nonatomic) IBOutlet UIButton *getCoupon;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end


@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [weakSelf setRightTextBarButtonItemWithFrame:CGRectMake(0, 0, 70, 25) title:@"活动规则" titleColor:[UIColor whiteColor] backImage:@"" selectBackImage:@"" action:^(AYCButton *button) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RuleViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"RuleVC"];
        vc.ruleStr = @"活动1";
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsCompact];
    [self setUpInviteLink];
    [self setupCollectionView];
    [self setupBtnNum];
    [self setupButton];
    [self requestData];
}

- (void)requestData {
    
    __weak typeof(self) weakSelf = self;
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kActifityInfoAPI] params:@{@"userId":user.userId} successBlock:^(id returnData) {
        
        actifityModel= [ActifityModel mj_objectWithKeyValues:returnData[@"data"]];
        // 刷新数据
        [weakSelf.collectionView reloadData];
        [weakSelf reloadViews];
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
    // 获取邀请码
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kfindInviteLink] params:@{@"userId":[[SingleHandle shareSingleHandle] getUserInfo].userId} successBlock:^(id returnData) {
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [returnData objectForKey:@"data"];
            _linkUrl = [dataDic objectForKey:@"inviteLink"];
            _personInviteCode = [dataDic objectForKey:@"personInviteCode"];
            
        }else {
            [MBProgressHUD showError:[returnData objectForKey:@"msg"] toView:self.view];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
}

- (void)setupButton {
    self.button1.layer.borderWidth = 1.5f;
    self.button1.layer.borderColor = [[UIColor redColor] CGColor];
    [self.button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.layer.borderWidth = 1.5f;
    self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
    [self.button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
    self.button3.layer.borderWidth = 1.5f;
    self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    [self.button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBtnNum {
    self.btnNum1.layer.borderWidth = 1.5f;
    self.btnNum1.layer.borderColor = [[UIColor redColor] CGColor];
    self.btnNum2.layer.borderWidth = 1.5f;
    self.btnNum2.layer.borderColor = [[UIColor redColor] CGColor];
    self.btnNum3.layer.borderWidth = 1.5f;
    self.btnNum3.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setupCollectionView {
    
    HoriCardFlowLayout2 *layout = [[HoriCardFlowLayout2 alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, KWidth, KHeight - 250) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ActivityCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
//    self.collectionView.pagingEnabled = YES;
 
    self.collectionView.decelerationRate = 0.5;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KWidth, 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:self.collectionView];
    
  
}
#pragma mark collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    if (cell==nil) {
//        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"ActivityCollectionCell" owner:self options:nil];
//        cell=[array objectAtIndex:0];
//    }
    
    if (!actifityModel) {
        return cell;
    }
    switch (indexPath.row) {
        case 0:
            if (![actifityModel.monkeyOne isEqualToString:@"0"]) {
                cell.imgView.image = [UIImage imageNamed:@"card1"];
            }else {
                cell.imgView.image = [UIImage imageNamed:@"card1_"];
            }
            break;
        case 1:
            if (![actifityModel.monkeyTwo isEqualToString:@"0"]) {
                cell.imgView.image = [UIImage imageNamed:@"card2"];
            }else {
                cell.imgView.image = [UIImage imageNamed:@"card2_"];
            }
            break;
        case 2:
            if (![actifityModel.monkeyThree isEqualToString:@"0"]) {
                cell.imgView.image = [UIImage imageNamed:@"card3"];
            }else {
                cell.imgView.image = [UIImage imageNamed:@"card3_"];
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            self.button1.layer.borderColor = [[UIColor redColor] CGColor];
            self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
            self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
            break;
        case 1:
            self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
            self.button2.layer.borderColor = [[UIColor redColor] CGColor];
            self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
            break;
        case 2:
            self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
            self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
            self.button3.layer.borderColor = [[UIColor redColor] CGColor];
            break;
            
        default:
            break;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSLog(@"%.2f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x == 0.00f) {
        self.button1.layer.borderColor = [[UIColor redColor] CGColor];
        self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
        self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    }else if (scrollView.contentOffset.x == KWidth - 110) {
        self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
        self.button2.layer.borderColor = [[UIColor redColor] CGColor];
        self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    }else  {
        self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
        self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
        self.button3.layer.borderColor = [[UIColor redColor] CGColor];
    }
  
}

// 刷新数据
- (void)reloadViews {
    
    if (![actifityModel.monkeyOne isEqualToString:@"0"]) {
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"home4"] forState:(UIControlStateNormal)];
        [self.btnNum1 setTitle:actifityModel.monkeyOne forState:(UIControlStateNormal)];
        self.btnNum1.hidden = NO;
    }else {
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"home4_"] forState:(UIControlStateNormal)];
        self.btnNum1.hidden = YES;
    }
    
    if (![actifityModel.monkeyTwo isEqualToString:@"0"]) {
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"home6"] forState:(UIControlStateNormal)];
        self.btnNum2.hidden = NO;
        [self.btnNum2 setTitle:actifityModel.monkeyTwo forState:(UIControlStateNormal)];
    }else {
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"home6_"] forState:(UIControlStateNormal)];
        self.btnNum2.hidden = YES;
    }
    
    if (![actifityModel.monkeyThree isEqualToString:@"0"]) {
        [self.button3 setBackgroundImage:[UIImage imageNamed:@"home5"] forState:(UIControlStateNormal)];
        self.btnNum3.hidden = NO;
        [self.btnNum3 setTitle:actifityModel.monkeyThree forState:(UIControlStateNormal)];
    }else {
        [self.button3 setBackgroundImage:[UIImage imageNamed:@"home5_"] forState:(UIControlStateNormal)];
        self.btnNum3.hidden = YES;
    }
    
    if (![actifityModel.sendCoupon isEqualToString:@"0"]) {
        self.getCoupon.enabled = NO;
//        [self.getCoupon setBackgroundColor:[UIColor grayColor]];
    }
    
}

- (void)button1:(UIButton *)sender {
    self.button1.layer.borderColor = [[UIColor redColor] CGColor];
    self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
    self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)button2:(UIButton *)sender {
    self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
    self.button2.layer.borderColor = [[UIColor redColor] CGColor];
    self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)button3:(UIButton *)sender {
    self.button1.layer.borderColor = [[UIColor clearColor] CGColor];
    self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
    self.button3.layer.borderColor = [[UIColor redColor] CGColor];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)getCouponAction:(id)sender {
    
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    [MHNetworkManager postReqeustWithURL:[RequestEntity urlString:kActifityCouponAPI] params:@{@"userId":user.userId} successBlock:^(id returnData) {
        
        if ([returnData[@"flag"] isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"成功领取优惠券,请到个人中心查看" toView:self.view];
        }else {
            [MBProgressHUD showMessag:@"你还没有集齐所有猴子，请再接再厉" toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}
- (void)setUpInviteLink {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindInviteLink];
    
    [MHNetworkManager postReqeustWithURL:url params:nil successBlock:^(id returnData) {
        
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            _linkUrl = [returnData objectForKey:@"data"];
        
            
        }else {
            [MBProgressHUD showError:[returnData objectForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}
- (IBAction)shareAction:(id)sender {
    if (!_linkUrl) {
        [MBProgressHUD showError:@"生成邀请url失败" toView:self.view];
        return;
    }
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"sharLogo"]];
    if (imageArray) {
        NSString *content = [NSString stringWithFormat:@"诚心邀请您加入云客服，参加集猴纳财活动，送万元梦想基金\n邀请码:%@",_personInviteCode];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:_linkUrl]
                                          title:@"云客服"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
        
    }

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
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
