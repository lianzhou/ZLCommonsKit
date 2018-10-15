//
//  CustomSearchBar.h
//  CustomSearchBar
//
//  Created by mahaitao on 2017/5/26.
//  Copyright © 2017年 summer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZCustomSearchBar : UISearchBar
/**
 *  外边框颜色
 */
@property (nonatomic,strong) UIColor  *boardColor;
/**
 *  外边框宽度
 */
@property (nonatomic,assign) CGFloat  boardLineWidth;
/**
 *  外边框圆角
 */
@property (nonatomic,assign) CGFloat  boardCornerRadius;
/**
 *  searchBar背景颜色
 */
@property (nonatomic,strong) UIColor  *searchBarBgc;
/**
 *  textField边框颜色
 */
@property (nonatomic,strong) UIColor  *textFieldBorderColor;
/**
 *  textField边框宽度
 */
@property (nonatomic,assign) CGFloat  textFieldBorderWidth;
/**
 *  textField边框圆角
 */
@property (nonatomic,assign) CGFloat  textFieldRadius;
/**
 *  textField字体大小
 */
@property (nonatomic,assign) CGFloat  textFieldFont;
/**
 *  textField字体颜色
 */
@property (nonatomic,strong) UIColor  *textFieldTextColor;
/**
 *  textField光标颜色
 */
@property (nonatomic,strong) UIColor  *textFieldCursorColor;
/**
 *  textField背景颜色
 */
@property (nonatomic,strong) UIColor  *textFieldBgc;
/**
 *  取消按钮的颜色
 */
@property (nonatomic,strong) UIColor  *cancleBtnColor;
/**
 *  取消按钮的大小
 */
@property (nonatomic,assign) CGFloat  cancleBtnFont;
/**
 *  取消按钮的标题
 */
@property (nonatomic,copy)  NSString  *cancleBtnTitle;
/**
 *  搜索提示语
 */
@property (nonatomic,copy)  NSString  *placeholderString;
/**
 *  搜索提示语颜色
 */
@property (nonatomic,strong)  UIColor *placeholderColor;
/**
 *  搜索提示语大小
 */
@property (nonatomic,assign)  CGFloat placeholderFont;
/**
 *  搜索图标
 */
@property (nonatomic,strong) UIImage  *iconImage;
/**
 *  是否删除背景view
 */
@property (nonatomic,assign) BOOL     isRemoveBackview;
/**
 *  是否展示删除按钮
 */
@property (nonatomic,assign) BOOL     isShowClearBtn;

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)iconImage placeholderString:(NSString *)placehoderString;

+ (void)changeSearchBarCancelView:(UIView *)view  title:(NSString *)title  color:(UIColor *)color  font:(UIFont *)font;;

@end
