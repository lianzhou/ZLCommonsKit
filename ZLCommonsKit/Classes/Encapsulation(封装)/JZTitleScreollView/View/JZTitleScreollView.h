//
//  TitleScreollView.h
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JZTitleAnimationType) {
    JZTitleAnimationTypeDefault,               //默认
    JZTitleAnimationTypeOnlyColor,             //颜色
    JZTitleAnimationTypeOnlyLine,              //加线
    JZTitleAnimationTypeTransformScale,        //缩放
    JZTitleAnimationTypeColorAndLine,          //颜色加线
    JZTitleAnimationTypeCustom,                //自定义
    
};
typedef NS_ENUM(NSInteger, JZTitleLineWidthType) {
    JZTitleLineWidthTypeEqualCellFrame,          //cell宽度
    JZTitleLineWidthTypeEqualSubViewFrame,       //cell上子视图宽度
    JZTitleLineWidthTypeFixedWidth,              //固定宽度(和lineViewWidth配合使用)
    JZTitleLineWidthTypeDynamicWidth,            //动态宽度(和lineViewWidth配合使用)
};

@class JZTitleScreollView;

@protocol JZTitleScreollViewDelegate <NSObject>

@optional

/**
 *  单元格选中
 */
- (void)JZtitleScreollView:(JZTitleScreollView *)scrollView CollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  配置cell方法自定义动画
 */
- (void)JZtitleScreollView:(JZTitleScreollView *)scrollView CollectionView:(UICollectionView *)collectionView animationCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JZTitleScreollView : UIView

/**
 *  标题颜色
 */
@property (nonatomic ,retain)UIColor                *titleColor;
/**
 *  标题选中颜色
 */
@property (nonatomic ,retain)UIColor                *titleSelectColor;
/**
 *  标题大小
 */
@property (nonatomic ,retain)UIFont                 *titleFont;
/**
 *  标题选中大小
 */
@property (nonatomic ,retain)UIFont                 *titleSelectFont;
/**
 *  底部线的颜色
 */
@property (nonatomic ,retain)UIColor                *lineColor;
/**
 *  字体选中缩放比
 */
@property (nonatomic ,assign)CGAffineTransform      selectSclae;
/**
 *  底部线宽
 */
@property (nonatomic ,assign)CGFloat                lineViewWidth;
/**
 *  cell线宽
 */
@property (nonatomic ,assign)CGFloat                cellWidth;
/**
 *  动画类型
 */
@property (nonatomic ,assign)JZTitleAnimationType        animationType;
/**
 *  下划线宽度类型
 */
@property (nonatomic ,assign)JZTitleLineWidthType        lineWidthType;
/**
 *  当前选中的行
 */
@property(nonatomic ,retain)NSIndexPath          *selectIndexPath;

/**
 *  线距离底部的距离  陶波波 
 */
@property(nonatomic, assign)CGFloat               lineBottomMargin;

@property (nonatomic ,assign)id<JZTitleScreollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSourceArr isScrol:(BOOL)isScrol;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView indexpath:(NSIndexPath *)indexpath;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isRight:(BOOL)isRight;
//外部触发选中动画--马金丽
- (void)selectedItemAnimationIndexPath:(NSIndexPath *)indexPath;
@end
