//
//  ENProgressView.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/11.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENProgressView.h"

#define Space 10.f
#define Yellow [UIColor colorWithRed:0.9725 green:0.7412 blue:0.1725 alpha:1]

@interface ENProgressView ()

@property(nonatomic,assign) BOOL isCircular;

@end

@implementation ENProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializer];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}
- (void)initializer {
    self.backgroundColor = [UIColor colorWithRed:207.0f/255.0f green:202.0f/255.0f blue:198.0f/255.0f alpha:1];
    self.isCircular = NO;
    self.layer.masksToBounds = YES;
}

- (void)updateWidthConstraints:(CGFloat)width completion:(void (^)(BOOL finished))completion {

    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
        [self.superview layoutIfNeeded];
        self.layer.cornerRadius = width/2;

    } completion:completion];
}

- (void)setProgress:(CGFloat)progress {
    if (progress >= 100.f) {
        _progress = 100.f;
    }

    self.isCircular = progress > 0.0;

    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [self drawBackground];
    [self drawProgressLine];
}

- (void)drawProgressLine {
    [self drawCircleDashed];
}

- (void)drawBackground {
    CGRect rect = self.bounds;
    self.layer.cornerRadius = rect.size.width/2;

    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat aspectRatio =  1.0f/3.0f;
    if (self.isCircular) {
         aspectRatio =  1.0f/6.0f;
    }
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * aspectRatio;
    // draw pie
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor whiteColor] setFill];
    [path fill];
}

- (void)drawCircleDashed{
    if (!self.isCircular) {
        return;
    }
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    
    CGFloat aspectRatio =  MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 1.0f/24.0f;
    
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - aspectRatio / 2;
//    CGFloat endAngle = 2 * M_PI;
//    CGFloat startAngle = 0;
//    if (!dash) {
       
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI * 2 * self.progress / 100.f - M_PI_2;
//    }
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    if (dash) {
//        CGFloat lengths[] = {2, 6};
//        [path setLineDash:lengths count:2 phase:0];
//    }
//    if (dash) {
//        [path setLineWidth:LineWidth];
//        [[UIColor colorWithRed:207.0f/255.0f green:202.0f/255.0f blue:198.0f/255.0f alpha:1] setStroke];
//    }else{
        [path setLineWidth:aspectRatio];
        [[UIColor greenColor] setStroke];
//    }
    [path stroke];
}

@end
