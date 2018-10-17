//
//  ZLEmojiBoardView.m
//  ZLChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/26.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "ZLEmojiBoardView.h"
#import "ZLEmojiInfo.h"
#import "ZLEmojiHelper.h"
#import "ZLStringMacrocDefine.h"
#import "Masonry.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

#define KWidth [UIScreen mainScreen].bounds.size.width
#define ZL_EmojiKeyBoardHeight 216
#define BottomViewHeight 30
static NSString *ZLEmojiPageCellID = @"ZLEmojiPageCell";
@interface ZLEmojiBoardView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *layout;
@property (nonatomic, assign)CGFloat bottomHeight;

@end

@implementation ZLEmojiBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}


- (void)initializer{
    
    self.bottomHeight = 30; //默认不显示底部工具栏
    [self makeConstraints];
}






#pragma mark - 约束
- (void)makeConstraints{

    [self.allEmojiCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ZL_EmojiKeyBoardHeight - BottomViewHeight);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [ZLEmojiHelper emojiAllPage];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLEmojiPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZLEmojiPageCellID forIndexPath:indexPath];
    cell.isBottomView = self.isShowBottomView;
    cell.currentPageEmojiList = [[ZLEmojiHelper emojisCurrentPage:indexPath.row] mutableCopy];
    __weak typeof(self) weakSelf = self;
    cell.deleteEmojiBlock = ^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(emojiDelete)]) {
            [strongSelf.delegate emojiDelete];
        }
        
    };
    
    cell.chooseEmojiBlock = ^(NSDictionary *emojiDict) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZLEmojiInfo *info = [[ZLEmojiInfo alloc] init];
        info.emjStr = [emojiDict.allKeys firstObject];
        info.imageName = [emojiDict objectForKey:info.emjStr];
        info.emojiIndex = indexPath.row;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(emojiSelect:)]) {
            [strongSelf.delegate emojiSelect:info];
        }
    };
    return cell;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojoCollectionViewDidEndDecelerating:withCurrentPage:)]) {
        [self.delegate emojoCollectionViewDidEndDecelerating:self withCurrentPage:page];
    }
}

#pragma mark - 懒加载

- (UICollectionView *)allEmojiCollectionView {
    
    if (!_allEmojiCollectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0 ;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(KWidth, ZL_EmojiKeyBoardHeight - self.bottomHeight);
        _allEmojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _allEmojiCollectionView.showsHorizontalScrollIndicator = NO;
        _allEmojiCollectionView.pagingEnabled = YES;
        _allEmojiCollectionView.dataSource = self;
        _allEmojiCollectionView.delegate = self;
        _allEmojiCollectionView.bounces = NO;
        _allEmojiCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_allEmojiCollectionView registerClass:[ZLEmojiPageCell class] forCellWithReuseIdentifier:ZLEmojiPageCellID];
        [self addSubview:_allEmojiCollectionView];
        
    }
    return _allEmojiCollectionView;
}


#pragma mark - setter

- (void)setIsShowBottomView:(BOOL)isShowBottomView {

    _isShowBottomView = isShowBottomView;
    
    if (isShowBottomView) {
        self.bottomHeight = 40+20;
    }else{
        self.bottomHeight = 30;
       
    }
    [self.allEmojiCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZL_EmojiKeyBoardHeight - self.bottomHeight);
    }];
    self.layout.itemSize = CGSizeMake(KWidth, ZL_EmojiKeyBoardHeight - self.bottomHeight );
    [self.allEmojiCollectionView reloadData];
}



@end


/**
 表情cell
 */

@interface ZLEmojiCell ()

@property(nonatomic, strong)UIImageView *emojiImageView;

@end

@implementation ZLEmojiCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}



- (void)createViews {
    [self.emojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)emojiCellDataWithImageName:(NSString *)imageName
{
    if (ZLStringIsNull(imageName)) {
        return;
    }
    
    self.emojiImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[ZLEmojiHelper emojiIconName:imageName]]];
}


