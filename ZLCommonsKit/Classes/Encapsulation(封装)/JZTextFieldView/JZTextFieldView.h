//
//  JZTextFieldView.h
//  eStudy
//
//  Created by wangjingfei on 2017/8/14.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZTextField;

@interface JZTextFieldView : UIView

//是否显示右边视图
@property (nonatomic,assign) UITextFieldViewMode  jz_RightViewMode;

//右边视图
@property (nonatomic,strong) UIView *jz_RightView;

//是否显示左边视图
@property (nonatomic,assign) UITextFieldViewMode  jz_LeftViewMode;

//左边视图
@property (nonatomic,strong) UIView *jz_LeftView;

//设置TextField的边框样式
@property (nonatomic,assign)  UITextBorderStyle  jz_BorderStyle;

//清空内容按钮的出现时间 默认是不出现的
@property (nonatomic,assign) UITextFieldViewMode  jz_ClearButtonMode;

//是否在开始编辑时清空输入框
@property (nonatomic,assign)  BOOL  jz_ClearsOnBeginEditing;

//内容显示的位置
@property (nonatomic,assign) NSTextAlignment  jz_TextAlignment;

//字体大小 默认大小是12.0f
@property (nonatomic,strong) UIFont *jz_Font;

//字体颜色 默认字体颜色是黑色
@property (nonatomic,strong) UIColor *jz_TextColor;

//设置默认内容 默认内容为空
@property (nonatomic,copy) NSString *jz_placeHolderStr;

//是否显示线 默认是显示 YES
@property (nonatomic,assign) BOOL isShowLine;

//编辑时线的颜色是否发生变化 默认是NO
@property (nonatomic,assign) BOOL isChange;

//设置线的颜色 默认颜色是黑色
@property (nonatomic,strong) UIColor *lineColor;

//设置线颜色的alpha值 默认值为 1.0f
@property (nonatomic,assign) CGFloat jz_alpha;

//变化的颜色的alpha
@property (nonatomic,assign) CGFloat jz_ChangeAlpha;

//光线颜色 默认是蓝色
@property (nonatomic,strong) UIColor *jz_TintColor;

//设置键盘的样式 默认UIKeyboardTypeDefault
@property (nonatomic,assign) UIKeyboardType jz_KeyboardType;

//密码是否明文显示 默认是明文显示   NO
@property (nonatomic,assign) BOOL jz_SecureTextEntry;

//输入框
@property (nonatomic,strong) JZTextField *jz_TextField;

@property (nonatomic,copy) NSString *jz_TextFieldStr;

//成为第一响应者
- (void)jz_BecomeFirstResponder;
//取消成为第一响应者
- (void)jz_ResignFirstResponder;


@end

@interface JZTextField : UITextField

@end
