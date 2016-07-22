//
//  InviteFriendViewController.m
//  CloudService
//
//  Created by zhangqiang on 15/1/2.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "InviteFriendViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface InviteFriendViewController ()
{
    NSString *_linkUrl;
    NSString *_personInviteCode;
    NSString *_teamInviteCode;
}
@property (weak, nonatomic)IBOutlet UIImageView *qrImgView;
@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请";
    [self setUpInviteLink];
  
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}
- (void)setUpInviteLink {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,kfindInviteLink];
    User *user = [[SingleHandle shareSingleHandle] getUserInfo];
    [MHNetworkManager postReqeustWithURL:url params:@{@"userId":user.userId} successBlock:^(id returnData) {
        
        if ([[returnData objectForKey:@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dataDic = [returnData objectForKey:@"data"];
            _linkUrl = [dataDic objectForKey:@"inviteLink"];
            _personInviteCode = [dataDic objectForKey:@"personInviteCode"];
            _teamInviteCode = [dataDic objectForKey:@"teamInviteCode"];
            
        }else {
            [MBProgressHUD showMessag:[returnData objectForKey:@"msg"] toView:self.view];
        }
        
    } failureBlock:^(NSError *error) {
      
        
    } showHUD:NO];

}

- (IBAction)shareAction:(id)sender {
    
    if (_linkUrl.length <= 0) {
        [MBProgressHUD showMessag:@"生成邀请url失败" toView:self.view];
        return;
    }
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"sharLogo"]];
        if (imageArray) {
            NSString *content = nil;
            if (self.isTeamInvite) {
                content = [NSString stringWithFormat:@"诚心邀请您加入云客服，送万元梦想基金\n团队邀请码:%@",_teamInviteCode];
            }else {
                content = [NSString stringWithFormat:@"诚心邀请您加入云客服，送万元梦想基金\n个人邀请码:%@",_personInviteCode];
            }
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
