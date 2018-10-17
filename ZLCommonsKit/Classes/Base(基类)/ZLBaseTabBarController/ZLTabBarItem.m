//
//  ZLTabBarItem.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLTabBarItem.h"
#import <Masonry/Masonry.h>
#import "ZLSystemMacrocDefine.h"

@interface ZLTabBarItem ()
{
    BOOL _showAnimate;//是否在动画
    BOOL _isShow;//是否显示
}

@property (nonatomic, strong) UIButton *badgeButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *topImageButton;
@property (nonatomic, strong) UIButton *lableButton;

@end
@implementation ZLTabBarItem
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - 初始化
- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    _showAnimate = NO;
    _isShow = NO;
    [self addSubview:self.imageButton];
    [self addSubview:self.topImageButton];
    [self addSubview:self.lableButton];
    [self addSubview:self.badgeButton];

    [self.lableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-5.0f);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.lableButton.mas_top);        
    }];
    
    [self.topImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lableButton.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.imageButton.mas_height);        
    }];
    
    [self.badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.centerX.mas_equalTo(self.imageButton.mas_centerX).mas_equalTo(20);
        make.width.mas_equalTo(10.0f);
        make.height.mas_equalTo(10.0f);     
    }];


}
#pragma mark - Title

- (void)setSelected:(BOOL)selected {
    [self.lableButton setSelected:selected];
    [self.imageButton setSelected:selected];
    [self.topImageButton setSelected:selected];
    [super setSelected:selected];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.lableButton setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.lableButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    [self.lableButton setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8) {
        self.lableButton.titleLabel.font = titleFont;
    }
}
#pragma mark - Image
- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageButton setImage:image forState:UIControlStateNormal];
    
    [self.badgeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageButton.mas_centerX).mas_offset(image.size.width/2);
    }];
    
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self.imageButton setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setTopImage:(UIImage *)topImage{
    _topImage = topImage;
    [self.topImageButton setImage:topImage forState:UIControlStateNormal];

}
- (void)setTopSelectedImage:(UIImage *)topSelectedImage{
    _topSelectedImage = topSelectedImage;
    [self.topImageButton setImage:topSelectedImage forState:UIControlStateSelected];
}

#pragma mark - Badge

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    [self.badgeButton setTitleColor:badgeTitleColor forState:UIControlStateNormal];
}

