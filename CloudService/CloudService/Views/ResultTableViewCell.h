//
//  ResultTableViewCell.h
//  CloudService
//
//  Created by 安永超 on 16/2/25.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *lbName;
@property (weak, nonatomic)IBOutlet UILabel *lbIdCard;
@property (weak, nonatomic)IBOutlet UILabel *lbOrderNum;
@property (weak, nonatomic)IBOutlet UILabel *lbTotalPremium;
@end
