//
//  JZTextFieldView.m
//  eStudy
//
//  Created by wangjingfei on 2017/8/14.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZTextFieldView.h"
#import "Masonry.h"
#import "JZStringMacrocDefine.h"
#import "UIResponder+Router.h"
#import "NSObject+PerformSelector.h"

@interface JZTextFieldView ()<UITextFieldDelegate>

//线
@property (nonatomic,strong) UIView *lineView;


@end
@implementation JZTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self defaultSettingContent];
        [self createSubView];
    }
    return self;
}
//默认属性设置
- (void)defaultSettingContent
{
    //是否显示右边视图
    _jz_RightViewMode = UITextFieldViewModeNever;
    
    //是否显示左边视图
    _jz_LeftViewMode = UITextFieldViewModeNever;
    
    //设置TextField的边框样式
    _jz_BorderStyle = UITextBorderStyleNone;
    
    //是否在开始编辑时清空输入框
    _jz_ClearsOnBeginEditing = NO;
    
    //内容显示的位置
    _jz_TextAlignment = NSTextAlignmentLeft;
    
    //字体大小
    _jz_Font = [UIFont systemFontOfSize:12.0f];
    
    //字体颜色
    _jz_TextColor = [UIColor blackColor];
    
    //设置默认内容
    
    //是否显示线 默认是显示 YES
    _isShowLine = YES;
    
    //编辑时线的颜色是否发生变化 默认是NO
    _isChange = NO;
    
    //设置线的颜色
    _lineColor = [UIColor blackColor];
    
    //光线颜色 默认是蓝色
    _jz_TintColor = [UIColor blueColor];
    
    //清空内容按钮的出现时间 默认是不出现的
    _jz_ClearButtonMode = UITextFieldViewModeNever;
    
    //设置键盘的样式 默认UIKeyboardTypeDefault
    _jz_KeyboardType = UIKeyboardTypeDefault;
    
    //设置线颜色的alpha值 默认值为 1.0f
    _jz_alpha = 1.0;
}
//是否显示右边视图
- (void)setJz_RightViewMode:(UITextFieldViewMode)jz_RightViewMode
{
    _jz_RightViewMode = jz_RightViewMode;
    _jz_TextField.rightViewMode = _jz_RightViewMode;
}

