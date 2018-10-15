//
//  JZClickButton.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZClickButton.h"
#import <Masonry/Masonry.h>

@interface JZClickButton ()

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end
@implementation JZClickButton

- (instancetype)initWithClickButtonType:(ClickButtonType)clickBtnType
{
    self = [super init];
    if (self) {
        _clickBtnType = clickBtnType;
        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicatorColor = [UIColor whiteColor];
        [self addSubview:self.activityView];
    }
    return self;
}
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.userInteractionEnabled = NO;
        //        _activityView.hidesWhenStopped = NO;
    }
    return _activityView;
}
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
}
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
}
- (void)startRequest
{
    //    self.userInteractionEnabled = NO;
    self.activityView.activityIndicatorViewStyle = _activityIndicatorViewStyle;
    self.activityView.color = (UIColor *)self.indicatorColor;
    if (_clickBtnType == ClickButtonTypeActivityIndicator) {
        [self setTitle:@"" forState:UIControlStateNormal];
        [self bringSubviewToFront:_activityView];
        [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).mas_offset(0);
        }];
    }else if (_clickBtnType == ClickButtonTypeActivityIndicatorAndText){
        //获取当前按钮的宽度
        CGFloat self_Width = CGRectGetWidth(self.frame);
        
        CGFloat width = (self_Width - CGRectGetWidth(self.titleLabel.frame)) / 2;
        
        CGSize indicatorSize = CGSizeZero;
        //当前加载框的大小
        if (_activityIndicatorViewStyle == UIActivityIndicatorViewStyleWhiteLarge) {
            indicatorSize = CGSizeMake(37, 37);
        }else{
            indicatorSize = CGSizeMake(22, 22);
        }
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).mas_offset(width - indicatorSize.width);
            make.size.mas_equalTo(indicatorSize);
        }];
    }
    [self.activityView startAnimating];
}
- (void)endRequest
{
    [self endRequestWithChangeName:nil withColor:nil withChangeImg:nil];
}

- (void)endRequestWithChangeName:(NSString *)titleName withColor:(UIColor *)nameColor
{
    [self endRequestWithChangeName:titleName withColor:nameColor withChangeImg:nil];
}

- (void)endRequestWithChangeName:(NSString *)titleName withColor:(UIColor *)nameColor withChangeImg:(NSString *)imgName
{
    [self.activityView stopAnimating];
    //     self.userInteractionEnabled = YES;
    if ([titleName length] != 0 && titleName != nil) {
        [self setTitle:titleName forState:UIControlStateNormal];
    }
    if (nameColor) {
        [self setTitleColor:nameColor forState:UIControlStateNormal];
    }
    if ([imgName length] != 0 && imgName != nil) {
        [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
}
@end
