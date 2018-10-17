//
//  ZLTitleCollectionFirstCell.m
//  TitleTableViewDemo
//
//  Created by zhangjiang on 2017/6/14.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import "ZLTitleCollectionFirstCell.h"
#import <YYKit.h>

@implementation ZLTitleCollectionFirstCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
    
}

- (void)setSelectFont:(UIFont *)titleSelectFont color:(UIColor *)titleSelectColor {
    //标题选中大小
    if (titleSelectFont) {
        _titleLabel.font = titleSelectFont;
    } else {
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    //标题选中颜色
    if (titleSelectColor) {
        _titleLabel.textColor = titleSelectColor;
    } else {
        _titleLabel.textColor = UIColorHex(0x333333);
    }
    
}

- (void)setNoSelectFont:(UIFont *)titleFont color:(UIColor *)titleColor {
    //标题大小
    if (titleFont) {
        _titleLabel.font = titleFont;
    } else {
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    //标题颜色
    if (titleColor) {
        _titleLabel.textColor = titleColor;
    } else {
        _titleLabel.textColor = UIColorHex(0x999999);
    }
    
}


@end
