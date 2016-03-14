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

static NSString *cellID = @"cellID";
@interface ActivityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

{
    ActifityModel *actifityModel;
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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsCompact];
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
//    self.collectionView.showsHorizontalScrollIndicator = NO;
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
    
    if (scrollView.contentOffset.x == 0.00f) {
        self.button1.layer.borderColor = [[UIColor redColor] CGColor];
        self.button2.layer.borderColor = [[UIColor clearColor] CGColor];
        self.button3.layer.borderColor = [[UIColor clearColor] CGColor];
    }else if (scrollView.contentOffset.x == 265.00f) {
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
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"home5"] forState:(UIControlStateNormal)];
        self.btnNum2.hidden = NO;
        [self.btnNum2 setTitle:actifityModel.monkeyTwo forState:(UIControlStateNormal)];
    }else {
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"home5_"] forState:(UIControlStateNormal)];
        self.btnNum2.hidden = YES;
    }
    
    if (![actifityModel.monkeyThree isEqualToString:@"0"]) {
        [self.button3 setBackgroundImage:[UIImage imageNamed:@"home6"] forState:(UIControlStateNormal)];
        self.btnNum3.hidden = NO;
        [self.btnNum3 setTitle:actifityModel.monkeyThree forState:(UIControlStateNormal)];
    }else {
        [self.button3 setBackgroundImage:[UIImage imageNamed:@"home6_"] forState:(UIControlStateNormal)];
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
            [MBProgressHUD showMessag:returnData[@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}

- (IBAction)shareAction:(id)sender {
    
    
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
