//
//  PersonalViewCell.m
//  CloudService
//
//  Created by zhangqiang on 16/2/26.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PersonalViewCell.h"

@interface PersonalViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation PersonalViewCell

- (void)awakeFromNib {
    // Initialization code
    self.top.constant = 5 * KHeight / 667;
    self.bottom.constant = 5 * KHeight / 667;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
