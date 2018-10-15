//
//  JZKeyBoardToolsPanelView.m
//  e学云
//
//  Created by 马金丽 on 17/5/18.
//  Copyright © 2017年 juziwl. All rights reserved.
//

#import "JZKeyBoardToolsPanelView.h"
#import "JZKeyBoarfToolCollectionCell.h"
#import <Masonry/Masonry.h>
#import "JZSystemMacrocDefine.h"

#define JZITOOLITEM_WIDTH (SCREEN_WIDTH-30)/4

static NSString *JZKeyBoarfToolCollectionCellID = @"JZKeyBoarfToolCollectionCell";
@interface JZKeyBoardToolsPanelView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UICollectionView *itemMainCollectionView;
@property(nonatomic,strong)UIPageControl *mainPageControl;
@property(nonatomic,strong)NSMutableArray *allItemsArray;

@property(nonatomic,strong)NSMutableArray *AllNewItemsArray;


@end

@implementation JZKeyBoardToolsPanelView


- (instancetype)initWithFrame:(CGRect)frame with_itemsArray:(NSArray *)itemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (itemsArray.count >0) {
            [self.allItemsArray addObjectsFromArray:itemsArray];
   
        }
        [self createContentScrollViewWithArray:self.allItemsArray];
    }
    return self;
}


- (void)createContentScrollViewWithArray:(NSArray *)itemArray
{
    _contentScrollView = [[UIScrollView alloc]init];
    [self addSubview:_contentScrollView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(JZ_MoreToolKeyBoardHeight);
    }];
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    [_contentScrollView setPagingEnabled:YES];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    //每行的item数
    //除数
    int divisorNum = (int)itemArray.count/8;
    if (divisorNum == 0) {
        divisorNum = 1;
    }
    //取余
    int remainderNum = (itemArray.count)%8;
    if (itemArray.count/8 != 0 && remainderNum != 0) {
        divisorNum += 1;
    }
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *divisorNum, JZ_MoreToolKeyBoardHeight);

    for (int i = 0; i < divisorNum; i++) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _itemMainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_contentScrollView addSubview:_itemMainCollectionView];
        [_itemMainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(SCREEN_WIDTH*i+15);
            make.top.mas_equalTo(self.mas_top);
            make.width.mas_offset(SCREEN_WIDTH-30);
            make.height.mas_offset(JZ_MoreToolKeyBoardHeight);
        }];
        _itemMainCollectionView.backgroundColor = [UIColor whiteColor];
        _itemMainCollectionView.delegate = self;
        _itemMainCollectionView.dataSource = self;
        [_itemMainCollectionView registerClass:[JZKeyBoarfToolCollectionCell class] forCellWithReuseIdentifier:JZKeyBoarfToolCollectionCellID];
        if (i == 0) {
            if (_allItemsArray.count >8) {
               _AllNewItemsArray = [[_allItemsArray subarrayWithRange:NSMakeRange(0, 8)] mutableCopy];
            }else{
                _AllNewItemsArray = [_allItemsArray mutableCopy];
            }
        }
        [_itemMainCollectionView reloadData];
        
    }
    _mainPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.bounds.size.width-100)/2, self.bounds.size.height -20, 100, 20)];
    _mainPageControl.numberOfPages = divisorNum;
    _mainPageControl.currentPage = 0;
    _mainPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _mainPageControl.currentPageIndicatorTintColor = JZ_KMainColor;
    if (divisorNum >1 ) {
        [self addSubview:_mainPageControl];
        [self bringSubviewToFront:_mainPageControl];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.AllNewItemsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JZKeyBoarfToolCollectionCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:JZKeyBoarfToolCollectionCellID forIndexPath:indexPath];
    NSDictionary *curretnDict = [self.AllNewItemsArray objectAtIndex:indexPath.row];
    [itemCell setCellDataWithDict:curretnDict];
    itemCell.selectBlock = ^(){
        if(self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(jzKeyBoardToolsPanel:didSelectedWithItem:withTitle:)]) {
            [self.toolDelegate jzKeyBoardToolsPanel:self didSelectedWithItem:curretnDict withTitle:[curretnDict objectForKey:@"iconTitle"]];
        }
    };
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *curretnDict = [self.AllNewItemsArray objectAtIndex:indexPath.row];
    if(self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(jzKeyBoardToolsPanel:didSelectedWithItem:withTitle:)]) {
        [self.toolDelegate jzKeyBoardToolsPanel:self didSelectedWithItem:curretnDict withTitle:[curretnDict objectForKey:@"iconTitle"]];
    }
    
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-30)/4, 236/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger currentIndex = scrollView.contentOffset.x /SCREEN_WIDTH;
    _mainPageControl.currentPage = currentIndex;
    NSInteger countIndex = _allItemsArray.count/8;
    NSInteger remainderIndex = _allItemsArray.count%8;
    if (currentIndex==countIndex) {
        _AllNewItemsArray = [[_allItemsArray subarrayWithRange:NSMakeRange(currentIndex*8, remainderIndex)] mutableCopy];
    }else{
        _AllNewItemsArray = [[_allItemsArray subarrayWithRange:NSMakeRange(currentIndex*8, 8)] mutableCopy];
    }
    [_itemMainCollectionView reloadData];
    [_contentScrollView scrollRectToVisible:CGRectMake(currentIndex *SCREEN_WIDTH, 0, SCREEN_WIDTH, _contentScrollView.frame.size.height) animated:YES];

}


- (NSMutableArray *)allItemsArray
{
    if (!_allItemsArray) {
        _allItemsArray = [[NSMutableArray alloc]initWithObjects:@{@"iconTitle":@"相机",@"iconImageNormal":@"mjl_message_camera",@"iconImageHigh":@"mjl_message_camera_high"},@{@"iconTitle":@"相册",@"iconImageNormal":@"mjl_message_photo",@"iconImageHigh":@"mjl_message_photo_high"}, nil];
    }
    return _allItemsArray;
}

@end
