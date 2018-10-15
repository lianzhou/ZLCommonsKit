//
//  UIView+JZUIViewExtension.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "UIView+JZUIViewExtension.h"
#import "JZSystemMacrocDefine.h"
#import <objc/runtime.h>

@implementation UIView (JZUIViewExtension)

- (UIImage *)captureWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIImage *)capture
{
    return  [self captureWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)jz_setTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
}
//长按
- (void)jz_setLongTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    //    longpressGesutre.allowableMovement=NO;
    longpressGesutre.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longpressGesutre];
}
//设置圆角的位置
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii withFrame:(CGRect)frame {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corner cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

//设置圆角的位置
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii
{
    [self bezierPathWithRoundedRectWith:corner cornerRadii:cornerRadii withFrame:self.bounds];
}
//设置圆角的位置
- (void)bezierPathWithRoundedRectWith:(UIRectCorner)corner
{
    [self bezierPathWithRoundedRectWith:corner cornerRadii:self.bounds.size withFrame:self.bounds];
}
- (void)bezierPathWithCornerRadius{
    [self bezierPathWithRoundedRectWith:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.bounds.size.height/2, self.bounds.size.height/2) withFrame:self.bounds];
}
//添加渐变的背景颜色
- (CAGradientLayer *)addsGradientBackgroundColor:(NSArray <UIColor *>*)array withCurrentViewFrame:(CGRect)rect withTheStartPositions:(CGPoint)startPoint withStopPositions:(CGPoint)stopPoint withColorPointOfDivision:(NSArray <NSNumber *>*)poinyArray
{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = stopPoint;
    //设置颜色数组
    NSMutableArray *newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newArray addObject:(__bridge id)obj.CGColor];
    }];
    gradientLayer.colors = newArray;
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = poinyArray;
    return gradientLayer;
}
@end


@implementation UIView (ShakeAnimation)

- (void)shake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    self.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if(finished)
        {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
@implementation UIView (RelativeCoordinate)

- (BOOL)isSubContentOf:(UIView *)aSuperView
{
    if (self == aSuperView)
    {
        return YES;
    }
    else
    {
        return [self.superview isSubContentOf:aSuperView];
    }
}


- (CGRect)relativePositionTo:(UIView *)aSuperView
{
    BOOL isSubContentOf = [self isSubContentOf:aSuperView];
    
    while (isSubContentOf)
    {
        return [self relativeTo:aSuperView];
    }
    
    return CGRectZero;
    
}

- (CGRect)relativeTo:(UIView *)aSuperView
{
    CGPoint originPoint = CGPointZero;
    UIView *view = self;
    while (!(view == aSuperView))
    {
        originPoint.x += view.frame.origin.x;
        originPoint.y += view.frame.origin.y;
        
        if ([view isKindOfClass:[UIScrollView class]])
        {
            originPoint.x -= ((UIScrollView *) view).contentOffset.x;
            originPoint.y -= ((UIScrollView *) view).contentOffset.y;
        }
        
        view = view.superview;
    }
    
    // TODO:如果SuperView是UIWindow,需要结合Transform计算
    return CGRectMake(originPoint.x, originPoint.y, self.frame.size.width, self.frame.size.height);
}

@end


static char motionEffectFlag;
@implementation UIView (MotionEffect)

- (void)setEffectGroup:(UIMotionEffectGroup *)effectGroup {
    // 清除关联
    objc_setAssociatedObject(self, &motionEffectFlag, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 建立关联
    objc_setAssociatedObject(self, &motionEffectFlag, effectGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIMotionEffectGroup *)effectGroup {
    // 返回关联
    return objc_getAssociatedObject(self, &motionEffectFlag);
}

- (void)addXAxisWithValue:(CGFloat)xValue YAxisWithValue:(CGFloat)yValue {
    if ((xValue >= 0) && (yValue >= 0)) {
        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = @(-xValue);
        xAxis.maximumRelativeValue = @(xValue);
        
        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = @(-yValue);
        yAxis.maximumRelativeValue = @(yValue);
        
        // 先移除效果再添加效果
        self.effectGroup.motionEffects = nil;
        [self removeMotionEffect:self.effectGroup];
        self.effectGroup.motionEffects = @[xAxis, yAxis];
        
        // 给view添加效果
        [self addMotionEffect:self.effectGroup];
    }
}

- (void)removeSelfMotionEffect {
    [self removeMotionEffect:self.effectGroup];
}



@end

