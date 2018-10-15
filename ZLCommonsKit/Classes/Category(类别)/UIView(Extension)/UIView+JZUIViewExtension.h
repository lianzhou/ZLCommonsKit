//
//  UIView+JZUIViewExtension.h
//  eStudy
//
//  Created by wangjingfei on 2017/6/8.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JZUIViewExtension)

- (UIImage *)captureWithSize:(CGSize)size;
- (UIImage *)capture;

- (void)jz_setTarget:(id)target action:(SEL)action;
- (void)jz_setLongTarget:(id)target action:(SEL)action;

//设置圆角的位置
- (void)bezierPathWithCornerRadius;
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner;
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii;
//设置圆角的位置
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii withFrame:(CGRect)frame;
/**
 添加渐变的背景颜色

 @param array 渐变颜色的数组
 @param rect 渐变颜色的大小
 @param startPoint 渐变的起始位置
 @param stopPoint 渐变的结束位置
 @param poinyArray 渐变位置的数组
 @return CAGradientLayer
 */
- (CAGradientLayer *)addsGradientBackgroundColor:(NSArray <UIColor *>*)array withCurrentViewFrame:(CGRect)rect withTheStartPositions:(CGPoint)startPoint withStopPositions:(CGPoint)stopPoint withColorPointOfDivision:(NSArray <NSNumber *>*)poinyArray;
@end

@interface UIView (ShakeAnimation)

// 左右shake
- (void)shake;

@end

@interface UIView (RelativeCoordinate)

- (BOOL)isSubContentOf:(UIView *)aSuperView;

- (CGRect)relativePositionTo:(UIView *)aSuperView;

@end

//视觉差
@interface UIView (MotionEffect)

@property (nonatomic, strong) UIMotionEffectGroup *effectGroup;

- (void)addXAxisWithValue:(CGFloat)xValue YAxisWithValue:(CGFloat)yValue;
- (void)removeSelfMotionEffect;

@end

