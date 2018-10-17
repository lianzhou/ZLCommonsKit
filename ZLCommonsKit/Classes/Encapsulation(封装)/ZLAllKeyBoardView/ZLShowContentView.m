//
//  ZLShowContentView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLShowContentView.h"
#import "Masonry.h"
#import "ZLSystemMacrocDefine.h"
//#import "UITextView+ZLPlaceholder.h"
//#import "JKAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HPGrowingTextView.h"


#define SCREEN_WIDTH   [ZLSystemUtils deviceScreenSize].width
#define KimageWidth (SCREEN_WIDTH - 15*3-10*2-120)/3
#define UIColorFromHex(rgbValue) [ZLSystemUtils colorFromHexString:((__bridge NSString *)CFSTR(#rgbValue))]
#define kDefaultZLFont(A) [UIFont systemFontOfSize:(A)]   //默认字体
#define KpicViewHeight KimageWidth + 20

@interface ZLShowContentView ()


@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UIView *picView;

@property(nonatomic,strong)UILabel *desLabel;
@end

@implementation ZLShowContentView

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
    
    self.maxInputStrNumber = 300;
    [self makeConstraints];
}

/**
 * 背景色
 */
- (void)makeBackgroundColor:(UIColor*)color{
    
    self.backgroundColor = color;
}
#pragma mark - 约束
- (void)makeConstraints{
    
    
    //    [self mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.mas_left);
    //        make.right.mas_equalTo(self.mas_right);
    //        make.top.mas_equalTo(self.mas_top);
    //        make.height.mas_offset(60);
    //    }];
    
    //    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.mas_left);
    //        make.right.mas_equalTo(self.mas_right);
    //        make.bottom.mas_equalTo(self.mas_bottom);
    //        make.height.mas_offset(60);
    //    }];
    //
    //    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
    //        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
    //        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    //        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
    //
    //    }];
    self.contentView.backgroundColor = [UIColor redColor];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_offset(0);
        
    }];
    
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.picView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(self.picView.mas_top);
        make.bottom.mas_equalTo(self.picView.mas_bottom);
        make.width.mas_offset(120);
    }];
    
}


#pragma mark - 显示图片
- (void)createShowPic
{
    if (_picsArray.count > 0) {
        _desLabel.hidden = NO;
        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(KpicViewHeight);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(_contentHeight+20+KpicViewHeight);
        }];
        CGFloat space = 10;
        for (UIView *subView in _picView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]] || [subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview];
            }
        }
        for (int i = 0; i < _picsArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.tag = 200+i;
            UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browsePicAction:)];
            [imageView addGestureRecognizer:tapGues];
            [self.picView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.picView.mas_left).mas_offset(15+(KimageWidth+space)*i);
                make.centerY.mas_equalTo(self.picView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(KimageWidth, KimageWidth));
            }];
            imageView.image = [_picsArray objectAtIndex:i];
            
            UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.picView addSubview:deleBtn];
            deleBtn.tag = 2000+i;
            [deleBtn setImage:[UIImage imageNamed:@"mjl_keyboard_delete"] forState:UIControlStateNormal];
            [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(imageView.mas_right).mas_offset(7);
                make.top.mas_equalTo(imageView.mas_top).mas_offset(-7);
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }];
            
            [deleBtn addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        _desLabel.hidden = YES;
        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        
        for (UIView *subView in _picView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
    
}

#pragma mark - 浏览大图
- (void)browsePicAction:(UITapGestureRecognizer *)tapSender {
    
    UIView *imageview = tapSender.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showContentView:browsePicWithIndex:withImageView:)]) {
        [self.delegate showContentView:self browsePicWithIndex:imageview.tag-200 withImageView:imageview];
    }
    
}

#pragma mark - 删除图片
- (void)deletePicClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showContentView:deletePicWithIndex:)]) {
        [self.delegate showContentView:self deletePicWithIndex:sender.tag - 2000];
    }
}
#pragma mark - 懒加载

- (HPGrowingTextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectZero];
        _contentTextView.placeholder = @"说点什么吧";
        _contentTextView.font = kDefaultZLFont(14.0);
        _contentTextView.textColor = UIColorFromHex(0x333333);
        _contentTextView.backgroundColor = [UIColor whiteColor];
        [_contentTextView setMaxNumber:(int)self.maxInputStrNumber];
        
        [self.contentView addSubview:_contentTextView];
        
    }
    return _contentTextView;
}


- (UIView *)picView
{
    if (!_picView) {
        _picView = [[UIView alloc]initWithFrame:CGRectZero];
        _picView.backgroundColor = ZL_KMainColor;
        
        [self addSubview:_picView];
    }
    return _picView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        //        _contentView.layer.shadowColor = UIColorFromHex(0xcccccc).CGColor;
        //        _picView.layer.shadowOffset = CGSizeMake(3, 0);
        //        _picView.layer.shadowOpacity = 0.8;
        //        _picView.layer.shadowRadius = 3;
        [_picView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _desLabel.text = @"最多可添加三张图片";
        _desLabel.textColor = UIColorFromHex(0xcccccc);
        _desLabel.font = kDefaultZLFont(13.0);
        [self.picView addSubview:_desLabel];
        
    }
    return _desLabel;
}

#pragma mark -setter

- (void)setPicsArray:(NSArray *)picsArray
{
    _picsArray = picsArray;
    [self createShowPic];
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    
    if (contentHeight > 0) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(contentHeight+20);
            
        }];
    }else{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(contentHeight);
            
        }];
    }
    
}

- (void)setPicHeight:(CGFloat)picHeight
{
    _picHeight = picHeight;
    
    [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(picHeight);
    }];
    if (picHeight == 0) {
        for (UIView *subView in self.picView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                subView.hidden = YES;
            }
        }
    }
}

- (void)setPalaceStr:(NSString *)palaceStr
{
    _palaceStr = palaceStr;
    //    self.contentTextView.placeholder = palaceStr;
}

- (void)setMaxInputStrNumber:(NSInteger)maxInputStrNumber {
    _maxInputStrNumber = maxInputStrNumber;
    //    [_contentTextView setMaxNumber:(int)maxInputStrNumber];
    
}


- (void)setIsHidenLabel:(BOOL)isHidenLabel {
    _isHidenLabel = isHidenLabel;
    if (isHidenLabel) {
        self.desLabel.hidden = YES;
        
    }else{
        self.desLabel.hidden = NO;
        
        
    }
}

@end



