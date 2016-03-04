//
//  SetUserInfoHeaderView.m
//  CloudService
//
//  Created by zhangqiang on 16/2/24.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SetUserInfoHeaderView.h"
#import <Masonry.h>

@implementation SetUserInfoHeaderView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews {
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.919 alpha:1.000];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.000 green:0.548 blue:0.000 alpha:1.000];
    [self addSubview:lineView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLabel];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(7.5);
        make.bottom.equalTo(self).with.offset(-7.5);
        make.width.mas_equalTo(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(self).with.offset(5);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
