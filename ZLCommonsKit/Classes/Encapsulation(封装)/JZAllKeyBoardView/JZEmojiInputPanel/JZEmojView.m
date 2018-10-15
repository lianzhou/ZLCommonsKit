//
//  JZEmojView.m
//  JZChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/23.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "JZEmojView.h"
#import "JZEmojiBoardView.h"
#import "JZEmojiHelper.h"
#import "JZEmojiBottomView.h"
#import "JZEmojiInfo.h"
#import <Masonry/Masonry.h>
#import "JZSystemMacrocDefine.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

//#define _emojiBoardView_Height 186
@interface JZEmojView ()<UIScrollViewDelegate,JZEmojiBottomViewdelagate,JZEmojiBoardDelegate>

@property(nonatomic,strong)UIPageControl *emojiPageControl;
@property(nonatomic,strong)UIScrollView *emojiScrollView;
@property(nonatomic,assign)CGFloat boardWidth;
@property(nonatomic,strong)JZEmojiBottomView *bottomView;
@property(nonatomic,strong)JZEmojiBoardView *emojiBoardView;
@property(nonatomic,assign)CGFloat emojiBoardView_Height;
@property(nonatomic,assign)CGFloat bottomView_Height;
@property(nonatomic,assign)CGFloat pageControl_Height;

@end

@implementation JZEmojView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    _boardWidth = SCREEN_WIDTH;
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
        [self makeConstraints];

       
    }
    return self;
}
- (void)initializer{
    _emojiBoardView_Height = 146;
    _bottomView_Height = 30;
    _isShowBottomView = NO;
    self.emojiPageControl.numberOfPages = [JZEmojiHelper emojiAllPage];
}


#pragma mark - 约束
- (void)makeConstraints{

    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.emojiPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left);
        make.right.mas_equalTo(self.bottomView.mas_right);
        make.height.mas_offset(30);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.emojiBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
//        make.bottom.mas_equalTo(self.emojiPageControl.mas_top).priorityHigh();
        make.height.mas_equalTo(JZ_EmojiKeyBoardHeight - self.bottomView_Height);
    }];
    
}

#pragma mark -JZEmojiBottomViewdelagate
- (void)jzEmojiBottomView:(JZEmojiBottomView *)bottomView didSelectedIndex:(NSInteger)selectedIndex
{
    NSLog(@"item:%ld",(long)selectedIndex);
}

- (void)jzBottomViewdidSendAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiViewSendTextAction:)]) {
        [self.delegate emojiViewSendTextAction:self];
    }
}


#pragma mark - JZEmojiBoardDelegate

- (void)emojoCollectionViewDidEndDecelerating:(JZEmojiBoardView *)emojiBoardView withCurrentPage:(NSInteger)page {
    
    self.emojiPageControl.currentPage = page;
}

- (void)emojiSelect:(JZEmojiInfo *)info {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiView:withEmojiSelect:)]) {
        [self.delegate emojiView:self withEmojiSelect:info];
    }
    
}

- (void)emojiDelete {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiViewDeleteClick:)]) {
        [self.delegate emojiViewDeleteClick:self];
    }
    
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
    
    self.emojiPageControl.currentPage = page;
}


- (void)pageChange:(UIPageControl *)sender {
    
    [self.emojiBoardView.allEmojiCollectionView scrollRectToVisible:CGRectMake(sender.currentPage *SCREEN_WIDTH, 0, SCREEN_WIDTH, JZ_EmojiKeyBoardHeight - self.bottomView_Height) animated:YES];
    
}


#pragma mark - 懒加载


- (UIPageControl *)emojiPageControl
{
    if (!_emojiPageControl) {
        _emojiPageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        _emojiPageControl.currentPage = 0;
        _emojiPageControl.pageIndicatorTintColor = [UIColor grayColor];
        _emojiPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _emojiPageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [_emojiPageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        _emojiPageControl.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self addSubview:_emojiPageControl];
    }
    return _emojiPageControl;
}

- (JZEmojiBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[JZEmojiBottomView alloc]init];
        _bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _bottomView.delegate = self;
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (JZEmojiBoardView *)emojiBoardView {
    
    if (!_emojiBoardView) {
        _emojiBoardView = [[JZEmojiBoardView alloc] init];
        _emojiBoardView.delegate = self;
        [self addSubview:_emojiBoardView];
    }
    return _emojiBoardView;
    
}






- (void)setIsShowBottomView:(BOOL)isShowBottomView
{
    _isShowBottomView = isShowBottomView;
    if (isShowBottomView) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40).priorityHigh();
        }];
        [self.emojiPageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20).priorityHigh();
        }];
        self.bottomView_Height = 40 + 20;
    }else{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityHigh();
        }];
        [self.emojiPageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30).priorityHigh();
        }];
        self.bottomView_Height = 30;
    }
    self.emojiBoardView.isShowBottomView = isShowBottomView;
}
@end
