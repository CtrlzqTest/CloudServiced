//
//  ChooseCompanyViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ChooseCompanyViewController.h"
#import "HeaderCompanyView.h"
#import "TagSelectItem.h"
#import "CodeNameModel.h"

static NSString *cell_Id = @"cell_Id";
static NSString *header_Id = @"header_Id";
@interface ChooseCompanyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChooseCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 25, 25) image:@"title-back" selectImage:@"" action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChooseSaleCompany object:nil];
    }];
    
    CGFloat inset = 8;
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.minimumInteritemSpacing = inset;
    flowLayOut.minimumLineSpacing = 1 * inset;
    flowLayOut.sectionInset = UIEdgeInsetsMake(inset / 2.0, inset, inset / 2.0, inset);
    flowLayOut.itemSize = CGSizeMake(80, 50);
    flowLayOut.headerReferenceSize = CGSizeMake(375, 30);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TagSelectItem" bundle:nil] forCellWithReuseIdentifier:cell_Id];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.collectionViewLayout = flowLayOut;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCompanyView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header_Id];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? _selectArray.count : _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TagSelectItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_Id forIndexPath:indexPath];
    CodeNameModel *model = indexPath.section == 0 ? _selectArray[indexPath.row] : _dataArray[indexPath.row];
    cell.titleLabel.text = model.companyName;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HeaderCompanyView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header_Id forIndexPath:indexPath];
    NSString *str = indexPath.section == 0 ? @"销售数据城市" : @"选择城市";
    headerView.title = str;
    return headerView;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *toIndexPath = nil;
    NSString *selectObject = nil;
    if (indexPath.section == 0) {
        toIndexPath = [NSIndexPath indexPathForItem:_dataArray.count inSection:1];
        selectObject = _selectArray[indexPath.row];
        [_selectArray removeObjectAtIndex:indexPath.row];
        [_dataArray addObject:selectObject];
    }else {
        toIndexPath = [NSIndexPath indexPathForItem:_selectArray.count inSection:0];
        selectObject = _dataArray[indexPath.row];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_selectArray addObject:selectObject];
    }
    [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
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
