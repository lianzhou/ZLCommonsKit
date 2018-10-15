//
//  JZClickButton.h
//  eStudy
//
//  Created by wangjingfei on 2017/7/20.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,ClickButtonType) {
    ClickButtonTypeActivityIndicator = 0,//加载框按钮(加载时只显示加载框)
    ClickButtonTypeActivityIndicatorAndText,//加载框按钮(加载时显示加载框和汉字)
};

@interface JZClickButton : UIButton
@property (nonatomic,assign) ClickButtonType clickBtnType;

//加载框显示的样式
@property (nonatomic,assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

//加载框颜色
@property (nonatomic,strong) UIColor *indicatorColor;

- (instancetype)initWithClickButtonType:(ClickButtonType)clickBtnType;

//开始加载
- (void)startRequest;

//结束加载
- (void)endRequest;

/**
 停止加载（加载成功）
 
 @param titleName 修改button上的汉字
 @param nameColor 修改button上汉字的颜色
 */
- (void)endRequestWithChangeName:(NSString *)titleName withColor:(UIColor *)nameColor;

/**
 停止加载（加载成功）
 
 @param titleName 修改button上的汉字
 @param nameColor 修改button上汉字的颜色
 @param imgName 修改button上图片
 */
- (void)endRequestWithChangeName:(NSString *)titleName withColor:(UIColor *)nameColor withChangeImg:(NSString *)imgName;

@end
