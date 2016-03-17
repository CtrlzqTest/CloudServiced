//
//  SetUserInfoCell2.h
//  CloudService
//
//  Created by zhangqiang on 16/3/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetUserInfoCell2;

@protocol SetUserInfoCell2Delegate <NSObject>
-(void)didDeleteTextForCompany:(SetUserInfoCell2 *)cell;
@end

@interface SetUserInfoCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidth;

@property(nonatomic,assign) id<SetUserInfoCell2Delegate> delegate;

- (void)isPullDown:(BOOL )pullDown;
/**
 *  添加删除图片
 */
- (void)setDeleteImage:(BOOL )isDelete;
@end
