//
//  CustomSearchBar.m
//  CustomSearchBar
//
//  Created by mahaitao on 2017/5/26.
//  Copyright © 2017年 summer. All rights reserved.
//

#import "JZCustomSearchBar.h"


#define DefulatPlacehoderString @"搜索"
#define JZ_IOS9  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface JZCustomSearchBar ()
{
    CGRect _searchBarFrame;
}
@end

@implementation JZCustomSearchBar


#pragma mark -- override  initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self){
        [self setupWithFrame:frame];
    }
    return self;
}

#pragma mark -- public 	initialization
- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)iconImage placeholderString:(NSString *)placehoderString
{
    self = [super initWithFrame:frame];
    if (self ) {
        self.iconImage = iconImage;
        self.placeholderString = placehoderString;
        [self setupWithFrame:frame];
    }
    return self;
}

#pragma mark -- private method
- (void)setupWithFrame:(CGRect)frame
{
    _searchBarFrame = frame;
  
    self.placeholder = self.placeholderString?self.placeholderString:DefulatPlacehoderString;
    
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.clearButtonMode = UITextFieldViewModeNever;
    }
    
    if (JZ_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    }

//    [self layoutSubviews];
//    [self updateSearchFieldFrameWithCancleBtnWidth:0];
    
}
//- (void)updateSearchFieldFrameWithCancleBtnWidth:(CGFloat)width {
//    CGFloat leftSpace = 8;   //Default: 8.0
//    CGFloat topSpace = 7;    //Default: (self.bounds.height - 28.0) / 2.0
//    CGFloat rightSpace = leftSpace;
//    CGFloat bottomSpace = topSpace;
//    UITextField *searchField = [self valueForKey:@"_searchField"];
//    searchField.frame = CGRectMake(_searchBarFrame.origin.x + leftSpace, _searchBarFrame.origin.y + topSpace, _searchBarFrame.size.width - leftSpace - rightSpace-width-width, _searchBarFrame.size.height - topSpace - bottomSpace);
//
//}
//-(void) layoutSubviews{
//    
//    [super layoutSubviews];
//    
//    
//    CGFloat leftSpace = 8;   //Default: 8.0
//    CGFloat topSpace = 0;    //Default: (self.bounds.height - 28.0) / 2.0
//    CGFloat rightSpace = leftSpace;
//    CGFloat bottomSpace = topSpace;
//    UITextField *searchField = [self valueForKey:@"_searchField"];
//    searchField.frame = CGRectMake(_searchBarFrame.origin.x + leftSpace, _searchBarFrame.origin.y + topSpace, _searchBarFrame.size.width - leftSpace - rightSpace, _searchBarFrame.size.height - topSpace - bottomSpace);
//}
#pragma mark -- 属性
/**
 *  外边框颜色
 */
-(void)setBoardColor:(UIColor *)boardColor {
    _boardColor = boardColor;
    self.layer.borderColor = boardColor.CGColor;
}
/**
 *  外边框宽度
 */
- (void)setBoardLineWidth:(CGFloat)boardLineWidth {
    _boardLineWidth = boardLineWidth;
    self.layer.borderWidth = boardLineWidth;
}
/**
 *  外边框圆角
 */
- (void)setBoardCornerRadius:(CGFloat)boardCornerRadius {
    _boardCornerRadius = boardCornerRadius;
    self.layer.cornerRadius = boardCornerRadius;
    self.layer.masksToBounds = YES;
}
/**
 *  设置searchbar背景色
 */
- (void)setSearchBarBgc:(UIColor *)searchBarBgc {
    _searchBarBgc = searchBarBgc;
    self.barTintColor = searchBarBgc;
}
/**
 *  textField边框颜色
 */
- (void)setTextFieldBorderColor:(UIColor *)textFieldBorderColor {
    _textFieldBorderColor = textFieldBorderColor;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.layer.borderColor = textFieldBorderColor.CGColor;
    }
}
/**
 *  textField边框宽度
 */
- (void)setTextFieldBorderWidth:(CGFloat)textFieldBorderWidth {
    _textFieldBorderWidth = textFieldBorderWidth;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.layer.borderWidth = textFieldBorderWidth;
    }
}
/**
 *  textField边框圆角
 */
