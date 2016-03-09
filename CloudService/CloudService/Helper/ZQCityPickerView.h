//
//  ZQCityPickerView.h
//  CloudService
//
//  Created by zhangqiang on 16/3/8.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hidePickerViewBlock)(NSString *province,NSString *city);

@interface ZQCityPickerView : UIView

@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *province;

- (instancetype)initWithProvincesArray:(NSArray *)provinceArray cityArray:(NSArray *)cityArray;

/**
 *  显示
 */
- (void)showPickViewAnimated:(hidePickerViewBlock )block;

@end
