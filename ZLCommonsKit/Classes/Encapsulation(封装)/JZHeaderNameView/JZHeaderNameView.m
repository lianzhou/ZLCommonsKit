//
//  JZTableCellBaseHeaderView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZHeaderNameView.h"
#import "JZSystemMacrocDefine.h"
#import <Masonry/Masonry.h>
#import "UIImageView+JZSDWebImage.h"
#import "JZStringMacrocDefine.h"
#import "UIView+JZUIViewExtension.h"
#import "JZContext.h"
#import "JZBaseViewController.h"

@interface JZHeaderNameView ()

@end

@implementation JZHeaderNameView

- (instancetype)initWithItem:(JZHeaderNameItem *)item {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headerNameItem = item;
        [self createViews];
    }
    return self;
}

- (void)createViews {
    if (JZCheckObjectNull(self.headerNameItem)) {
        NSAssert(NO, @"没有配置头部!!!!!!");
    }
    WEAKSELF
    self.headerNameItem.headerNameItemChangeData = ^{
        [weakSelf updateHeaderNameItemData];  
    };
    if (JZStringIsNull(self.headerNameItem.userID)) {
        [self.iconImgView jz_setTarget:self action:@selector(toucheHeaderImageView)];
    }
    [self addSubview:self.iconImgView];
    [self addSubview:self.nameLabel];
    if (self.headerNameItem.headerNameItemStyle !=JZHeaderNameItemStyleValue1) {
        [self addSubview:self.dateLabel];
    }
    if (self.headerNameItem.headerNameItemStyle !=JZHeaderNameItemStyleValue2) {
        if (self.headerNameItem.rightView) {
            [self addSubview:self.headerNameItem.rightView];
        }
    }
    
    [self makeConstraints];
    [self updateHeaderNameItemData];

}
- (void)toucheHeaderImageView{
    if (self.headerImageClick) {
        self.headerImageClick(self.iconImgView);
        return;
    }
    NSMutableDictionary * params = [@{} mutableCopy];
    [params setObject:self.headerNameItem.userID forKey:@"userID"];
    JZBaseViewController * currentViewController = (JZBaseViewController *)[JZContext shareInstance].currentViewController;
    [currentViewController pushViewControllerName:@"JZUserDetailViewController" withParams:params];
}
- (void)makeConstraints{
    WEAKSELF
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(weakSelf.headerNameItem.iconSize);
    }];
    
    if (self.headerNameItem.headerNameItemStyle ==JZHeaderNameItemStyleDefault) {
        
        if (self.headerNameItem.rightView) {
            [self.headerNameItem.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
                make.right.mas_equalTo(weakSelf.mas_right).mas_offset(-10);
                make.size.mas_equalTo(self.headerNameItem.rightViewSize);
            }];
        }
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
            make.left.mas_equalTo(weakSelf.iconImgView.mas_right).mas_offset(10);
            make.height.mas_equalTo(weakSelf.headerNameItem.iconSize.height/2);
            if (weakSelf.headerNameItem.rightView) {
                make.right.mas_equalTo(self.headerNameItem.rightView.mas_left).mas_offset(-10);
            }else{
                make.right.mas_equalTo(weakSelf.mas_right).mas_offset(-10);
            }
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom);
            make.bottom.mas_equalTo(weakSelf.iconImgView.mas_bottom);
            make.right.mas_equalTo(weakSelf.nameLabel.mas_right);
        }];
    }else if (self.headerNameItem.headerNameItemStyle ==JZHeaderNameItemStyleValue1){
        
        if (self.headerNameItem.rightView) {
            [self.headerNameItem.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
                make.right.mas_equalTo(weakSelf.mas_right).mas_offset(-10);
                make.size.mas_equalTo(self.headerNameItem.rightViewSize);
            }];
        }

        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
            make.left.mas_equalTo(weakSelf.iconImgView.mas_right).mas_offset(10);
            make.height.mas_equalTo(weakSelf.headerNameItem.iconSize.height);
            if (weakSelf.headerNameItem.rightView) {
                make.right.mas_equalTo(self.headerNameItem.rightView.mas_left).mas_offset(-10);
            }else{
                make.right.mas_equalTo(weakSelf.mas_right).mas_offset(-10);
            }
        }];
    }else if (self.headerNameItem.headerNameItemStyle ==JZHeaderNameItemStyleValue2){
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
            make.bottom.mas_equalTo(weakSelf.iconImgView.mas_bottom);
            make.right.mas_equalTo(weakSelf.nameLabel.mas_right);
            make.width.mas_offset(120.0f);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.iconImgView.mas_top);
            make.left.mas_equalTo(weakSelf.iconImgView.mas_right).mas_offset(10);
            make.bottom.mas_equalTo(weakSelf.iconImgView.mas_bottom);
            make.right.mas_equalTo(weakSelf.dateLabel.mas_left).mas_offset(-10);
        }];
    }

}

