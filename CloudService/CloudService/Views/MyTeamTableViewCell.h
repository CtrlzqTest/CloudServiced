//
//  MyTeamTableViewCell.h
//  CloudService
//
//  Created by zhangqiang on 16/2/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamTableViewCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *lbName;
@property (weak, nonatomic)IBOutlet UILabel *lbIdCard;
@property (weak, nonatomic)IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic)IBOutlet UIButton *chatName;
@end
