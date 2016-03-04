//
//  YWBCityPickerView.h
//  ChooseCityTest
//
//  Created by Hey Eleven on 16/1/8.
//  Copyright © 2016年 Hey Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YWBCityPickerView : UIView

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;

- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;

@end
