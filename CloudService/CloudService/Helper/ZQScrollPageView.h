//
//  ZQScrollPageView.h
//  轮播图
//
//  Created by zhangqiang on 15/10/27.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ImageTypeNet = 0,
    ImageTypeBundle = 1,
    ImageTypeLocalPath = 2
} ImageType;

typedef void(^ClickBlock)(NSInteger index);

@interface ZQScrollPageView : UIView

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;

// 开始播放动画
- (void)playWithImageArray:(NSArray *)imageArray TimeInterval:(NSTimeInterval)displayTime imageType:(ImageType )imageType clickImage:(ClickBlock )clickBlock;

/**
 *   暂停
 */
- (void)pause;

/**
 *  开始
 */
- (void)start;
@end
