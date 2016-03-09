//
//  YWBCityPickerView.m
//  ChooseCityTest
//
//  Created by Hey Eleven on 16/1/8.
//  Copyright © 2016年 Hey Eleven. All rights reserved.
//

#import "YWBCityPickerView.h"

@interface YWBCityPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSMutableArray *provinces;//省
@property (nonatomic, copy) NSMutableArray *cityArray;//市
@property (nonatomic, copy) NSMutableArray *areaArray;//县

@property (nonatomic, copy) NSMutableArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation YWBCityPickerView

- (instancetype)init {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        self.pickerView = [[UIPickerView alloc]initWithFrame:self.bounds];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self addSubview:_pickerView];
        
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        NSArray *provinceArray = [[NSArray alloc]initWithContentsOfFile:path];
        [provinceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.provinces];
            [temp addObject:obj[@"state"]];
            
            self.provinces = temp;
        }];
        
        NSMutableArray *citys =[NSMutableArray arrayWithArray:[provinceArray firstObject][@"cities"]];
        [citys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.cityArray];
            [temp addObject:obj[@"city"]];
            
            self.cityArray = temp;
        }];
        
        self.areaArray = [NSMutableArray arrayWithArray:[citys firstObject][@"areas"]];
        
        self.province = [self.provinces firstObject];
        self.city = [self.cityArray firstObject];
        self.area = 0 == self.areaArray.count ? @"" : [self.areaArray firstObject];
    }
    return self;
}

#pragma mark --
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
//    return 0 == component ? self.provinces.count : 1 == component ? self.cityArray.count : self.areaArray.count;
    if (component == 0) {
        return self.provinces.count;
    }else {
        return self.cityArray.count;
    }
}

#pragma mark -- UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *provinceArray = [[NSArray alloc]initWithContentsOfFile:path];
    
    if (0 == component) {
        
        self.selectedArray = provinceArray[row][@"cities"];
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.cityArray];
        [temp removeAllObjects];
        self.cityArray = temp;
        
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.cityArray];
            [temp addObject:obj[@"city"]];
            
            self.cityArray = temp;
        }];
        
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray firstObject][@"areas"]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (1 == component) {
        
        if (0 == self.selectedArray.count) {
            self.selectedArray = [provinceArray firstObject][@"cities"];
        }
        
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray objectAtIndex:row][@"areas"]];
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    NSInteger provinces = [_pickerView selectedRowInComponent:0];
    NSInteger city = [_pickerView selectedRowInComponent:1];
//    NSInteger area = [_pickerView selectedRowInComponent:2];
    
    self.province = self.provinces[provinces];
    self.city = self.cityArray[city];
//    self.area = 0 == self.areaArray.count ? @"" : self.areaArray[area];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return 0 == component ? self.provinces[row] : 1 == component ? self.cityArray[row] : 0 == self.areaArray.count ? nil : self.areaArray[row];
}

#pragma mark -- show and hidden
- (void)showInView:(UIView *)view {
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hiddenPickerView {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark -- setter getter
- (NSMutableArray *)provinces {
    if (!_provinces) {
        self.provinces = [@[] mutableCopy];
    }
    return _provinces;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        self.cityArray = [@[] mutableCopy];
    }
    return _cityArray;
}

- (NSMutableArray *)areaArray {
    if (!_areaArray) {
        self.areaArray = [@[] mutableCopy];
    }
    return _areaArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}

@end
