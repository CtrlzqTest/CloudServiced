//
//  SetUserInfoCell.h
//  CloudService
//
//  Created by zhangqiang on 16/2/24.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetUserInfoCell;

@protocol SetUserInfoCellDelegate <NSObject>
-(void)textFiledShouldBeginEditAtCell:(SetUserInfoCell *)cell;
-(void)textFiledDidEndEdit:(NSString *)text;
@end

@interface SetUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIImageView *imageBtn;
@property(nonatomic,assign) id<SetUserInfoCellDelegate> delegate;
@end
