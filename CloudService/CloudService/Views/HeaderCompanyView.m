//
//  HeaderCompanyView.m
//  测试
//
//  Created by zhangqiang on 16/3/21.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "HeaderCompanyView.h"

@interface HeaderCompanyView()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HeaderCompanyView

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTitle:(NSString *)title {
    self.label.text = title;
}

@end
