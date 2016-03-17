/**
 !! 随便弄了一下，只是为了 目前项目的使用.过几天会 完善
 !! 加入单例等
 
 有问题可以联系 邮箱 asiosldh@163.com
 QQ               872304636
 
 */


#import "PellTableViewSelect.h"

@interface  PellTableViewSelect()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);

@end



PellTableViewSelect *backgroundView;
UITableView *tableView;

@implementation PellTableViewSelect


- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                selectData:(NSArray *)selectData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    

    

//    backgroundView.backgroundColor = [UIColor colorWithHue:0
//                                                saturation:0
//                                                brightness:0 alpha:0.1];
    backgroundView.backgroundColor = [UIColor clearColor];
    [win addSubview:backgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 10.0f;
    tableView.rowHeight = 40;
    tableView.backgroundColor = [UIColor colorWithWhite:0.695 alpha:1.000];
    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width,frame.size.height);
        }];
    }
}
+ (void)tapBackgroundClick
{
    [PellTableViewSelect hiden];
}
+ (void)hiden
{
    [backgroundView removeFromSuperview];
    [tableView removeFromSuperview];
    tableView = nil;
    backgroundView = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.695 alpha:1.000];
    cell.textLabel.text = _selectData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    [PellTableViewSelect hiden];
}
@end
