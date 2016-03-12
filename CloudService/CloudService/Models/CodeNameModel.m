//
//  CodeNameModel.m
//  CloudService
//
//  Created by zhangqiang on 16/3/12.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CodeNameModel.h"

@implementation CodeNameModel

- (NSDictionary *)dictionaryWithModel:(CodeNameModel *)codeNameModel {
    
    return [codeNameModel mj_keyValues];
    
}

@end
