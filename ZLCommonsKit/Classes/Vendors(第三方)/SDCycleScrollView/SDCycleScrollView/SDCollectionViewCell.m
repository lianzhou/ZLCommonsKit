//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by zhoulian on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDCollectionViewCell.h"
#import "UIView+MJExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}
- (void)setSd_cornerRadius:(CGFloat)sd_cornerRadius{
    _sd_cornerRadius = sd_cornerRadius;
    _imageView.layer.cornerRadius = sd_cornerRadius;
    _imageView.layer.masksToBounds = YES;
}


- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}
- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
}
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.mj_w;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.mj_h - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}

@end
