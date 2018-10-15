//
//  TitleScreollView.m
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import "JZTitleScreollView.h"
#import "JZTitleCollectionBaseCell.h"
#import "JZBaseTitleModel.h"
#import "JZTitleCollectionFirstCell.h"
#import <YYKit.h>
#import "JZSystemMacrocDefine.h"


@interface JZTitleScreollView()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 *  数据源
 */
@property (nonatomic ,retain)NSArray             *dataSourceArr;
/**
 *  底部线的线
 */
@property (nonatomic ,retain)UIView              *lineView;
/**
 *  记录是否是第一次加载
 */
@property (nonatomic ,assign)BOOL                isFirst;

@property (nonatomic ,retain)UICollectionView    *titleCollectionView;

@end

@implementation JZTitleScreollView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSourceArr isScrol:(BOOL)isScrol{
    self = [super initWithFrame:frame];
    if (self) {
    
        _dataSourceArr = dataSourceArr;
      
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        _titleCollectionView.scrollEnabled = isScrol;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        _titleCollectionView.showsVerticalScrollIndicator = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        
        
        id  model = [dataSourceArr objectAtIndex:0];
        if ([model isKindOfClass:[JZBaseTitleModel class]]) {
            JZBaseTitleModel *baseModel = (JZBaseTitleModel *)model;
            Class cellClass = [JZBaseTitleModel classForContentType:baseModel.collectionCellModelType];
            [_titleCollectionView registerClass:cellClass forCellWithReuseIdentifier:baseModel.identifier];
        } else {
            [_titleCollectionView registerClass:[JZTitleCollectionFirstCell class] forCellWithReuseIdentifier:@"JZTitleCollectionFirstCell"];
        }
        
        [self addSubview:_titleCollectionView];
        
    }
    return self;

}
#pragma mark -- set 属性设置
/**
 *  动画类型
 */
- (void)setAnimationType:(JZTitleAnimationType)animationType {
    _animationType = animationType;
    if (animationType == JZTitleAnimationTypeColorAndLine || animationType == JZTitleAnimationTypeOnlyLine) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
//        _lineView.clipsToBounds = YES;
        _lineView.layer.cornerRadius = 1.f;
        if (_lineColor) {
            _lineView.backgroundColor = _lineColor;
        } else {
            _lineView.backgroundColor = UIColorHex(0x00af5c);
        }
        [_titleCollectionView addSubview:_lineView];
        
        _isFirst = YES;
    }
}
/**
 *  当前选中的行
 */
- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath {
    _selectIndexPath = selectIndexPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_titleCollectionView scrollToItemAtIndexPath:selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}
/**
 *  标题大小
 */
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
}
/**
 *  标题选中大小
 */
- (void)setTitleSelectFont:(UIFont *)titleSelectFont {
    _titleSelectFont = titleSelectFont;
}
/**
 *  标题颜色
 */
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
}
/**
 *  标题选中颜色
 */
- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    _titleSelectColor = titleSelectColor;
}
/**
 *  底部线的颜色
 */
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _lineView.backgroundColor = _lineColor;
}
/**
 *  字体选中缩放比
 */
- (void)setSelectSclae:(CGAffineTransform)selectSclae {
    _selectSclae = selectSclae;
}
/**
 *  底部线宽
 */
- (void)setLineViewWidth:(CGFloat)lineViewWidth {
    _lineViewWidth = lineViewWidth;
}
/**
 *  cell线宽
 */
- (void)setCellWidth:(CGFloat)cellWidth {
    _cellWidth = cellWidth;
}
/**
 *  下划线宽度类型
 */
