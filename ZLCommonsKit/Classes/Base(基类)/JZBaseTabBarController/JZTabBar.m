//
//  JZTabBar.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZTabBar.h"
#import "JZSystemMacrocDefine.h"

@interface JZTabBar ()
@property(nonatomic, nonnull,strong) UIImageView *lineImv;
@end

@implementation JZTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}
- (void)initializer{
    

}

- (void)tabBarShowShadowColor{
    self.layer.shadowColor = UIColorFromHex(0xdddddd).CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setTabBarButtonFrame];
}

//设置所有TabbarItem的frame
- (void)setTabBarButtonFrame
{
    //遍历所有的button
    for (UIView *tabbarButton in self.subviews) {
        if (![tabbarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        // 隐藏系统的tabbarButton
        tabbarButton.hidden  = YES;
    }
    
}

//#pragma mark -  画线
///*! @brief *
// @brief 画水平细线
// @param lineColor 细线颜色 nil:默认0xcccccc
// @param lineWidth 细线宽度lineWidth
// */
//- (UIImage*)drawHerLine:(UIColor*)lineColor lineWidth:(NSInteger)lineWidth
//{
//    lineColor=lineColor==nil?[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]:lineColor;
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(lineWidth, 0.5), NO, 0);
//    CGContextRef gc = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(gc, 0.5);
//    [lineColor setStroke];
//    CGContextMoveToPoint(gc,0,0);
//    CGContextAddLineToPoint(gc, lineWidth, 0);
//    CGContextClosePath(gc);
//    CGContextStrokePath(gc);
//    UIImage *lineImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return lineImg;
//}
//
//#pragma mark - 约束
//- (void)makeConstraints{
//    [self.lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top);
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.height.mas_equalTo(0.5);
//    }];
//}
//
//#pragma mark - 懒加载
//- (UIImageView *)lineImv{
//    if (!_lineImv) {
//        _lineImv = [[UIImageView alloc]init];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage * image = [self drawHerLine:nil lineWidth:kScreenWidth];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _lineImv.image = image;
//            });
//        });
//        
//    }
//    return _lineImv;
//}
//

@end