//右边视图
- (void)setJz_RightView:(UIView *)jz_RightView
{
    _jz_RightView = jz_RightView;
    _jz_TextField.rightView = _jz_RightView;
}
//是否显示左边视图
- (void)setJz_LeftViewMode:(UITextFieldViewMode)jz_LeftViewMode
{
    _jz_LeftViewMode = jz_LeftViewMode;
    _jz_TextField.leftViewMode = _jz_LeftViewMode;
}
//左边视图
- (void)setJz_LeftView:(UIView *)jz_LeftView
{
    _jz_LeftView = jz_LeftView;
    _jz_TextField.leftView = _jz_LeftView;
}
//设置TextField的边框样式
- (void)setJz_BorderStyle:(UITextBorderStyle)jz_BorderStyle
{
    _jz_BorderStyle = jz_BorderStyle;
    _jz_TextField.borderStyle = _jz_BorderStyle;
}
//是否在开始编辑时清空输入框
- (void)setJz_ClearsOnBeginEditing:(BOOL)jz_ClearsOnBeginEditing
{
    _jz_ClearsOnBeginEditing = jz_ClearsOnBeginEditing;
    _jz_TextField.clearsOnBeginEditing = _jz_ClearsOnBeginEditing;
}
//内容显示的位置
- (void)setJz_TextAlignment:(NSTextAlignment)jz_TextAlignment
{
    _jz_TextAlignment = jz_TextAlignment;
    _jz_TextField.textAlignment = _jz_TextAlignment;
}
//字体大小
- (void)setJz_Font:(UIFont *)jz_Font
{
    _jz_Font = jz_Font;
    _jz_TextField.font = jz_Font;
}
//字体颜色
- (void)setJz_TextColor:(UIColor *)jz_TextColor
{
    _jz_TextColor = jz_TextColor;
    _jz_TextField.textColor = _jz_TextColor;
}
//设置默认内容
- (void)setJz_placeHolderStr:(NSString *)jz_placeHolderStr
{
    _jz_placeHolderStr = jz_placeHolderStr;
    _jz_TextField.placeholder = _jz_placeHolderStr;
}
//是否显示线 默认是显示 YES
- (void)setIsShowLine:(BOOL)isShowLine
{
    _isShowLine = isShowLine;
    _lineView.hidden = _isShowLine;
}
//编辑时线的颜色是否发生变化 默认是NO
- (void)setIsChange:(BOOL)isChange
{
    _isChange = isChange;
}
//设置线的颜色
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    _lineView.backgroundColor = _lineColor;
}
//设置线颜色的alpha值 默认值为 1.0f
- (void)setJz_alpha:(CGFloat)jz_alpha
{
    _jz_alpha = jz_alpha;
    _lineView.alpha = _jz_alpha;
}
//变化的颜色的alpha
- (void)setJz_ChangeAlpha:(CGFloat)jz_ChangeAlpha
{
    _jz_ChangeAlpha = jz_ChangeAlpha;
}
//光线颜色 默认是蓝色
- (void)setJz_TintColor:(UIColor *)jz_TintColor
{
    _jz_TintColor = jz_TintColor;
    _jz_TextField.tintColor = _jz_TintColor;
}
//清空内容按钮的出现时间 默认是不出现的
- (void)setJz_ClearButtonMode:(UITextFieldViewMode)jz_ClearButtonMode
{
    _jz_ClearButtonMode = jz_ClearButtonMode;
    _jz_TextField.clearButtonMode = _jz_ClearButtonMode;
}
//设置键盘的样式 默认UIKeyboardTypeDefault
- (void)setJz_KeyboardType:(UIKeyboardType)jz_KeyboardType
{
    _jz_KeyboardType = jz_KeyboardType;
    _jz_TextField.keyboardType = _jz_KeyboardType;
}
//密码是否明文显示 默认是明文显示   NO
- (void)setJz_SecureTextEntry:(BOOL)jz_SecureTextEntry
{
    _jz_SecureTextEntry = jz_SecureTextEntry;
    _jz_TextField.secureTextEntry = _jz_SecureTextEntry;
}
//创建子视图
- (void)createSubView
{
    _jz_TextField = [[JZTextField alloc] init];
    _jz_TextField.placeholder = _jz_placeHolderStr;
    _jz_TextField.textColor = _jz_TextColor;
    _jz_TextField.font = _jz_Font;
    _jz_TextField.borderStyle = _jz_BorderStyle;
    _jz_TextField.tintColor = _jz_TintColor;
    _jz_TextField.delegate = self;
    _jz_TextField.clearsOnBeginEditing = _jz_ClearsOnBeginEditing;
    [self addSubview:_jz_TextField];
    [_jz_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).mas_offset(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    [_jz_TextField addTarget:self action:@selector(changeLineColor:) forControlEvents:UIControlEventEditingChanged];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = _lineColor;
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.top.mas_equalTo(_jz_TextField.mas_bottom).mas_offset(4.5);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)changeLineColor:(UITextField *)textField
{
    if (_isChange) {
        if ([textField.text length] == 0 || textField.text  == nil) {
            _lineView.alpha = _jz_alpha;
        }else{
            _lineView.alpha = _jz_ChangeAlpha;
        }
    }
    _jz_TextFieldStr = textField.text;
}
#pragma mark -UITextFieldDelegate
//成为第一响应者
- (void)jz_BecomeFirstResponder
{
    [_jz_TextField becomeFirstResponder];
}
//取消成为第一响应者
- (void)jz_ResignFirstResponder
{
    [_jz_TextField resignFirstResponder];
}
- (void)setJz_TextFieldStr:(NSString *)jz_TextFieldStr
{
    _jz_TextFieldStr = jz_TextFieldStr;
    _jz_TextField.text = _jz_TextFieldStr;
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end


@implementation JZTextField

- (void)paste:(nullable id)sender {

    UIPasteboard *tmpBoard = [UIPasteboard  generalPasteboard];
    NSString *contentStr = [tmpBoard string];
    self.text = JZIFISNULL(contentStr);
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
}

@end
