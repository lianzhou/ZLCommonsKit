//
//  TitleScreollView.h
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZLTitleAnimationType) {
    ZLTitleAnimationTypeDefault,               //默认
    ZLTitleAnimationTypeOnlyColor,             //颜色
    ZLTitleAnimationTypeOnlyLine,              //加线
    ZLTitleAnimationTypeTransformScale,        //缩放
    ZLTitleAnimationTypeColorAndLine,          //颜色加线
    ZLTitleAnimationTypeCustom,                //自定义
    
};
typedef NS_ENUM(NSInteger, ZLTitleLineWidthType) {
    ZLTitleLineWidthTypeEqualCellFrame,          //cell宽度
    ZLTitleLineWidthTypeEqualSubViewFrame,       //cell上子视图宽度
    ZLTitleLineWidthTypeFixedWidth,              //固定宽度(和lineViewWidth配合使用)
    ZLTitleLineWidthTypeDynamicWidth,            //动态宽度(和lineViewWidth配合使用)
};

@class ZLTitleScreollView;

@protocol ZLTitleScreollViewDelegate <NSObject>

@optional

/**
 *  单元格选中
 */
- (void)ZLtitleScreollView:(ZLTitleScreollView *)scrollView CollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  配置cell方法自定义动画
 */
- (void)ZLtitleScreollView:(ZLTitleScreollView *)scrollView CollectionView:(UICollectionView *)collectionView animationCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZLTitleScreollView : UIView

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
@property (nonatomic ,assign)ZLTitleAnimationType        animationType;
/**
 *  下划线宽度类型
 */
@property (nonatomic ,assign)ZLTitleLineWidthType        lineWidthType;
/**
 *  当前选中的行
 */
@property(nonatomic ,retain)NSIndexPath          *selectIndexPath;

/**
 *  线距离底部的距离  陶波波 
 */
@property(nonatomic, assign)CGFloat               lineBottomMargin;

@property (nonatomic ,assign)id<ZLTitleScreollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSourceArr isScrol:(BOOL)isScrol;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView indexpath:(NSIndexPath *)indexpath;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isRight:(BOOL)isRight;
//外部触发选中动画--马金丽
- (void)selectedItemAnimationIndexPath:(NSIndexPath *)indexPath;
@end
