//
//  JZAnimationTextField.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZAnimationTextField.h"
#import <Masonry/Masonry.h>
@interface JZAnimationTextFieldConfig ()

@end

@implementation JZAnimationTextFieldConfig

- (BOOL)isShowRightButton{
    if (!_isShowRightButton) {
        _isShowRightButton = NO;
    }
    return _isShowRightButton;
}
- (BOOL)clearsOnBeginEditing{
    if (!_clearsOnBeginEditing) {
        _clearsOnBeginEditing = NO;
    }
    return _clearsOnBeginEditing;
}

@end

@interface JZAnimationTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *sperLine;
@property (nonatomic, strong) UIButton    *clearButton;
@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, strong) JZAnimationTextFieldConfig * textFieldConfig;
@end

@implementation JZAnimationTextField

- (instancetype)initWithConfig:(JZAnimationTextFieldConfig *)config
{
    self = [super init];
    if (self) {
        self.textFieldConfig = config;
        [self initializer];
    }
    return self;
}

- (void)initializer{
        
    NSAssert(self.textFieldConfig, @"[没有配置 <TextField> 参数]");

    if (self.textFieldConfig.isShowRightButton) {
        [self addSubview:self.rightButton];
    }
    
    self.textField.placeholder = self.textFieldConfig.placeholder;
    self.textField.secureTextEntry = self.textFieldConfig.secureTextEntry;
    [self makeUI];
}

- (void)makeUI{
    [self addSubview:self.clearButton];
    [self addSubview:self.textField];
    [self addSubview:self.sperLine];
    
    [self makeConstraints];
}
#pragma mark - 约束
- (void)makeConstraints{

    MASViewAttribute *clearButton_Right = self.mas_right;
    if (self.textFieldConfig.isShowRightButton) {
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right); 
            make.top.mas_equalTo(self.mas_top); 
            make.bottom.mas_equalTo(self.mas_bottom); 
            make.width.mas_equalTo(self.rightButton.mas_height);
        }];      
        clearButton_Right = self.rightButton.mas_left;
    }
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(clearButton_Right); 
        make.top.mas_equalTo(self.mas_top); 
        make.bottom.mas_equalTo(self.mas_bottom); 
        make.width.mas_equalTo(self.clearButton.mas_height);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left); 
        make.top.mas_equalTo(self.mas_top); 
        make.bottom.mas_equalTo(self.mas_bottom); 
        make.right.mas_equalTo(self.clearButton.mas_left); 
    }];

    [self.sperLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left); 
        make.bottom.mas_equalTo(self.mas_bottom); 
        make.right.mas_equalTo(self.mas_right); 
        make.height.mas_equalTo(0.5); 
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    [self focusView];    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self removeFocus];    

}

/*!
 @brief 边框选中状态
 */
-(void)focusView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.sperLine.transform = CGAffineTransformMakeTranslation(0, -2);
        self.sperLine.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    } completion:^(BOOL finished) {
        self.clearButton.hidden = NO;
    }];

}

/*!
 @brief 边框不选中状态
 */
-(void)removeFocus
{
    [UIView animateWithDuration:0.25 animations:^{
        self.sperLine.transform = CGAffineTransformIdentity;
        self.sperLine.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        if (self.textFieldConfig.isShowRightButton) {
            self.rightButton.transform = CGAffineTransformIdentity;
        }
    }completion:^(BOOL finished) {
        self.clearButton.hidden = YES;
    }];
}
- (void)setText:(NSString *)text{
    self.textField.text = text;
}
- (NSString *)text{
    return self.textField.text;
}
- (void)setLeftView:(UIView *)leftView{
    _leftView = leftView;
    self.textField.leftView = leftView;
}
- (void)setLeftViewMode:(UITextFieldViewMode)leftViewMode{
    _leftViewMode = leftViewMode;
    self.textField.leftViewMode = leftViewMode;
}
#pragma mark - action
- (void)clearButtonClick:(UIButton *)sender{
    self.textField.text = @"";
}
- (void)rightButtonClick:(UIButton *)sender{
    
    self.rightSelected = !self.rightSelected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(animationTextField:rightButtonClick:)]) {
        [self.delegate animationTextField:self rightButtonClick:sender];
    }
}
- (void)setRightSelected:(BOOL)rightSelected{
    _rightSelected = rightSelected;
    if (rightSelected) {
        [UIView animateWithDuration:0.25 animations:^{
            _rightButton.transform = CGAffineTransformRotate(_rightButton.transform, M_PI);    
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _rightButton.transform = CGAffineTransformIdentity;    
        }];
    }
}
#pragma mark - 懒加载

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
    }
    return _textField;
}
- (UIImageView *)sperLine{
    if (!_sperLine) {
        _sperLine = [[UIImageView alloc] init];
        [self removeFocus];
    }
    return _sperLine;
}
- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:[UIImage imageNamed:@"lce_dropDown_Field_clear"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.hidden =YES;
    }
    return _clearButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"lce_dropDown_Field_dropDown"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
}

@end
