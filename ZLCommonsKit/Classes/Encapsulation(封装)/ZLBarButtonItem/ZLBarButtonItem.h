//
//  ZLBarButtonItem.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLTabBarItem.h"

@class ZLBarButtonItem;
@protocol  ZLBarButtonItemViewDelegate <NSObject>

- (void)barButtonItem:(ZLBarButtonItem *)barButtonItem didSelectButton:(UIButton *)selectButton;
//
@end

@interface ZLBarButtonItem : UIView

/*! @brief *
 *  badge的样式，支持数字样式和小圆点
 */
@property (nonatomic, assign) ZLTabItemBadgeStyle badgeStyle;

@property (nonatomic ,weak) id<ZLBarButtonItemViewDelegate> delegate;

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
