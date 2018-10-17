//
//  ZLDropDownItemCell.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDropDownItemCell.h"
#import <Masonry/Masonry.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]
@interface ZLDropDownItemCell ()

@end

@implementation ZLDropDownItemCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializer];
    }
    return self;
}
- (void)initializer{
    
    [self makeConstraints];
}


#pragma mark - 约束
- (void)makeConstraints{

//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
//        make.width.mas_equalTo(self.iconImageView.mas_height);
//        
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
  
    
}

- (void)cellDateWithItem:(ZLDropDownItem *)item
{
    _titleLabel.text = item.title;
//    if (!item.isShowIcon) {
//        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_offset(0);
//        }];
//    }else{
//        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(self.iconImageView.mas_height);
//        }];
//    }
}

#pragma mark - 懒加载
//- (UIImageView *)iconImageView
//{
//    if (!_iconImageView) {
//        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _iconImageView.backgroundColor = UIColorFromRGB(0x00af5c);
//        [self.contentView addSubview:_iconImageView];
//    }
//    return _iconImageView;
//}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font =self.cellTitleFont;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


//- (UIFont *)cellTitleFont
//{
//    if (!_cellTitleFont) {
//        _cellTitleFont = [UIFont systemFontOfSize:14.0];
//    }
//    return _cellTitleFont;
//}
//
//#pragma mark -setter
//- (void)setCellCorlor:(UIColor *)cellCorlor
//{
//    _cellCorlor = cellCorlor;
//    self.contentView.backgroundColor = cellCorlor;
//}
//
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:YES];
//    self.iconImageView.backgroundColor = UIColorFromRGB(0x00af5c);
//}
//
//- (void)setIsShowIcon:(BOOL)isShowIcon
//{
//    _isShowIcon = isShowIcon;
//    [self makeConstraints];
//}

@end

@implementation ZLDropDownCell

- (void)cellDateWithItem:(ZLDropDownItem *)item {}

@end

