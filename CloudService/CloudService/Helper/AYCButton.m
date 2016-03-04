//
//  AYCButton.m
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/12/7.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import "AYCButton.h"

@implementation AYCButton

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
-(void)btnClick:(AYCButton *)button
{
    //作用: 原来被点击执行target-action对应的方法
    //现在: 判断action是否已经设置block, 如果被设置, 执行block
    if(self.action)
    {
        self.action(button);
    }
}


@end
