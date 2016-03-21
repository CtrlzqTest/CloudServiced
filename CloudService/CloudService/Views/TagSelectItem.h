//
//  TagSelectItem.h
//  CloudService
//
//  Created by zhangqiang on 16/3/21.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagSelectItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

/**
 *  显示删除按钮
 */
- (void)hideDeleteBtn:(BOOL )isHide;

@end
