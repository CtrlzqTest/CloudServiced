//
//  AppointmentViewController.m
//  CloudService
//
//  Created by 安永超 on 16/2/26.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "AppointmentViewController.h"
#import "PlaceholderTextView.h"
#import "PellTableViewSelect.h"
#import "HZQDatePickerView.h"

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface AppointmentViewController ()<HZQDatePickerViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (weak, nonatomic)IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbCode;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
@property (strong, nonatomic)HZQDatePickerView *pickerView;//时间选择器
@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [weakSelf setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 35, 35) image:@"title-back" selectImage:@"back" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.bgView addSubview:self.textView];
    
    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.origin.y + 80 , [UIScreen mainScreen].bounds.size.width - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/50";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.wordCountLabel];
    self.lbCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *codeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeClick:)];
    [self.lbCode addGestureRecognizer:codeTap];
    
    self.lbDate.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateClick:)];
    [self.lbDate addGestureRecognizer:dateTap];
    // Do any additional setup after loading the view.
}

- (void)codeClick:(UITapGestureRecognizer *)tap {
    [self resignKeyBoardInView:self.view];
    NSArray *array = @[@"未报价",@"已报价",@"已完成"];
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(110, 135, 200, 200) selectData:

     array
                                                        action:^(NSInteger index) {
                                                            
                                                            _lbCode.text = [array objectAtIndex:index];
                                                        } animated:YES];
}

- (void)dateClick:(UITapGestureRecognizer *)tap {
    [self resignKeyBoardInView:self.view];
    [self setupDateView:DateTypeOfStart];
}

#pragma mark HZQDatePickerView
- (void)setupDateView:(DateType)type {
    
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, KWidth, KHeight + 20);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    [_pickerView.datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    _pickerView.delegate = self;
    _pickerView.type = type;
    [_pickerView.datePickerView setMinimumDate:[NSDate date]];
    [self.view addSubview:_pickerView];
    
}

- (void)getSelectDate:(NSDate *)date type:(DateType)type {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:date];
    switch (type) {
        case DateTypeOfStart:
            
            self.lbDate.text = currentOlderOneDateStr;
            
            break;
            
            
        default:
            break;
    }
}
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(15, 155, self.view.frame.size.width - 30, 70)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"请输入备注内容";

    }
    
    return _textView;
}

#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/50",(long)wordCount];
    [self wordLimit:textView];
}
#pragma mark 超过50字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 50) {
        NSLog(@"%ld",text.text.length);
        self.textView.editable = YES;
        
    }
    else{
        self.textView.editable = NO;
        
    }
    return nil;
}
- (IBAction)save:(id)sender {
}
/** 消失键盘*/
- (void)resignKeyBoardInView:(UIView *)view

{
    
    for (UIView *v in view.subviews) {
        
        if ([v.subviews count] > 0) {
            
            [self resignKeyBoardInView:v];
            
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            
            [v resignFirstResponder];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
