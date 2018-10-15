//
//  JZBaseViewController+NavigationConfig.h
//  eStudy
//
//  Created by zhoulian on 17/5/17.
//

#import "JZBaseViewController.h"

@interface JZBaseViewController (NavigationConfig)

#pragma mark -- 设置左边的UIBarButtonItem
- (void)setNavigationBarLeftItemTitle:(NSString *)title;
- (void)setNavigationBarLeftItemimage:(NSString *)iconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName stateDisabledImage:(NSString *)disableIconName;

#pragma mark -- 设置右边的UIBarButtonItem

@property (nonatomic, strong) UIButton *jz_navigationBarRightButton;


- (void)setNavigationBarRightItemTitle:(NSString *)title;
- (void)setNavigationBarRightItemimage:(NSString *)iconName;
- (void)setNavigationBarRightItemTitle:(NSString *)title image:(NSString *)iconName;
- (void)setNavigationBarRightItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName;
- (void)setNavigationBarRightItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName stateDisabledImage:(NSString *)disableIconName;

#pragma mark -- 在左边或者右边增加UIBarButtonItem
- (void)appendRightBarItemWithCustomButton:(UIButton *)button atIndex:(NSUInteger)index;
- (void)appendLeftBarItemWithCustomButton:(UIButton *)button atIndex:(NSUInteger)index;
- (void)appendBarItemWithCustomButton:(UIButton *)button atIndex:(NSUInteger)index isLeft:(BOOL)isLeft;

- (void)leftButtonPressed:(UIButton *)sender;
- (void)rightButtonPressed:(UIButton *)sender;

@end