#pragma mark - 懒加载

- (UIImageView *)emojiImageView {
    
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_emojiImageView];
    }
    return _emojiImageView;
    
}

@end


static NSString *ZLEmojiCellID = @"ZLEmojiCell";
/**
 pageCell
 */
@interface ZLEmojiPageCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, assign)CGFloat bottomHeight;
@property(nonatomic, strong)UICollectionViewFlowLayout *pageLayout;
@property(nonatomic, assign)CGFloat emojiSizeWH;
@property(nonatomic, assign)CGFloat marginSpace;
@end
@implementation ZLEmojiPageCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.isBottomView = NO;
        self.bottomHeight = 30;
        [self makeConstraints];
    }
    return self;
}

#pragma mark - 约束
- (void)makeConstraints{
    
    
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


#pragma mark - ZLEmojiPageCell --- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _currentPageEmojiList.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZLEmojiCellID forIndexPath:indexPath];
    NSString *imageName = @"chat_enoji_delete";
    if (indexPath.row < _currentPageEmojiList.count) {
        NSDictionary *emojiDict = _currentPageEmojiList[indexPath.row];
        imageName = [[emojiDict allValues] firstObject];
    }
    [cell emojiCellDataWithImageName:imageName];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _currentPageEmojiList.count) {

        if (self.deleteEmojiBlock) {
            self.deleteEmojiBlock(indexPath.row);
        }
        NSLog(@"点击删除");
        return;
    }
    
    NSDictionary * emotionDic = _currentPageEmojiList[indexPath.row];
    if (self.chooseEmojiBlock) {
        self.chooseEmojiBlock(emotionDic);
    }
    NSLog(@"点击表情");

    
}

#pragma mark - 懒加载

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        
        _pageLayout = [[UICollectionViewFlowLayout alloc] init];
        //计算间距
        CGFloat emojiWH = [ZLEmojiHelper emojiSize];
        self.emojiSizeWH = emojiWH;
        CGFloat marginSpace = ((KWidth - [ZLEmojiHelper colsOfCurrentPage]*emojiWH)/([ZLEmojiHelper colsOfCurrentPage]+1));
        self.marginSpace = marginSpace;
        _pageLayout.itemSize = CGSizeMake(emojiWH, emojiWH);
        _pageLayout.minimumInteritemSpacing = marginSpace;
        
        CGFloat linsSpace = (ZL_EmojiKeyBoardHeight - self.bottomHeight - [ZLEmojiHelper lineOfCurrentPage]*emojiWH)/([ZLEmojiHelper lineOfCurrentPage]+1);
        _pageLayout.minimumLineSpacing = linsSpace;
        _pageLayout.sectionInset = UIEdgeInsetsMake(linsSpace, marginSpace, 0, marginSpace);
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_pageLayout];
        _mainCollectionView.scrollEnabled = NO;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [_mainCollectionView registerClass:[ZLEmojiCell class] forCellWithReuseIdentifier:ZLEmojiCellID];
        [self.contentView addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}


#pragma mark - setter

- (void)setCurrentPageEmojiList:(NSArray<NSDictionary *> *)currentPageEmojiList {
    
    _currentPageEmojiList = currentPageEmojiList;
    [self.mainCollectionView reloadData];
}

- (void)setIsBottomView:(BOOL)isBottomView {
    
    _isBottomView = isBottomView;
    if (isBottomView) {
        self.bottomHeight = 40+20;
    }else{
        self.bottomHeight = 30;
    }
    CGFloat linsSpace = (ZL_EmojiKeyBoardHeight - self.bottomHeight - [ZLEmojiHelper lineOfCurrentPage]*self.emojiSizeWH)/([ZLEmojiHelper lineOfCurrentPage]+1);
    _pageLayout.minimumLineSpacing = linsSpace;
    _pageLayout.sectionInset = UIEdgeInsetsMake(linsSpace, self.marginSpace, 0, self.marginSpace);
    [self.mainCollectionView reloadData];
}


@end