- (void)setBadgeBackgroundImage:(UIImage *)badgeBackgroundImage {
    _badgeBackgroundImage = badgeBackgroundImage;
    [self.badgeButton setBackgroundImage:badgeBackgroundImage forState:UIControlStateNormal];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    _badgeTitleFont = badgeTitleFont;
    self.badgeButton.titleLabel.font = badgeTitleFont;
    [self updateBadge];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor{
    _badgeBackgroundColor = badgeBackgroundColor;
    self.badgeButton.backgroundColor = badgeBackgroundColor;

}
- (void)setBadge:(NSInteger)badge{
    _badge = badge;
    [self updateBadge];
}
- (void)setBadgeStyle:(ZLTabItemBadgeStyle)badgeStyle {
    _badgeStyle = badgeStyle;
    [self updateBadge];
}
- (void)updateBadge{
    if (self.badgeStyle == ZLTabItemBadgeStyleNumber) {
        if (self.badge == 0) {
            self.badgeButton.hidden = YES;
        } else {
            self.badgeButton.hidden = NO;
            NSString *badgeStr = @(self.badge).stringValue;
            if (self.badge > 99) {
                badgeStr = @"99+";
            }
            CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : self.badgeButton.titleLabel.font}
                                                 context:nil].size;
            CGFloat width = ceilf(size.width)+5;
            CGFloat height = ceilf(size.height)+5;
            
            width = MAX(width, height);
            
            [self.badgeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);        
            }];
            self.badgeButton.layer.cornerRadius = height / 2;
            [self.badgeButton.layer masksToBounds];
            [self.badgeButton setTitle:badgeStr forState:UIControlStateNormal];
            self.badgeButton.hidden = NO;
            [self.badgeButton layoutIfNeeded];
        }
    } else if (self.badgeStyle == ZLTabItemBadgeStyleDot) {
        [self.badgeButton setTitle:nil forState:UIControlStateNormal];
        [self.badgeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(10);        
        }];
        self.badgeButton.layer.cornerRadius = self.badgeButton.bounds.size.height / 2;
        self.badgeButton.hidden = NO;
        [self.badgeButton layoutIfNeeded];

    }else if(self.badgeStyle == ZLTabItemBadgeStyleHidden) {
        self.badgeButton.hidden = YES;
    }

}
#pragma mark - animate
- (void)scaleImageButtonAnimate{
    if (_showAnimate||(_isShow)) {
        return;
    }
    /*! @brief * 缩小到90% */
    [UIView animateWithDuration:0.4/3 animations:^{
        self.imageButton.transform=CGAffineTransformMakeScale(0.9, 0.9);
    }completion:^(BOOL finished) {
        self.imageButton.transform = CGAffineTransformIdentity;
    }];

}
- (void)transformImageButtonM_PI
{
    [UIView animateWithDuration:0.25 animations:^{
        self.imageButton.transform=self.selected?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI_2+M_PI_4);
    } completion:^(BOOL finished) {
        self.selected = !self.selected;
    }];

}
- (void)showTopAnimate:(CGFloat)duration{
    if (_showAnimate||_isShow) {
        return;
    }
    self.topImageButton.alpha = 0.5f;
    self.imageButton.alpha = 1.0f;
    _showAnimate = YES;
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
      
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:duration animations:^{
            self.imageButton.transform=CGAffineTransformMakeScale(0.1, 0.1);
            self.imageButton.alpha = 0.5f;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.6*duration relativeDuration:0.4*duration animations:^{
            self.topImageButton.transform=CGAffineTransformMakeTranslation(0, -40);
            self.topImageButton.alpha = 1.0f;
        }];

    } completion:^(BOOL finished) {
        _showAnimate = NO;
        _isShow = YES;
    }];

}
- (void)hideTopAnimate:(CGFloat)duration{
    if (_showAnimate||(!_isShow)) {
        return;
    }
    _showAnimate = YES;
    self.topImageButton.alpha = 1.0f;
    self.imageButton.alpha = 0.5f;
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:duration animations:^{
            self.topImageButton.transform=CGAffineTransformMakeTranslation(0, -80);
            self.topImageButton.alpha = 1.0f;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.6*duration relativeDuration:0.4*duration animations:^{
            self.imageButton.transform=CGAffineTransformIdentity;
            self.imageButton.alpha = 1.0f;
        }];
        
        
    } completion:^(BOOL finished) {
        self.topImageButton.transform = CGAffineTransformIdentity;
        _showAnimate = NO;
        _isShow = NO;

    }];
    
}
- (void)removeAllAnimations{
    [self.imageButton.layer removeAllAnimations];
    [self.topImageButton.layer removeAllAnimations];
}

#pragma mark - 懒加载
- (BOOL)isTop{
    return _isShow;
}
- (UIButton *)badgeButton{
    if (!_badgeButton) {
        _badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _badgeButton.userInteractionEnabled = NO;
        _badgeButton.clipsToBounds = YES;
        _badgeButton.adjustsImageWhenHighlighted = NO;
        _badgeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _badgeButton.backgroundColor = UIColorFromRGB(0xff6f26);
        _badgeButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        _badgeButton.hidden = YES;
    }
    return _badgeButton;
}
- (UIButton *)imageButton{
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.userInteractionEnabled = NO;
        _imageButton.clipsToBounds = YES;
        _imageButton.adjustsImageWhenHighlighted = NO;
        _imageButton.backgroundColor = [UIColor whiteColor];

    }
    return _imageButton;
}
- (UIButton *)topImageButton{
    if (!_topImageButton) {
        _topImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topImageButton.userInteractionEnabled = NO;
        _topImageButton.clipsToBounds = YES;
        _topImageButton.adjustsImageWhenHighlighted = NO;
        _topImageButton.backgroundColor = [UIColor whiteColor];

    }
    return _topImageButton;
}
- (UIButton *)lableButton{
    if (!_lableButton) {
        _lableButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lableButton.userInteractionEnabled = NO;
        _lableButton.clipsToBounds = YES;
        _lableButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _lableButton.adjustsImageWhenHighlighted = NO;
        _lableButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _lableButton.backgroundColor = [UIColor whiteColor];
    }
    return _lableButton;
}

@end
