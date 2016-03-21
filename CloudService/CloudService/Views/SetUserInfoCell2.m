//
//  SetUserInfoCell2.m
//  CloudService
//
//  Created by zhangqiang on 16/3/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SetUserInfoCell2.h"

@interface SetUserInfoCell2()
{
    BOOL _flag;
}
@end

@implementation SetUserInfoCell2

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)]];
}

- (void)tapImageAction:(UITapGestureRecognizer *)gesture {
    if (!_flag) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didDeleteTextForCompany:)]) {
        [self.delegate didDeleteTextForCompany:self];
    }
    self.contentLabel.text = @"";
}

- (void)setDeleteImage:(BOOL )isDelete {
    
    _flag = isDelete;
    if (isDelete) {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"delete"];
    }else{
        [self.imgView setImage:[UIImage imageNamed:@"details-arrow2"]];
    }
}



- (void)isPullDown:(BOOL )pullDown {
    if (pullDown) {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"details-arrow2"];
    }else {
        self.imgView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
