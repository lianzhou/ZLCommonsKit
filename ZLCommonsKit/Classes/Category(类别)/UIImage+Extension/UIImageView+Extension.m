//
//  UIImageView+Extension.m
//  LQXMMPChat
//
//  Created by adam on 2017/3/28.
//  Copyright © 2017年 Liqing. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (UIImageView *)shapeLayerWithBezierPathToDrawCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:self.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self;
}

@end
