//
//  TagSelectItem.m
//  CloudService
//
//  Created by zhangqiang on 16/3/21.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TagSelectItem.h"

@implementation TagSelectItem

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.layer.borderWidth = 0.5;
    self.titleLabel.layer.cornerRadius = 3;
    self.titleLabel.layer.borderColor = [UIColor colorWithWhite:0.766 alpha:1.000].CGColor;
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.deleteBtn.hidden = YES;
}

- (void)deleteAction {
    
}

- (void)hideDeleteBtn:(BOOL )isHide {
    self.deleteBtn.hidden = isHide;
}

@end
