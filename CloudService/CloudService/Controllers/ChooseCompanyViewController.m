//
//  ChooseCompanyViewController.m
//  CloudService
//
//  Created by zhangqiang on 16/3/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ChooseCompanyViewController.h"

static NSString *cell_Id = @"cell_Id";
@interface ChooseCompanyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChooseCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cell_Id];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_Id forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
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
