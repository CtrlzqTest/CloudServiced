//
//  ZQCityPickerView.m
//  CloudService
//
//  Created by zhangqiang on 16/3/8.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQCityPickerView.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface ZQCityPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_provinceArray;
    NSArray *_cityArray;
    NSArray *_selectArray;
    NSString *_cityIndex;
    
    hidePickerViewBlock _block;
}

@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *maskView;

@end

@implementation ZQCityPickerView

- (instancetype)initWithProvincesArray:(NSArray *)provinceArray cityArray:(NSArray *)cityArray{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _provinceArray = @[@"北京",@"上海"];
        _cityArray = @[@[@"朝阳",@"昌平",@"大兴"],@[@"浦东",@"闵行",@"南翔"]];
        _selectArray = _cityArray[0];
        self.province = [_provinceArray firstObject];
        self.city = [_selectArray firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.alpha = 0;
    self.maskView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
    [self.maskView addGestureRecognizer:tap];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KHeight + 20, KWidth, KHeight * 7 / 16.0 - 20)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    
    [self addSubview:self.maskView];
    [self addSubview:self.pickerView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
    {
        return _provinceArray.count;
    }else
    {
        return [_cityArray[component] count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return component == 0 ? _provinceArray[row] : _selectArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0)
    {
        _selectArray = _cityArray[row];
        [self.pickerView reloadComponent:1];
    }else
    {
        
    }
    
    self.province = _provinceArray[[self .pickerView selectedRowInComponent:0]];
    self.city = _selectArray[[self.pickerView selectedRowInComponent:1]];
}

- (void)showPickViewAnimated:(hidePickerViewBlock )block {
    
    _block = block;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, - KHeight * 7 / 16.0);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidePickerView {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _block(self.province,self.city);
        [self removeFromSuperview];
    }];
    
}



@end
