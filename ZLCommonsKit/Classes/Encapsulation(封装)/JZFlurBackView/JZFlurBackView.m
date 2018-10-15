//
//  JZFlurBackView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "JZFlurBackView.h"
#import "JZSystemMacrocDefine.h"
#import "Masonry.h"
@interface JZFlurBackView ()

@end

@implementation JZFlurBackView


+ (instancetype)sharenInstance
{
    static JZFlurBackView *backView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backView = [[JZFlurBackView alloc]init];
    });
    return backView;
}


- (UIView *)normalBackView
{
    if (!_normalBackView) {
        _normalBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _normalBackView.backgroundColor = [UIColor clearColor];
//        UITapGestureRecognizer *tapGus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView:)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _normalBackView.frame;
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0.5;
        [btn addTarget:self action:@selector(hidenView:) forControlEvents:UIControlEventTouchUpInside];
        [_normalBackView addSubview:btn];
//        [_normalBackView addGestureRecognizer:tapGus];
    }
    return _normalBackView;
}


- (UIView *)blurBackView
{
    if (!_blurBackView) {
        _blurBackView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        ((UIToolbar *)_blurBackView).barStyle = UIBarStyleDefault;
        ((UIToolbar *)_blurBackView).translucent = YES;    
        _blurBackView.multipleTouchEnabled = NO;
        _blurBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

        UITapGestureRecognizer *tapGus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView:)];
        [_blurBackView addGestureRecognizer:tapGus];
    }
    return _blurBackView;
}

- (UIView *)changeBlackView {
    if (!_changeBlackView) {
        _changeBlackView = [[UIView alloc] initWithFrame:CGRectZero];
        _changeBlackView.backgroundColor = [UIColor blackColor];
        _changeBlackView.alpha = 0.5;
//        UITapGestureRecognizer *tapGus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView:)];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
////        btn.frame = _normalBackView.frame;
//        [_changeBlackView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_changeBlackView);
//        }];
//        btn.backgroundColor = [UIColor blackColor];
//        btn.alpha = 0.5;
//        [btn addTarget:self action:@selector(hidenView:) forControlEvents:UIControlEventTouchUpInside];
//        [_changeBlackView addGestureRecognizer:tapGus];
    }
    return _changeBlackView;
}

- (void)hidenView:(UITapGestureRecognizer *)tapSender
{
    [_normalBackView removeFromSuperview];
    [_blurBackView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(flurBackViewhiden:)]) {
        [self.delegate flurBackViewhiden:self];
    }
}

@end
