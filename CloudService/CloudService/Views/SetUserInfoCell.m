//
//  SetUserInfoCell.m
//  CloudService
//
//  Created by zhangqiang on 16/2/24.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SetUserInfoCell.h"

@interface SetUserInfoCell()<UITextFieldDelegate>


@end
@implementation SetUserInfoCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textFiled.delegate = self;
}

- (void)isPullDown:(BOOL )pullDown {
    if (pullDown) {
        self.textFiled.enabled = NO;
        self.imageBtn.hidden = NO;
    }else {
        self.textFiled.enabled = YES;
        self.imageBtn.hidden = YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFiledShouldBeginEditAtCell:)]) {
        [self.delegate textFiledShouldBeginEditAtCell:self];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFiledDidEndEdit:)]) {
        [self.delegate textFiledDidEndEdit:textField.text];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
