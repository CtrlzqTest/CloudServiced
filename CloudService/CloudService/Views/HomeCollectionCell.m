//
//  HomeCollectionCell.m
//  CloudService
//
//  Created by zhangqiang on 16/2/26.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "HomeCollectionCell.h"

@interface HomeCollectionCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCanstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@end

@implementation HomeCollectionCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor whiteColor];
    self.topCanstraint.constant = 15.0 / 417 * KWidth;
    self.imgWidth.constant = 40.0 / 417 * KWidth;
    
}

@end
