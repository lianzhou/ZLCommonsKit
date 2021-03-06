//
//  ZLNavigationTopView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLNavigationTopView : UIView
/**
 *  左边按钮
 */
@property (nonatomic, strong) UIButton  *leftBtn;
/**
 *  右边按钮
 */
@property (nonatomic, strong) UIButton  *rightBtn;
/**
 *  背景色
 */
- (void)makeBackgroundColor:(UIColor*)color;

/**
 *  左边btn点击事件
 */
@property (nonatomic, copy) void (^leftBtnClickBlock)(UIButton *button);

/**
 *  右边btn点击事件
 */
@property (nonatomic, copy) void (^rightBtnClickBlock)(UIButton *button);


- (instancetype)initWithFrame:(CGRect)frame  LeftView:(UIView *)leftView  rightView:(UIView *)rightView middleView:(UIView *)middleView;

- (instancetype)initWithFrame:(CGRect)frame  LeftButton:(BOOL)isCreatL  rightButton:(BOOL)isCreatR middelTitle:(NSString*)title;


@end
