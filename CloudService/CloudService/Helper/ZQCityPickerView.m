//
//  ZQCityPickerView.m
//  CloudService
//
//  Created by zhangqiang on 16/3/8.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQCityPickerView.h"
#import "DataSource.h"
#import <FMDB.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface ZQCityPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_provinceArray;
    NSMutableArray *_cityArray;
    NSString *_provinceCode;
    NSDictionary *_provinceCodeDict;
    NSMutableArray *_cityCodeArray;
    
    hidePickerViewBlock _block;
    UIView *_accessInputView;
    
    NSInteger _ComponentsCount;
}

@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *maskView;

@end

@implementation ZQCityPickerView

- (instancetype)initWithProvincesArray:(NSArray *)provinceArray cityArray:(NSArray *)cityArray componentsCount:(NSInteger )count{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    
        _ComponentsCount = count;
        _provinceArray = [DataSource provinceArray];
        _provinceCodeDict = [DataSource provinceCodeDict];
        _provinceCode = [_provinceCodeDict valueForKey:_provinceArray[0]];
        self.province = [_provinceArray firstObject];
        
        if (count != 1) {
            _cityArray = [NSMutableArray array];
            _cityCodeArray = [NSMutableArray array];
            [self searchCityinProvinceCode:_provinceCode];
            self.city = [_cityArray firstObject];
            self.cityCode = [_cityCodeArray firstObject];
        }
        
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    [self.maskView addGestureRecognizer:tap];
    CGFloat accessHeight = 50;
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KHeight + accessHeight, KWidth, KHeight * 3 / 8.0 - accessHeight)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    _accessInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.pickerView.frame) - accessHeight, KWidth, accessHeight)];
//    _accessInputView.hidden = YES;
    _accessInputView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    cancleBtn.frame = CGRectMake(20, 15, 30, 30);
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton *ensureBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    ensureBtn.frame = CGRectMake(KWidth - 20 - 30, 15, 30, 30);
    [ensureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [ensureBtn addTarget:self action:@selector(ensureAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_accessInputView addSubview:cancleBtn];
    [_accessInputView addSubview:ensureBtn];
    
    [self addSubview:self.maskView];
    [self addSubview:self.pickerView];
    [self addSubview:_accessInputView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _ComponentsCount;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
    {
        return _provinceArray.count;
    }else
    {
        return _cityArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return component == 0 ? _provinceArray[row] : _cityArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0)
    {
        _provinceCode = [_provinceCodeDict valueForKey:_provinceArray[row]];
        if (_ComponentsCount != 1) {
            [self searchCityinProvinceCode:_provinceCode];
            [self.pickerView reloadComponent:1];
        }
    }else
    {
        
    }
    self.province = _provinceArray[[self .pickerView selectedRowInComponent:0]];
    if (_ComponentsCount != 1) {
        self.city = _cityArray[[self.pickerView selectedRowInComponent:1]];
        self.cityCode = _cityCodeArray[[self.pickerView selectedRowInComponent:1]];
    }
}

- (void)cancleAction:(UIButton *)sender {
    [self hidePickerViewWithEnsure:NO];
}

- (void)ensureAction:(UIButton *)sender {
    [self hidePickerViewWithEnsure:YES];
}

- (void)showPickViewAnimated:(hidePickerViewBlock )block {
    
    _block = block;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        _accessInputView.transform = CGAffineTransformMakeTranslation(0, - KHeight * 3 / 8.0);
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, - KHeight * 3 / 8.0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePickerViewWithEnsure:(BOOL )flag {
    
    if (_ComponentsCount == 1) {
        self.city = @"";
        self.cityCode = @"";
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        _accessInputView.transform = CGAffineTransformIdentity;
        self.pickerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (flag) {
            _block(self.province,self.city,self.cityCode,_provinceCode);
        }
        [self removeFromSuperview];
    }];
}

- (void)tapMaskView {
    [self hidePickerViewWithEnsure:YES];
}

/**
 *  搜索城市
 *
 *  @param provinceCode 省编码
 *
 *  @return 市
 */
- (void)searchCityinProvinceCode:(NSString *)provinceCode {
    
    [_cityArray removeAllObjects];
    [_cityCodeArray removeAllObjects];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM city where cityCode like '%@%%'",_provinceCode];
    FMResultSet *result = [db executeQuery:sqlStr];
    while ([result next]) {
        NSLog(@"%@",[result stringForColumn:@"cityName"]);
        [_cityArray addObject:[result stringForColumn:@"cityName"]];
        [_cityCodeArray addObject:[result stringForColumn:@"cityCode"]];
    }
    [db close];
}

@end
