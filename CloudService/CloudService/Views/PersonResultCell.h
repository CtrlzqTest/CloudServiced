//
//  PersonResultCell.h
//  CloudService
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonResultCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UILabel *lbOrderNum;
@property (nonatomic, weak)IBOutlet UILabel *lbTotalPremium;
@property (nonatomic, weak)IBOutlet UIButton *resultTime;
@end