- (void)updateHeaderNameItemData{
    if (!JZStringIsNull(self.headerNameItem.iconUrl)) {
        [self.iconImgView jz_setImageWithURL:[NSURL URLWithString:self.headerNameItem.iconUrl]];
    }
    if (!JZStringIsNull(self.headerNameItem.localIcon)) {
        [self.iconImgView setImage:[UIImage imageNamed:self.headerNameItem.localIcon]];
    }
    if (!JZStringIsNull(self.headerNameItem.nameText)) {
        self.nameLabel.text = self.headerNameItem.nameText;
    }
    if (!JZStringIsNull(self.headerNameItem.dateText)) {
        self.dateLabel.text = self.headerNameItem.dateText;
    }
    
    
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.headerNameItem.iconSize);
    }];
    if (self.headerNameItem.headerNameItemStyle ==JZHeaderNameItemStyleDefault) {
        if (self.headerNameItem.rightView) {
            [self.headerNameItem.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.headerNameItem.rightViewSize);
            }];
        }
    }
}
#pragma mark -Lazy Load
- (UIImageView *)iconImgView {
    
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        if (self.headerNameItem.clipsToBounds) {
            _iconImgView.backgroundColor = [UIColor lightGrayColor];
            _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
            _iconImgView.clipsToBounds = YES;
            _iconImgView.layer.cornerRadius = self.headerNameItem.iconSize.width/2;
        }
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textColor = UIColorFromHex(333333);
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromHex(999999);
        _dateLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _dateLabel;
}
- (JZHeaderNameItem *)headerNameItem{
    if (!_headerNameItem) {
        _headerNameItem = [[JZHeaderNameItem alloc]init];
    }
    return _headerNameItem;
}

@end


@implementation JZHeaderNameItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerNameItemStyle = JZHeaderNameItemStyleDefault;
        self.iconSize = CGSizeMake(30, 30);
        self.height = 70.0;
        self.rightViewSize = CGSizeMake(120, 15);
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark -Setter

- (void)setHeight:(CGFloat)height{
    _height = height;
    [self updateHeaderNameItemData];
}
- (void)setIconUrl:(NSString *)iconUrl{
    _iconUrl = iconUrl;
    [self updateHeaderNameItemData];
}
- (void)setLocalIcon:(NSString *)localIcon{
    _localIcon = localIcon;
    [self updateHeaderNameItemData];
}
- (void)setNameText:(NSString *)nameText{
    _nameText = nameText;
    [self updateHeaderNameItemData];
}
- (void)setDateText:(NSString *)dateText{
    _dateText = dateText;
    [self updateHeaderNameItemData];
}
- (void)setIconSize:(CGSize)iconSize{
    _iconSize = iconSize;
    [self updateHeaderNameItemData];
}
- (void)setRightViewSize:(CGSize)rightViewSize{
    _rightViewSize = rightViewSize;
    [self updateHeaderNameItemData];
}
- (void)updateHeaderNameItemData{
    if (self.headerNameItemChangeData) {
        self.headerNameItemChangeData();
    }
}

@end

