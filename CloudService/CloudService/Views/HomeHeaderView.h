//
//  HomeHeaderView.h
//  CloudService
//
//  Created by zhangqiang on 15/1/2.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger index);

@interface HomeHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *pageScrBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sginBtn;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeght;


- (void)playWithImageArray:(NSArray *)imgStrArray clickAtIndex:(ClickBlock )tapIndex;
- (void)setDataWithDictionary:(NSDictionary *)dict;


@end
