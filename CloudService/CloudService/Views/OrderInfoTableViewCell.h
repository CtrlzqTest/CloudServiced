//
//  OrderInfoTableViewCell.h
//  CloudService
//
//  Created by 安永超 on 16/2/26.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoTableViewCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *lbOrderNum;//订单号
@property (weak, nonatomic)IBOutlet UILabel *lbCustName;//客户姓名
@property (weak, nonatomic)IBOutlet UILabel *lbPhoneNo;//手机号
@property (weak, nonatomic)IBOutlet UILabel *lbLicenseNo;//车牌号
@property (weak, nonatomic)IBOutlet UILabel *lbEndCode;//结束码
@property (weak, nonatomic)IBOutlet UIButton *callBtn;//拨打
@property (weak, nonatomic)IBOutlet UIButton *priceBtn;//报价
@property (weak, nonatomic)IBOutlet UIButton *appointmentBtn;//预约
@property (weak, nonatomic)IBOutlet UIButton *giftBtn;//投保礼
@property (weak, nonatomic)IBOutlet UIButton *remarkBtn;//备注


@end
