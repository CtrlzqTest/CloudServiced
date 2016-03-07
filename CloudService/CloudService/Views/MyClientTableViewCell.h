//
//  MyClientTableViewCell.h
//  CloudService
//
//  Created by 安永超 on 16/3/1.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MyClientTableViewCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *lbInfo;
@property (weak, nonatomic)IBOutlet UILabel *lbCustName;
@property (weak, nonatomic)IBOutlet UILabel *lbLicenseNo;

@end
