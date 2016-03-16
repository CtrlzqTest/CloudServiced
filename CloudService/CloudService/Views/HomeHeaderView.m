//
//  HomeHeaderView.m
//  CloudService
//
//  Created by zhangqiang on 15/1/2.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "HomeHeaderView.h"
#import "ZQScrollPageView.h"


@interface HomeHeaderView()
{
    NSString *str;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLabelWidth;

@end

@implementation HomeHeaderView {
    ZQScrollPageView *_scrollPageView;
}

- (void)awakeFromNib {
    
    _scrollPageView = [[ZQScrollPageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 240 * KHeight / 667.0 - 75 * KHeight / 667.0)];
    self.imgSize.constant = 55 / 667.0 * KHeight;
    self.infoViewHeght.constant = 75 * KHeight / 667.0;
    [self.pageScrBackView addSubview:_scrollPageView];
    
}

- (void)setDataWithDictionary:(NSDictionary *)dict {
    self.userNameLabel.text = dict[@"userName"];
    CGSize size = [self.userNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    self.userLabelWidth.constant = size.width + 5;
    [self setNeedsUpdateConstraints];
}

- (void)playWithImageArray:(NSArray *)imgStrArray clickAtIndex:(ClickBlock )tapIndex {
    
    if (!str) {
        [_scrollPageView playWithImageArray:imgStrArray TimeInterval:5 imageType:ImageTypeBundle clickImage:tapIndex];
    }
    str = @"执行";
}

-(void)layoutSubviews {
    
    
}

@end
