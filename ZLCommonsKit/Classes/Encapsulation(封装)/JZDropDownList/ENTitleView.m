//
//  ENTitleView.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/4.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENTitleView.h"
#import "UIImage+Picker.h"

@interface ENTitleView ()

@property (nonatomic,strong) UIButton * titleButton;

@end

@implementation ENTitleView
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
    
    self.attributedImageName = @"tlb_teach_expand";
    
    
    [self addSubview:self.titleButton];
    [self makeConstraints];
}
- (void)makeConstraints{
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setAttributedTitle:(NSString *)attributedTitle{
    _attributedTitle = attributedTitle;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:attributedTitle];
    NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
    imageAtta.bounds = CGRectMake(0, 0, 11, 6);
    imageAtta.image = [UIImage imageNamedWithPickerName:self.attributedImageName];
    NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
    [attributedString appendAttributedString:attach];
    [self.titleButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
//    [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, attributedTitle.length)];
//    [self.titleButton setAttributedTitle:attributedString forState:UIControlStateHighlighted];
}
- (void)setAttributedImageName:(NSString *)attributedImageName{
    _attributedImageName = attributedImageName;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)titleButtonClick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    if (self.titleViewWithTitleButtonClick) {
        sender.userInteractionEnabled = self.titleViewWithTitleButtonClick(sender);
    }else{
        sender.userInteractionEnabled = YES;

    }
    
    
}
#pragma mark - 懒加载

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_titleButton setBackgroundImage:[UIImage imageNamed:@"lce_button_highlighted"] forState:UIControlStateHighlighted];
        [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end
