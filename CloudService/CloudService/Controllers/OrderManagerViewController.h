//
//  OrderManagerViewController.h
//  CloudService
//
//  Created by 安永超 on 16/2/23.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import <LazyPageScrollView.h>

@interface OrderManagerViewController : BaseViewController
@property (strong, nonatomic) IBOutlet LazyPageScrollView *pageView;
@end
