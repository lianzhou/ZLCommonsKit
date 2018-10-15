//
//  JZEmojiBottomView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZEmojiBottomView.h"
#import "JZEmojiInfo.h"
#import "JZEmojiHelper.h"
#import <Masonry/Masonry.h>
#import "JZSystemMacrocDefine.h"

#define MenuItemWidth 60
#define MenuItemHeight 50

@interface JZEmojiBottomView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIButton *senderBtn;
@property(nonatomic,strong)UIScrollView *menuScrollView;
@property(nonatomic,strong)NSMutableArray *menuArrays;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)UILabel *topLine;
@end

@implementation JZEmojiBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self initializer];
    }
    return self;
}

- (void)initializer{
    [self makeConstraints];
}

#pragma mark -初始化数据
- (void)initData
{
    self.selectedIndex = 0;
    JZEmojiInfo *emojiInfo = [[JZEmojiHelper shareInstance].emojList objectAtIndex:19];
     NSString *imagePath = [@"JZEmojiExpression.bundle" stringByAppendingPathComponent:emojiInfo.imageName];
    [self.menuArrays addObject:imagePath];
//    [self.menuArrays addObject:imagePath];
}

#pragma mark - 约束
- (void)makeConstraints{
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).priorityHigh();
        make.top.mas_equalTo(self.mas_top).priorityHigh();
        make.right.mas_equalTo(self.mas_right).priorityHigh();
        make.height.mas_offset(0.8).priorityHigh();
    }];
   [self.senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(self.mas_right).priorityHigh();
       make.width.mas_offset(70).priorityHigh();
       make.bottom.mas_equalTo(self.mas_bottom).priorityHigh();
       make.top.mas_equalTo(self.topLine.mas_bottom).priorityHigh();

   }];
   
   [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.mas_left).priorityHigh();
       make.right.mas_equalTo(self.senderBtn.mas_left).priorityHigh();
       make.bottom.mas_equalTo(self.mas_bottom).priorityHigh();
       make.top.mas_equalTo(self.topLine.mas_bottom).priorityHigh();
   }];
    for (int i = 0; i < _menuArrays.count; i++) {
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.backgroundColor = [UIColor whiteColor];
        [menuBtn setImage:[UIImage imageNamed:[_menuArrays objectAtIndex:i]] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.tag = 200+i;
        [_menuScrollView addSubview:menuBtn];
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(i*MenuItemWidth);
            make.width.mas_offset(MenuItemWidth);
            make.height.mas_offset(MenuItemHeight);
            make.top.mas_equalTo(self.mas_top);
        }];
    }
    self.menuScrollView.contentSize = CGSizeMake(_menuArrays.count *60, 40);
    [self didSelectedItemIndex:self.selectedIndex+200];
}

- (void)btnClick:(UIButton *)sender
{
    [self didSelectedItemIndex:sender.tag];
}

- (void)didSelectedItemIndex:(NSInteger)index
{
    UIButton *oldBtn = [_menuScrollView viewWithTag:self.selectedIndex + 200];
    oldBtn.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = index-200;
    UIButton *currentBtn = [_menuScrollView viewWithTag:index];
    currentBtn.backgroundColor = UIColorRGB(209, 209, 209);

    if (self.delegate && [self.delegate respondsToSelector:@selector(jzEmojiBottomView:didSelectedIndex:)]) {
        [self.delegate jzEmojiBottomView:self didSelectedIndex:index - 200];
    }
}

//发送
- (void)sendBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jzBottomViewdidSendAction)]) {
        [self.delegate jzBottomViewdidSendAction];
    }
}
#pragma mark - 懒加载
- (UIButton *)senderBtn
{
    if (!_senderBtn) {
        _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderBtn.backgroundColor = UIColorRGB(24, 144, 212);
        [_senderBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_senderBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _senderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_senderBtn];
        
    }
    return _senderBtn;
}

- (UIScrollView *)menuScrollView
{
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc]init];
        _menuScrollView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.delegate = self;
        [self addSubview:_menuScrollView];
    }
    return _menuScrollView;
}

- (UILabel *)topLine
{
    if (!_topLine) {
        _topLine = [[UILabel alloc]init];
        _topLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (NSMutableArray *)menuArrays
{
    if (!_menuArrays) {
        _menuArrays = [[NSMutableArray alloc]init];
    }
    return _menuArrays;
}

@end
