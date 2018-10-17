//
//  ZLNavigationTopView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLNavigationTopView.h"
#import <YYKit.h>
#import <Masonry/Masonry.h>

@interface ZLNavigationTopView ()

/**
 *  标题栏颜色
 */
@property (nonatomic, strong) UIColor   *titleColor;
/**
 *  标题栏大小
 */
@property (nonatomic, assign) CGFloat   titleFont;
/**
 *  标题栏
 */
@property (nonatomic, strong) UILabel   *titleLabel;

@end

@implementation ZLNavigationTopView

- (instancetype)initWithFrame:(CGRect)frame  LeftView:(UIView *)leftView  rightView:(UIView *)rightView middleView:(UIView *)middleView {
     self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
        [self creatLeftView:leftView rightView:rightView middleView:middleView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame  LeftButton:(BOOL)isCreatL  rightButton:(BOOL)isCreatR middelTitle:(NSString*)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
        [self creatLeftButton:isCreatL rightButton:isCreatR middelTitle:title];
    }
    return self;
}
- (void)initializer{
    
//    self.frame = CGRectMake(0, 0,ZL_SCREEN_WIDTH, 64);
    [self makeBackgroundColor:UIColorHex(0xf5f5f5)];
    
}

/**
 * 背景色
 */
- (void)makeBackgroundColor:(UIColor*)color{
    
    self.backgroundColor =  color;
}
#pragma mark - 创建subViews
- (void)creatLeftView:(UIView *)leftView  rightView:(UIView *)rightView middleView:(UIView *)middleView{
    
    if (leftView) {
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(6);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
        }];
    }
    if (rightView) {
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_left).offset(6);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
        }];
    }
    if (middleView) {
        [self addSubview:middleView];
        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
}
- (void)creatLeftButton:(BOOL)isCreatL  rightButton:(BOOL)isCreatR middelTitle:(NSString*)title{
    if (isCreatL) {
        [self addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(6);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
        }];
    }
    if (isCreatR) {
        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_left).offset(6);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
        }];
    }
    if (title) {
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = UIColorHex(0xf5f5f5);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(80);
            make.left.mas_equalTo(self.mas_left).offset(80);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom).offset(5);
        }];
    }
}

- (void)setTitleFont:(CGFloat)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}
#pragma mark - 懒加载
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor blackColor];
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor blackColor];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (void)leftBtnClick:(UIButton *)leftBtn {
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock(leftBtn);
    }
}
- (void)rightBtnClick:(UIButton *)rightBtn {
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock(rightBtn);
    }
}
@end
