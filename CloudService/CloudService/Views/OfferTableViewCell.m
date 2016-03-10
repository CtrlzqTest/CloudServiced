//
//  OfferTableViewCell.m
//  CloudService
//
//  Created by 安永超 on 16/2/29.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "OfferTableViewCell.h"
#import "HZQDatePickerView.h"

@interface OfferTableViewCell()<HZQDatePickerViewDelegate>
{
    HZQDatePickerView *_pickerView;
}
@end
@implementation OfferTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.carCode.enabled = NO;
    
}

- (IBAction)tapDateLabel:(id)sender {
    
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    [_pickerView showDateViewWithDelegate:self];
    
}

#pragma mark -- HZQDatePickerViewDelegate
- (void)getSelectDate:(NSDate *)date type:(DateType)type {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];
    self.firstTime.text = currentOlderOneDateStr;
    _pickerView = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
