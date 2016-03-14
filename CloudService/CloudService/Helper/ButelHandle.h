//
//  ButelHandle.h
//  CloudService
//
//  Created by 安永超 on 16/3/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButelHandle : NSObject

+ (ButelHandle *)shareButelHandle;
- (void)initCallViewWithFrame:(CGRect )frame;
- (void)isHidden:(BOOL)hidden tel:(NSString *)telNum;
@end
