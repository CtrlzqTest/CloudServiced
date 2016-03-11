//
//  CouponsDistributeCell.h
//  CloudService
//
//  Created by 安永超 on 16/3/8.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsDistributeCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UIImageView *checkImg;
@property (weak, nonatomic)IBOutlet UITapGestureRecognizer *checkTap;
@property (weak, nonatomic)IBOutlet UITextField *tfMoney;
@property (weak, nonatomic)IBOutlet UILabel *lbName;
@end
