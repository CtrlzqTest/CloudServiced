//
//  OrderManagerCell.h
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderManagerCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *lbLicenseNo;
@property (weak, nonatomic)IBOutlet UIButton *btnOrderStatus;
@property (weak, nonatomic)IBOutlet UILabel *lbCustomerName;
@property (weak, nonatomic)IBOutlet UILabel *lbBiPremium;
@property (weak, nonatomic)IBOutlet UILabel *lbCiPremium;
@property (weak, nonatomic)IBOutlet UILabel *lbVehicleTaxPremium;
@end