- (void)setLineWidthType:(JZTitleLineWidthType)lineWidthType {
    _lineWidthType = lineWidthType;
}
#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    id  model = [_dataSourceArr objectAtIndex:indexPath.item];
    if ([model isKindOfClass:[JZBaseTitleModel class]]) {
        
        JZBaseTitleModel *baseModel = (JZBaseTitleModel *)model;
        JZTitleCollectionBaseCell  *cell = (JZTitleCollectionBaseCell *)[collectionView dequeueReusableCellWithReuseIdentifier:baseModel.identifier forIndexPath:indexPath];
        
        [cell settingModelData:model indexPath:indexPath];
        
        if (indexPath.item == _selectIndexPath.item) {
            if (_animationType == JZTitleAnimationTypeOnlyLine) {
                if (_isFirst) {
                    _isFirst = NO;
                    //底部横线的frame
                    [self updateLineViewFrameWithCell:cell];
                }
            }else if (_animationType == JZTitleAnimationTypeTransformScale) {
                //设置标题选中缩放比
                [cell setSelectCellTransform:_selectSclae];
            } else if (_animationType == JZTitleAnimationTypeCustom) {
                //自定义动画
                if ([self.delegate respondsToSelector:@selector(JZtitleScreollView:CollectionView:animationCellForRowAtIndexPath:)]) {
                    [self.delegate JZtitleScreollView:self CollectionView:collectionView animationCellForRowAtIndexPath:indexPath];
                }
            }
        } else {
            //设置标题缩放比
            [cell setNoSelectCellTransform:CGAffineTransformIdentity];
        }
        return cell;
    } else {
        
        JZTitleCollectionFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JZTitleCollectionFirstCell" forIndexPath:indexPath];
        
        NSString *titleString = (NSString *)model;
        cell.titleString = titleString;
        
        if (indexPath.item == _selectIndexPath.item) {
            
            //设置标题选中的颜色和大小
            [cell setSelectFont:_titleSelectFont color:_titleSelectColor];
                       
            if (_animationType == JZTitleAnimationTypeTransformScale) {
                //设置选中缩放比
                 [cell setSelectCellTransform:_selectSclae];
                
            } else if(_animationType == JZTitleAnimationTypeColorAndLine || _animationType == JZTitleAnimationTypeOnlyLine){
                if (_isFirst) {
                    _isFirst = NO;
                    //底部横线的frame
                    [self updateLineViewFrameWithCell:cell];
                }
                
                if (_animationType == JZTitleAnimationTypeOnlyLine) {
                    //设置标题颜色和大小
                    [cell setNoSelectFont:_titleFont color:_titleColor];
                }
            }
        } else {
            
            //设置标题颜色和大小
            [cell setNoSelectFont:_titleFont color:_titleColor];
            
            if (_animationType == JZTitleAnimationTypeTransformScale) {
                //设置缩放比
                [cell setNoSelectCellTransform:CGAffineTransformIdentity];
            }
        }

         return cell;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id  model = [_dataSourceArr objectAtIndex:indexPath.item];
    if ([model isKindOfClass:[JZBaseTitleModel class]]) {
        JZBaseTitleModel *baseModel = (JZBaseTitleModel *)model;
        return baseModel.modelSize;
    } else {
        if (_cellWidth > 0) {
            return CGSizeMake(_cellWidth , self.bounds.size.height);
        }
        
        CGRect rect = [self calculateTitleStringWidthIndexPath:indexPath];
        return CGSizeMake(rect.size.width+40 , self.bounds.size.height);
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndexPath.item == indexPath.item) {
        return;
    }
    _selectIndexPath = indexPath;
    [_titleCollectionView reloadData];
    [_titleCollectionView scrollToItemAtIndexPath:_selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    if (_animationType == JZTitleAnimationTypeColorAndLine || _animationType == JZTitleAnimationTypeOnlyLine) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UICollectionViewCell *cell = [_titleCollectionView cellForItemAtIndexPath:_selectIndexPath];
            [UIView animateWithDuration:0.15 animations:^{
                //底部横线的frame
                [self updateLineViewFrameWithCell:cell];
            }];
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(JZtitleScreollView:CollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate JZtitleScreollView:self CollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    
}
#pragma mark -外部触发选中动画--马金丽
- (void)selectedItemAnimationIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndexPath.item == indexPath.item) {
        return;
    }
    _selectIndexPath = indexPath;
    [_titleCollectionView reloadData];
    [_titleCollectionView scrollToItemAtIndexPath:_selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if (_animationType == JZTitleAnimationTypeColorAndLine || _animationType == JZTitleAnimationTypeOnlyLine) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UICollectionViewCell *cell = [_titleCollectionView cellForItemAtIndexPath:_selectIndexPath];
            [UIView animateWithDuration:0.15 animations:^{
                //底部横线的frame
                [self updateLineViewFrameWithCell:cell];
            }];
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(JZtitleScreollView:CollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate JZtitleScreollView:self CollectionView:_titleCollectionView didSelectItemAtIndexPath:indexPath];
    }
}
#pragma mark -- 联动方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView indexpath:(NSIndexPath *)indexpath {

    _selectIndexPath = indexpath;
    
    if (_animationType == JZTitleAnimationTypeTransformScale) {
         [_titleCollectionView scrollToItemAtIndexPath:_selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        //10.2版本上快速滑动问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            id  model = [_dataSourceArr objectAtIndex:indexpath.item];
            if ([model isKindOfClass:[JZBaseTitleModel class]]) {
                JZBaseTitleModel *baseModel = (JZBaseTitleModel *)model;
                Class cellClass = [JZBaseTitleModel classForContentType:baseModel.collectionCellModelType];
                [_titleCollectionView registerClass:cellClass forCellWithReuseIdentifier:baseModel.identifier];
                
                for (JZTitleCollectionBaseCell *cell in _titleCollectionView.visibleCells) {
                    //设置缩放比
                    [cell setNoSelectCellTransform:CGAffineTransformIdentity];
                }
                
                JZTitleCollectionBaseCell * currentCell= (JZTitleCollectionBaseCell*)[_titleCollectionView cellForItemAtIndexPath:_selectIndexPath];
                //设置选中缩放比
                [currentCell setSelectCellTransform:_selectSclae];
            } else {
                for (JZTitleCollectionFirstCell * cell in _titleCollectionView.visibleCells) {
                    //标题颜色和大小
                    [cell setNoSelectFont:_titleFont color:_titleColor];
                    [cell setNoSelectCellTransform:CGAffineTransformIdentity];
                }
                JZTitleCollectionFirstCell * currentCell= (JZTitleCollectionFirstCell*)[_titleCollectionView cellForItemAtIndexPath:_selectIndexPath];
                //标题颜色和大小
                [currentCell setSelectFont:_titleSelectFont color:_titleSelectColor];
                [currentCell setSelectCellTransform:_selectSclae];
            }
            
        });
    } else {
        
        [_titleCollectionView reloadData];
        [_titleCollectionView scrollToItemAtIndexPath:_selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_animationType == JZTitleAnimationTypeColorAndLine || _animationType == JZTitleAnimationTypeOnlyLine) {
                UICollectionViewCell *cell = [_titleCollectionView cellForItemAtIndexPath:_selectIndexPath];
                [UIView animateWithDuration:0.15 animations:^{
                    //底部横线的frame
                    [self updateLineViewFrameWithCell:cell];
                }];
            }
        });
    
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView isRight:(BOOL)isRight{
    
    NSString * offSet = [NSString stringWithFormat:@"%f",scrollView.contentOffset.x];
    
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    NSInteger index = [offSet integerValue]/scrollViewWidth;

    if (_animationType == JZTitleAnimationTypeTransformScale) {
        JZTitleCollectionBaseCell *nextCcell = nil;
        JZTitleCollectionBaseCell *currentCcell = nil;
        CGFloat slide ;
        CGFloat rightScale ;
        CGFloat leftScale;
        
        if (isRight) {//向右偏移
            slide = scrollView.contentOffset.x-index*scrollViewWidth;
            
            rightScale = (scrollView.contentOffset.x - index*scrollViewWidth)/scrollViewWidth;
            leftScale = 1 - rightScale;
            
            if (index+1 != _dataSourceArr.count) {
                nextCcell= (JZTitleCollectionBaseCell*)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0]];
                currentCcell= (JZTitleCollectionBaseCell*)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            }
        }else {//向左偏移
            slide = -scrollView.contentOffset.x+(index+1)*scrollViewWidth;
            rightScale = slide/scrollViewWidth;
            leftScale = 1 - rightScale;
            
            NSInteger nextIndex;
            NSInteger currentIndex;
            if (index -1 <0) {
                nextIndex = 0;
                currentIndex = 1;
            }else {
                nextIndex = index;
                currentIndex = index+1;
            }
            nextCcell= (JZTitleCollectionBaseCell*)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
            currentCcell= (JZTitleCollectionBaseCell*)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
        }
        
        if (_selectSclae.tx > 0) {
            nextCcell.transform = CGAffineTransformMakeScale(rightScale*(_selectSclae.tx-1.0)+1, rightScale*(_selectSclae.ty-1.0)+1);
            currentCcell.transform = CGAffineTransformMakeScale(leftScale*(_selectSclae.tx-1.0)+1, leftScale*(_selectSclae.ty-1.0)+1);
        } else {
            nextCcell.transform = CGAffineTransformMakeScale(rightScale*0.3+1, rightScale*0.3+1);
            currentCcell.transform = CGAffineTransformMakeScale(leftScale*0.3+1, leftScale*0.3+1);
        }
        
        NSArray *orignClorArr;
        NSArray *selectColorArr;
        //标题颜色
        if (_titleColor) {
            orignClorArr = [JZSystemUtils changeUIColorToRGB:_titleColor];
        } else {
            orignClorArr = [JZSystemUtils changeUIColorToRGB:UIColorHex(0x333333)];
        }
        //标题选中颜色
        if (_titleSelectColor) {
            selectColorArr = [JZSystemUtils changeUIColorToRGB:_titleSelectColor];
        } else {
            selectColorArr = [JZSystemUtils changeUIColorToRGB:UIColorHex(0x999999)];
        }
        
        id  model = [_dataSourceArr objectAtIndex:index];
        if ([model isKindOfClass:[NSString class]]) {
            JZTitleCollectionFirstCell *fCurrentCcell = (JZTitleCollectionFirstCell *)currentCcell;
            JZTitleCollectionFirstCell *fNextCcell = (JZTitleCollectionFirstCell *)nextCcell;
            
            fCurrentCcell.titleLabel.textColor = UIColorRGB([[selectColorArr objectAtIndex:0] integerValue]-([[selectColorArr objectAtIndex:0] integerValue] - [[orignClorArr objectAtIndex:0] integerValue])*slide/scrollViewWidth, [[selectColorArr objectAtIndex:1] integerValue]-([[selectColorArr objectAtIndex:1] integerValue] - [[orignClorArr objectAtIndex:1] integerValue])*slide/scrollViewWidth, [[selectColorArr objectAtIndex:2] integerValue]-([[selectColorArr objectAtIndex:2] integerValue] - [[orignClorArr objectAtIndex:2] integerValue])*slide/scrollViewWidth);
            fNextCcell.titleLabel.textColor = UIColorRGB([[orignClorArr objectAtIndex:0] integerValue]+([[selectColorArr objectAtIndex:0] integerValue] - [[orignClorArr objectAtIndex:0] integerValue])*slide/scrollViewWidth, [[orignClorArr objectAtIndex:1] integerValue]+([[selectColorArr objectAtIndex:1] integerValue] - [[orignClorArr objectAtIndex:1] integerValue])*slide/scrollViewWidth, [[orignClorArr objectAtIndex:2] integerValue]+([[selectColorArr objectAtIndex:2] integerValue] - [[orignClorArr objectAtIndex:2] integerValue])*slide/scrollViewWidth);
        }
    } 
    
}
#pragma mark -- lineView的坐标
- (void)updateLineViewFrameWithCell:(UICollectionViewCell *)cell {
    
    CGFloat lineHeight = self.titleFont ? self.titleFont.lineHeight : 16;    
    _lineView.frame = CGRectMake((cell.frame.size.width-24)/2.0 +cell.frame.origin.x, (self.bounds.size.height/2 + lineHeight/2) +4, 24, 2);
    
}
- (CGRect)calculateTitleStringWidthIndexPath:(NSIndexPath *)indexPath{
    
    UIFont *titleFont;
    if (_titleFont) {
        titleFont = _titleFont;
    } else if (_titleSelectFont ) {
        titleFont = _titleSelectFont;
    } else {
        titleFont = [UIFont systemFontOfSize:15];
    }
    CGRect rect = [[_dataSourceArr objectAtIndex:indexPath.item] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil];
    return rect;
}
@end
