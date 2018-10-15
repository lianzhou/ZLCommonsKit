//
//  JZBarButtonItem.h
//  eStudy(comprehensive)
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZTabBarItem.h"

@class JZBarButtonItem;
@protocol  JZBarButtonItemViewDelegate <NSObject>

- (void)barButtonItem:(JZBarButtonItem *)barButtonItem didSelectButton:(UIButton *)selectButton;
//
@end

@interface JZBarButtonItem : UIView

/*! @brief *
 *  badge的样式，支持数字样式和小圆点
 */
@property (nonatomic, assign) JZTabItemBadgeStyle badgeStyle;

@property (nonatomic ,weak) id<JZBarButtonItemViewDelegate> delegate;

//标题
@property (nonatomic, copy)   NSString *title;

//图片
@property (nonatomic, copy)   NSString *titleImage;

//气泡个数
@property (nonatomic, assign) NSInteger badge;

//标题颜色
@property (nonatomic, assign) UIColor * titleColor;

//气泡文字颜色
@property (nonatomic, assign) UIColor * badgeNumberColor;

//气泡背景颜色
@property (nonatomic, assign) UIColor * badgeColor;

- (void)setTitleImage:(NSString *)titleImage forState:(UIControlState)state;
@end
