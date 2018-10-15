//
//  JZTopTitleView.m
//  eStudy(parents)
//
//  Created by wangjingfei on 2017/10/17.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZTopTitleView.h"
#import "Masonry.h"
#import "UIButton+Layout.h"
#import <YYKit.h>
#import "JZStringMacrocDefine.h"

@interface JZTopTitleView()



//标题
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,copy) NSString *titleName;

@property (nonatomic,copy) ReturnButtonClickBlock btnClickBlock;

@end
@implementation JZTopTitleView

- (instancetype)initWithFrame:(CGRect)frame withTitleName:(NSString *)titleName withButtonClick:(ReturnButtonClickBlock)btnClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleName = titleName;
        
        _titleNameColor = UIColorHex(0x333333);
         _titleFontSize = 24;
        if (titleName.length>11) {
            
             _titleFontSize = 20;
            if ([UIScreen mainScreen].bounds.size.width <= 320) {
                _titleFontSize = 11;
            }
        }
       
        
        [self createTopTitleViewUI];
        
        _btnClickBlock = btnClickBlock;
    }
    return self;
}
- (void)createTopTitleViewUI
{
    //返回按钮
    _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"wjf_back"];
    [_returnBtn setImage:img forState:UIControlStateNormal];
    _returnBtn.imageRect = CGRectMake(0, (44 - img.size.height) / 2.0, img.size.width, img.size.height);
    [_returnBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_returnBtn];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:29];
    _titleLabel.textColor = UIColorHex(0x333333);
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = _titleName;
    [self addSubview:_titleLabel];
    
    //学生如何找回密码
    _resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resetPasswordBtn.hidden = YES;
    [_resetPasswordBtn setTitle:@"学生如何找回密码?" forState:UIControlStateNormal];
    _resetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _resetPasswordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_resetPasswordBtn setTitleColor:UIColorHex(0x3977b3) forState:UIControlStateNormal];
    [self addSubview:_resetPasswordBtn];
    
    [self makeUIConstraints];
}
- (void)makeUIConstraints {
    
    //返回按钮
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(5);
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(25);
        make.top.mas_equalTo(_returnBtn.mas_bottom).mas_offset(30);
        make.right.mas_equalTo(self.mas_right).mas_offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
    }];
    
    //学生如何找回密码
    [_resetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_titleLabel.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(_titleLabel.mas_bottom).mas_offset(0);
    }];
}
- (void)setTitleFontSize:(CGFloat)titleFontSize {
    
    _titleFontSize = titleFontSize;
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:_titleFontSize];
}
- (void)setTitleNameColor:(UIColor *)titleNameColor {
    
    _titleNameColor = titleNameColor;
    
    _titleLabel.textColor = (UIColor *)_titleNameColor;
}
//返回到上一级界面
- (void)returnButtonClick:(UIButton *)btn {
    
    if (_btnClickBlock) {
        _btnClickBlock();
    }
}

- (void)setReturnImageName:(NSString *)returnImageName {
    
    if (!JZStringIsNull(returnImageName)) {
        UIImage *img = [UIImage imageNamed:JZIFISNULL(returnImageName)];
        [_returnBtn setImage:img forState:UIControlStateNormal];
        _returnBtn.imageRect = CGRectMake((44 - img.size.width) / 2.0, (44 - img.size.height) / 2.0, img.size.width, img.size.height);
    }
}
@end
