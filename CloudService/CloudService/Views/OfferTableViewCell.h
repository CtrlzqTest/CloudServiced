//
//  OfferTableViewCell.h
//  CloudService
//
//  Created by 安永超 on 16/2/29.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *carCode;
@property (weak, nonatomic) IBOutlet UITextField *engine;
@property (weak, nonatomic) IBOutlet UITextField *carFrameCode;
@property (weak, nonatomic) IBOutlet UITextField *engineType;
@property (weak, nonatomic) IBOutlet UITextField *firstTime;
@property (weak, nonatomic) IBOutlet UITextField *carUserName;
@property (weak, nonatomic) IBOutlet UITextField *carUserCard;
@property (weak, nonatomic) IBOutlet UITextField *carUserPhone;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectBtn;

@end