- (void)setTextFieldRadius:(CGFloat)textFieldRadius {
    _textFieldRadius = textFieldRadius;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.layer.cornerRadius = textFieldRadius;
        searchField.layer.masksToBounds = YES;
    }
}
/**
 *  textField字体大小
 */
- (void)setTextFieldFont:(CGFloat)textFieldFont {
    _textFieldFont = textFieldFont;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.font = [UIFont systemFontOfSize:textFieldFont];
    }
}
/**
 *  textField字体颜色
 */
- (void)setTextFieldTextColor:(UIColor *)textFieldTextColor {
    _textFieldTextColor = textFieldTextColor;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        searchField.textColor = textFieldTextColor;
        
    }
}
/**
 *  textField光标颜色
 */
- (void)setTextFieldCursorColor:(UIColor *)textFieldCursorColor {
    _textFieldCursorColor = textFieldCursorColor;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setTintColor:textFieldCursorColor];
    }
}
/**
 *  textField背景颜色
 */
- (void)setTextFieldBgc:(UIColor *)textFieldBgc {
    _textFieldBgc = textFieldBgc;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setBackgroundColor:textFieldBgc];
    }
}
/**
 *  设置取消按钮的颜色
 */
- (void)setCancleBtnColor:(UIColor *)cancleBtnColor {
    _cancleBtnColor = cancleBtnColor;
    self.tintColor = cancleBtnColor;
}
/**
 *  设置取消按钮的标题
 */
- (void)setCancleBtnTitle:(NSString *)cancleBtnTitle {
    _cancleBtnTitle = cancleBtnTitle;
    if (JZ_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:cancleBtnTitle];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:cancleBtnTitle];
    }
}
/**
 *  设置取消按钮的大小
 */
- (void)setCancleBtnFont:(CGFloat)cancleBtnFont {
    _cancleBtnFont = cancleBtnFont;
    NSDictionary *textAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:cancleBtnFont]};
    if (JZ_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    }
}
/**
 *  搜索提示语
 */
- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    self.placeholder = placeholderString;
}
/**
 *  搜索提示语颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}
/**
 *  搜索提示语大小
 */
- (void)setPlaceholderFont:(CGFloat)placeholderFont {
    _placeholderFont = placeholderFont;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:[UIFont systemFontOfSize:placeholderFont] forKeyPath:@"_placeholderLabel.font"];
    }
}
/**
 *  搜索图标
 */
- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    if (iconImage) {
        [self setImage:iconImage
      forSearchBarIcon:UISearchBarIconSearch
                 state:UIControlStateNormal];
    }
}
/**
 *  是否删除背景view
 */
- (void)setIsRemoveBackview:(BOOL)isRemoveBackview {
    _isRemoveBackview = isRemoveBackview;
    if (isRemoveBackview) {
        for (UIView *view in self.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
}
/**
 *  是否展示删除按钮
 */
- (void)setIsShowClearBtn:(BOOL)isShowClearBtn {
    _isShowClearBtn = isShowClearBtn;
    if (isShowClearBtn) {
        UITextField *searchField = [self valueForKey:@"_searchField"];
        if (searchField) {
            searchField.clearButtonMode = UITextFieldViewModeAlways;
        }
    }
}
#pragma mark - 遍历改变搜索框 取消按钮的文字颜色(取消时取消按钮依旧可以点击)
+ (void)changeSearchBarCancelView:(UIView *)view  title:(NSString *)title  color:(UIColor *)color  font:(UIFont *)font
{
    if (view) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *cancleBtn = (UIButton *)view;
            [cancleBtn setEnabled:YES];//设置可用
            [cancleBtn setUserInteractionEnabled:YES];
            
            if (title) {
                [cancleBtn setTitle:title forState:UIControlStateNormal];
            }
            if (color) {
                [cancleBtn setTitleColor:color forState:UIControlStateNormal];
            }
            if (font) {
                cancleBtn.titleLabel.font = font;
            }
            return;
        }else{
            for (UIView *subView in view.subviews) {
                [JZCustomSearchBar changeSearchBarCancelView:subView title:title color:color font:font];
            }
        }
        
    }else{
        
        return;
    }
}

@end
