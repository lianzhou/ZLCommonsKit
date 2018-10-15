//
//  UIScrollView+JZEmptyDataSet.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>


@protocol JZScrollViewEmptyDelegate <UIScrollViewDelegate>

@optional
- (int)scrollViewEmptyCount:(UIScrollView *)scrollView;
- (UIColor *)jz_backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

@end


@interface UIScrollView (JZEmptyDataSet)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) id<JZScrollViewEmptyDelegate> delegate;


@property(nonatomic, copy)dispatch_block_t  emptyViewClickBlock;

/**
 设置空白图
 @param image 图片
 */
- (void)setupEmptyImage:(UIImage *)image;

/**
 * 设置文字,子标题,和图片

 @param text 文字
 @param subText 子标题
 @param image 图片
 */
- (void)setupEmptyDataText:(NSString *)text subText:(NSString *)subText emptyImage:(UIImage *)image;

/**
 * 设置文字,和图片
 
 @param text 文字
 @param image 图片
 */
- (void)setupEmptyDataText:(NSString *)text  emptyImage:(UIImage *)image;

/**
 * 设置文字,和图片
 
 @param subText 子标题
 @param image 图片
 */
- (void)setupEmptyDatasubText:(NSString *)subText  emptyImage:(UIImage *)image;

/**
 * 设置空白页的文字

 @param text 文字
 */
- (void)setupEmptyDataText:(NSString *)text;

/**
 *设置空白页的文字和偏移量

 @param text 文字
 @param offset 偏移量
 */
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset;

/**
 *设置空白页的文字、偏移量和图片

 @param text 文字
 @param offset 偏移量
 @param image 图片
 */
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image;

/**
 !空白页面

 @param text 空数据内容
 @param subText 空数据内容
 @param offset 垂直偏移量
 @param image 空数据的图片
 */
- (void)setupEmptyDataText:(NSString *)text subText:(NSString *)subText verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image;

/**
 空白页面的点击事件

 @param buttonText 按钮的文字
 @param buttonimage 按钮的图片
 @param buttonClickBlock 按钮的点击事件
 */
- (void)setupEmptyButtonText:(NSString *)buttonText emptyButtonImage:(UIImage *)buttonimage tapBlock:(dispatch_block_t)buttonClickBlock;


/**
 空白页面button的点击事件

 @param buttonText 按钮的文字
 @param buttonimage 按钮的图片
 @param titleColor 按钮字体的颜色
 @param buttonClickBlock 按钮的点击事件
 */
- (void)setupEmptyButtonText:(NSString *)buttonText emptyButtonImage:(UIImage *)buttonimage emptyButtonTitleColor:(UIColor *)titleColor tapBlock:(dispatch_block_t)buttonClickBlock;

- (void)reloadJZEmptyDataSet;

@end
