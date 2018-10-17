//
//  ZLTableCellBaseHeaderView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLHeaderNameView.h"
#import "ZLSystemMacrocDefine.h"
#import <Masonry/Masonry.h>
#import "UIImageView+ZLSDWebImage.h"
#import "ZLStringMacrocDefine.h"
#import "UIView+ZLUIViewExtension.h"
#import "ZLContext.h"
#import "ZLBaseViewController.h"

@interface ZLHeaderNameView ()

@end

@implementation ZLHeaderNameView

- (instancetype)initWithItem:(ZLHeaderNameItem *)item {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headerNameItem = item;
        [self createViews];
    }
    return self;
}

- (void)createViews {
    if (ZLCheckObjectNull(self.headerNameItem)) {
        NSAssert(NO, @"没有配置头部!!!!!!");
    }
    WEAKSELF
    self.headerNameItem.headerNameItemChangeData = ^{
        [weakSelf updateHeaderNameItemData];  
    };
    if (ZLStringIsNull(self.headerNameItem.userID)) {
        [self.iconImgView zl_setTarget:self action:@selector(toucheHeaderImageView)];
    }
    [self addSubview:self.iconImgView];
    [self addSubview:self.nameLabel];
    if (self.headerNameItem.headerNameItemStyle !=ZLHeaderNameItemStyleValue1) {
        [self addSubview:self.dateLabel];
    }
    if (self.headerNameItem.headerNameItemStyle !=ZLHeaderNameItemStyleValue2) {
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
    ZLBaseViewController * currentViewController = (ZLBaseViewController *)[ZLContext shareInstance].currentViewController;
    [currentViewController pushViewControllerName:@"ZLUserDetailViewController" withParams:params];
}
- (void)makeConstraints{
    WEAKSELF
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(weakSelf.headerNameItem.iconSize);
    }];
    
    if (self.headerNameItem.headerNameItemStyle ==ZLHeaderNameItemStyleDefault) {
        
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
    }else if (self.headerNameItem.headerNameItemStyle ==ZLHeaderNameItemStyleValue1){
        
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
    }else if (self.headerNameItem.headerNameItemStyle ==ZLHeaderNameItemStyleValue2){
        
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
    if (!ZLStringIsNull(self.headerNameItem.iconUrl)) {
        [self.iconImgView zl_setImageWithURL:[NSURL URLWithString:self.headerNameItem.iconUrl]];
    }
    if (!ZLStringIsNull(self.headerNameItem.localIcon)) {
        [self.iconImgView setImage:[UIImage imageNamed:self.headerNameItem.localIcon]];
    }
    if (!ZLStringIsNull(self.headerNameItem.nameText)) {
        self.nameLabel.text = self.headerNameItem.nameText;
    }
    if (!ZLStringIsNull(self.headerNameItem.dateText)) {
        self.dateLabel.text = self.headerNameItem.dateText;
    }
    
    
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.headerNameItem.iconSize);
    }];
    if (self.headerNameItem.headerNameItemStyle ==ZLHeaderNameItemStyleDefault) {
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
- (ZLHeaderNameItem *)headerNameItem{
    if (!_headerNameItem) {
        _headerNameItem = [[ZLHeaderNameItem alloc]init];
    }
    return _headerNameItem;
}

@end


@implementation ZLHeaderNameItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerNameItemStyle = ZLHeaderNameItemStyleDefault;
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

