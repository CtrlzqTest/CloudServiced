//
//  User.h
//  OnePage
//
//  Created by zhangqiang on 15/12/8.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,copy)NSString *NAME;
@property(nonatomic,copy)NSString *PASSWORD;
@property(nonatomic,copy)NSString *SEX;
@property(nonatomic,copy)NSString *USERNAME;
@property(nonatomic,copy)NSString *LAST_LOGIN;
@property(nonatomic,copy)NSString *USER_ID;

- (NSDictionary *)dictionaryWithModel:(User *)user;

@end
