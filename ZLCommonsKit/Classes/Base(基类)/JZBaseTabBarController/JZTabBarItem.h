//
//  JZTabBarItem.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/22.
//

#import <Foundation/Foundation.h>

/*! @brief *
 *  Badge样式
 */
typedef NS_ENUM(NSInteger, JZTabItemBadgeStyle) {
    JZTabItemBadgeStyleNumber = 0, // 数字样式
    JZTabItemBadgeStyleDot = 1, // 小圆点
    JZTabItemBadgeStyleHidden = 2, // 隐藏
};

@interface JZTabBarItem : UIButton


@property (nonatomic, assign,readonly) BOOL isTop;

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *topSelectedImage;

/*! @brief *
 *  当badgeStyle == YPTabItemBadgeStyleNumber时，可以设置此属性，显示badge数值
 *  badge > 99，显示99+
 *  badge <= 99 && badge > -99，显示具体数值
 *  badge < -99，显示-99+
 */
@property (nonatomic, assign) NSInteger badge;

/*! @brief *
 *  badge的样式，支持数字样式和小圆点
 */
@property (nonatomic, assign) JZTabItemBadgeStyle badgeStyle;

/*! @brief *
 *  badge的背景颜色
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/*! @brief *
 *  badge的背景图片
 */
@property (nonatomic, strong) UIImage *badgeBackgroundImage;

/*! @brief *
 *  badge的标题颜色
 */
@property (nonatomic, strong) UIColor *badgeTitleColor;

/*! @brief *
 *  badge的标题字体，默认13号
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

- (void)scaleImageButtonAnimate;
- (void)transformImageButtonM_PI;
- (void)showTopAnimate:(CGFloat)duration;
- (void)hideTopAnimate:(CGFloat)duration;

- (void)removeAllAnimations;
@end
