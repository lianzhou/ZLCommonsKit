//
//  JZThumbUpButton.m
//  BtnDemo
//
//  Created by wangjingfei on 2017/6/12.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import "JZThumbUpButton.h"
#import <Masonry/Masonry.h>

@interface JZThumbUpButton ()

@property (nonatomic,strong) UIImageView *selectedImgView;

@property (nonatomic,strong) UIImageView *leftImgView;

@property (nonatomic,strong) UIImageView *rightImgView;

@end
@implementation JZThumbUpButton
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (UIImageView *)selectedImgView
{
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] init];
        _selectedImgView.contentMode = UIViewContentModeScaleAspectFill;
        _selectedImgView.clipsToBounds = YES;
        _selectedImgView.alpha = 0;
        [self addSubview:_selectedImgView];
        [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageView.mas_centerX).mas_offset(0);
            make.top.mas_equalTo(self.mas_top).mas_offset(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    return _selectedImgView;
}
- (UIImageView *)leftImgView
{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImgView.hidden = YES;
        [self addSubview:_leftImgView];
        
        [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageView.mas_centerX).multipliedBy(0.5);
            make.top.mas_equalTo(self.mas_top).mas_offset(-20);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    return _leftImgView;
}
- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImgView.hidden = YES;
        [self addSubview:_rightImgView];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageView.mas_centerX).multipliedBy(1.5);
            make.top.mas_equalTo(self.mas_top).mas_offset(-20);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    return _rightImgView;
}
- (void)selectChangeCurrentBtnImg:(NSString *)imgName withSelectAniImage:(NSString *)imgStr withTitleColor:(UIColor *)titleColor  withTitleName:(NSString *)titleName withClickBtn:(ClickAnimationType)clickType
{
    self.userInteractionEnabled = NO;
    if (clickType == ClickAnimationTypeNormal) {
        [self selectCurrentBtnImgChange:imgName withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
    }else if (clickType == ClickAnimationTypeAnimation){
        [self selectCurrentBtnImgChange:imgName withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
        [self selectedButtonAniamtionWithImgStr:imgStr];
    }
}
- (void)deselectChangeCurrentBtnImg:(NSString *)imgName  withAnimationArray:(NSArray *)imgArray withTitleColor:(UIColor *)titleColor  withTitleName:(NSString *)titleName withClickBtn:(ClickAnimationType)clickType
{
    self.userInteractionEnabled = NO;
    if (clickType == ClickAnimationTypeNormal) {
        [self selectCurrentBtnImgChange:imgName withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
    }else if (clickType == ClickAnimationTypeAnimation){
        [self selectCurrentBtnImgChange:imgName withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
        [self deselectedButtonAniamtionWithImgArr:imgArray];
    }
    
}
- (void)selectedButtonAniamtionWithImgStr:(NSString *)imgStr
{
    UIImage *img = [UIImage imageNamed:imgStr];
    self.selectedImgView.image = img;
    [self.selectedImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX).mas_offset(0);
        make.top.mas_equalTo(self.mas_top).mas_offset(-40);
        make.size.mas_equalTo(img.size);
    }];
    self.selectedImgView.alpha = 0.0;
    [UIView animateWithDuration:1.0f animations:^{
        
        [self layoutIfNeeded];
        self.selectedImgView.alpha = 1.0;
        
        CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*2];
        NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*2];
        NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*2];
        anima.values = @[value1,value2,value3];
        anima.repeatCount = MAXFLOAT;
        [self.selectedImgView.layer addAnimation:anima forKey:@"transform.rotation"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.selectedImgView.alpha = 0;
            }];
        });
    } completion:^(BOOL finished) {
        [self.selectedImgView.layer removeAllAnimations];
        [self.selectedImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(0);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        self.userInteractionEnabled = YES;
    }];
}
- (void)deselectedButtonAniamtionWithImgArr:(NSArray *)imgArray
{
    self.leftImgView.hidden = NO;
    self.rightImgView.hidden = NO;
    UIImage *leftImg = [UIImage imageNamed:@"wjf_leftheart_05"];
    UIImage *rightImg = [UIImage imageNamed:@"wjf_rightheart_07"];
    
    
    [self.leftImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(leftImg.size);
    }];
    
    [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(rightImg.size);
    }];
    
    self.leftImgView.image = leftImg;
    self.rightImgView.image = rightImg;
    
    self.leftImgView.alpha = 1.0;
    self.rightImgView.alpha = 1.0;
    
    CGAffineTransform roTran = CGAffineTransformMakeRotation(-M_PI_2 / 20);
    
    CGAffineTransform roTran1 =  CGAffineTransformMakeRotation(M_PI_2 / 20);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform tran_X = CGAffineTransformTranslate(roTran, -8, -2);
        self.leftImgView.transform = tran_X;
        
        CGAffineTransform tran1_X = CGAffineTransformTranslate(roTran1, 8, -2);
        
        self.rightImgView.transform = tran1_X;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform tran_Y = CGAffineTransformTranslate(self.leftImgView.transform ,-8, 20);
            self.leftImgView.transform = tran_Y;
            
            CGAffineTransform tran1_Y = CGAffineTransformTranslate(self.rightImgView.transform,8, 20);
            self.rightImgView.transform = tran1_Y;
            
            self.leftImgView.alpha = 0;
            self.rightImgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.leftImgView.transform = CGAffineTransformIdentity;
            self.rightImgView.transform = CGAffineTransformIdentity;
            self.userInteractionEnabled = YES;
        }];
    }];
}
//点击按钮只修改图片
- (void)selectCurrentBtnImgChange:(NSString *)imgName
{
    [self selectCurrentBtnImgChange:imgName withBtnTitltColor:nil withCurrentBtnTitleChange:nil];
}
//点击按钮只汉字和汉字的颜色
- (void)selectCurrentBtnTitleChange:(NSString *)titleName withBtnTitltColor:(UIColor *)titleColor
{
    [self selectCurrentBtnImgChange:nil withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
}
//修改图片和字体颜色
- (void)selectCurrentBtnImgChange:(NSString *)imgName withBtnTitltColor:(UIColor *)titleColor withCurrentBtnTitleChange:(NSString *)titleName
{
    if (titleColor) {
        [self setTitleColor:(UIColor *)titleColor forState:UIControlStateNormal];
    }
    if (titleName) {
      [self setTitle:titleName forState:UIControlStateNormal];
    }
    if (imgName) {
        [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
}
@end
