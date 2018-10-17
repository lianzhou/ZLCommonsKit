//
//  ZLBarButtonItem.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLBarButtonItem.h"
#import "ZLSystemMacrocDefine.h"
#import <Masonry/Masonry.h>
#import "NSString+Extension.h"

@interface ZLBarButtonItem ()

@property(nonatomic,strong) UIButton *titleButton;

@property(nonatomic,strong) UILabel *badgeLabel;

@end

@implementation ZLBarButtonItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}
- (void)createViews{
    [self addSubview:self.titleButton];
    [self addSubview:self.badgeLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(34.0f);
    }];
    
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleButton.mas_top).mas_offset(-3.0f);
        make.right.mas_equalTo(self.titleButton.mas_right).mas_offset(3.0f);
        make.width.mas_equalTo(9.0f);
        make.height.mas_equalTo(9.0f);
    }];
    self.badgeStyle = ZLTabItemBadgeStyleHidden;
}

- (void)setTitleImage:(NSString *)titleImage {
    _titleImage = titleImage;
    [self setTitleImage:titleImage forState:UIControlStateNormal];
}

- (void)setTitleImage:(NSString *)titleImage forState:(UIControlState)state{
    [self.titleButton setImage:[UIImage imageNamed:titleImage] forState:state];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    CGSize size = [title textSizeIn:CGSizeMake(100.0f, 44.0) font:[UIFont systemFontOfSize:15.0]];
    [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
    
}

- (void)setBadge:(NSInteger)badge{
    _badge = badge;
    [self updateBadge];
}
- (void)setBadgeStyle:(ZLTabItemBadgeStyle)badgeStyle{
    _badgeStyle = badgeStyle;
    [self updateBadge];
}

- (void)setBadgeColor:(UIColor *)badgeColor{
    _badgeColor = badgeColor;
    _badgeLabel.backgroundColor = badgeColor;
}
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [_titleButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBadgeNumberColor:(UIColor *)badgeNumberColor{
    _badgeNumberColor = badgeNumberColor;
    _badgeLabel.textColor = badgeNumberColor;
}

- (void)updateBadge {
    if (self.badgeStyle == ZLTabItemBadgeStyleNumber) {
        if (self.badge == 0) {
            self.badgeLabel.hidden = YES;
        } else {
            self.badgeLabel.hidden = NO;
            NSString *badgeStr = @(self.badge).stringValue;
            if (self.badge > 99) {
                badgeStr = @"99+";
            }
            CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : self.badgeLabel.font}
                                                 context:nil].size;
            CGFloat width = ceilf(size.width)+5;
            CGFloat height = ceilf(size.height)+5;
            
            width = MAX(width, height);
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
                [self.badgeLabel layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.badgeLabel.layer.cornerRadius = height / 2;
                [self.badgeLabel.layer masksToBounds];
            }];
            self.badgeLabel.text = badgeStr;
            self.badgeLabel.hidden = NO;
        }
    } else if (self.badgeStyle == ZLTabItemBadgeStyleDot) {
        self.badgeLabel.text = @"";
        [UIView animateWithDuration:0.25 animations:^{
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
            [self.badgeLabel layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.badgeLabel.layer.cornerRadius = 4.5f;
            [self.badgeLabel.layer masksToBounds];
        }];
        self.badgeLabel.hidden = NO;
    }else if(self.badgeStyle == ZLTabItemBadgeStyleHidden) {
        self.badgeLabel.hidden = YES;
    }
}

- (void)buttonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(barButtonItem:didSelectButton:)]) {
        [self.delegate barButtonItem:self didSelectButton:sender];
    }
}



#pragma mark - 懒加载
- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}
- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:10.0];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = UIColorFromRGB(0xff6f26);
        _badgeLabel.clipsToBounds = YES;
    }
    return _badgeLabel;
}
@end
