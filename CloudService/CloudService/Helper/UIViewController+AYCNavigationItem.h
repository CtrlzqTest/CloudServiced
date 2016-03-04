//
//  UIViewController+AYCNavigationItem.h
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/12/7.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYCButton;
@interface UIViewController (AYCNavigationItem)
/** 设置导航条背景 */
-(void)setNavigationBarBackgroundImage:(NSString *)image;
/** 设置标题字体颜色 */
- (void)setNavigationBarTitleColor:(UIColor *)color;
/** 设置导航条中间标题 */
/** 文字标题 */
-(id)setTextTitleViewWithFrame:(CGRect)frame
                         title:(NSString *)titile
                      fontSize:(int)size;
/** 图片标题 */
-(id)setImageTitleViewWithFrame:(CGRect)frame
                          image:(NSString *)image;
/** 选项卡标题 */
-(id)setSegmentTitleViewWithItems:(NSArray *)items;

/** 设置导航条左边按钮 */
/** 既有图标又有文字的左边按钮 */
-(id)setLeftBarButtonItemWithFrame:(CGRect)frame
                             title:(NSString *)titile
                        titleColor:(UIColor *)titleColor
                             image:(NSString *)image
                       imageInsets:(UIEdgeInsets)insets
                         backImage:(NSString *)backImage
                   selectBackImage:(NSString *)selectBackImage
                            action:(void(^)(AYCButton *button))action;
/** 只有图片的左边按钮 */
-(id)setLeftImageBarButtonItemWithFrame:(CGRect)frame
                                  image:(NSString *)image
                            selectImage:(NSString *)selectImage
                                 action:(void(^)(AYCButton *button))action;
/** 只有文字的左边按钮 */
-(id)setLeftTextBarButtonItemWithFrame:(CGRect)frame
                                 title:(NSString *)titile
                            titleColor:(UIColor *)titleColor
                             backImage:(NSString *)backImage
                       selectBackImage:(NSString *)selectBackImage
                                action:(void(^)(AYCButton *button))action;


/** 设置导航条右边按钮 */
/** 既有图标又有文字的右边按钮 */
-(id)setRightBarButtonItemWithFrame:(CGRect)frame
                              title:(NSString *)titile
                         titleColor:(UIColor *)titleColor
                              image:(NSString *)image
                        imageInsets:(UIEdgeInsets)insets
                          backImage:(NSString *)backImage
                    selectBackImage:(NSString *)selectBackImage
                             action:(void(^)(AYCButton *button))action;

/** 只有图片的右边按钮 */
-(id)setRightImageBarButtonItemWithFrame:(CGRect)frame
                                   image:(NSString *)image
                             selectImage:(NSString *)selectImage
                                  action:(void(^)(AYCButton *button))action;

/** 只有文字的右边按钮 */
-(id)setRightTextBarButtonItemWithFrame:(CGRect)frame
                                  title:(NSString *)titile
                             titleColor:(UIColor *)titleColor
                              backImage:(NSString *)backImage
                        selectBackImage:(NSString *)selectBackImage
                                 action:(void(^)(AYCButton *button))action;
@end
