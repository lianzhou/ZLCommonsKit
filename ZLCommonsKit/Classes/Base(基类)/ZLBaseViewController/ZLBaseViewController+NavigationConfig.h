//
//  ZLBaseViewController+NavigationConfig.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface ZLBaseViewController (NavigationConfig)

#pragma mark -- 设置左边的UIBarButtonItem
- (void)setNavigationBarLeftItemTitle:(NSString *)title;
- (void)setNavigationBarLeftItemimage:(NSString *)iconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName;
- (void)setNavigationBarLeftItemTitle:(NSString *)title image:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName stateDisabledImage:(NSString *)disableIconName;

#pragma mark -- 设置右边的UIBarButtonItem

@property (nonatomic, strong) UIButton *zl_navigationBarRightButton;


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
