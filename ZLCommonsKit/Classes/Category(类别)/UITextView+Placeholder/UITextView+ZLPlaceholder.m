//
//  UITextView+ZLPlaceholder.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

static const void *kZLTextViewPlaceholderLabelKey = "kZLTextViewPlaceholderLabelKey";
static const void *kZLTextViewPlaceholderTextKey  = "kZLTextViewPlaceholderTextKey";

#import "UITextView+ZLPlaceholder.h"
#import <objc/runtime.h>
#import <YYKit.h>
#import <Masonry/Masonry.h>
#import "ZLStringMacrocDefine.h"
#import "NSString+Extension.h"

@implementation UITextView (ZLPlaceholder)

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
//}

- (void)setZl_placeholderLabel:(UILabel *)zl_placeholderLabel {
    objc_setAssociatedObject(self,
                             kZLTextViewPlaceholderLabelKey,
                             zl_placeholderLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)zl_placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, kZLTextViewPlaceholderLabelKey);

    if (placeholderLabel == nil || ![placeholderLabel isKindOfClass:[UILabel class]]) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        placeholderLabel.font = [UIFont systemFontOfSize:14];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.textColor = UIColorHex(0xcccccc);
        [self addSubview:placeholderLabel];

        
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat x = lineFragmentPadding + textContainerInset.left;
        
        CGFloat y = textContainerInset.top;
        CGFloat height = placeholderLabel.font.lineHeight;

        self.zl_placeholderLabel = placeholderLabel;
        
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(x);
            make.top.mas_equalTo(self.mas_top).mas_offset(y);
            make.right.mas_equalTo(self.mas_right).mas_offset(-x);
            make.height.mas_equalTo(height);
        }];
        
        placeholderLabel.enabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                selector:@selector(zl_placehoderTextChange:)
                                    name:UITextViewTextDidChangeNotification
                                  object:nil];
    }
    
    return placeholderLabel;
}

- (void)zl_placehoderTextChange:(NSNotification *)notification {
        if (!ZLStringIsNull(self.text)) {
            self.zl_placeholderLabel.text = @"";
        } else {
            self.zl_placeholderLabel.text = self.zl_placeholder;
        }
}


- (void)setZl_placeholder:(NSString *)zl_placeholder {
    if (ZLStringIsNull(zl_placeholder)) {
        objc_setAssociatedObject(self, kZLTextViewPlaceholderTextKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.zl_placeholderLabel removeFromSuperview];
        return;
    }
    
    objc_setAssociatedObject(self,
                             kZLTextViewPlaceholderTextKey,
                             zl_placeholder,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!ZLStringIsNull(self.text)) {
        self.zl_placeholderLabel.text = @"";
    } else {
        CGSize placeholderSize = [zl_placeholder textSizeIn:CGSizeMake(MIN(self.zl_placeholderLabel.frame.size.width, kScreenWidth), 100) font:[self zl_placeholderFont]];
        CGFloat height =MAX(self.zl_placeholderFont.lineHeight, placeholderSize.height) ;
        [self.zl_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        self.zl_placeholderLabel.text = zl_placeholder;
    }
}

- (NSString *)zl_placeholder {
    return objc_getAssociatedObject(self, kZLTextViewPlaceholderTextKey);
}

- (void)setZl_placeholderColor:(UIColor *)zl_placeholderColor {
    self.zl_placeholderLabel.textColor = zl_placeholderColor;
}

- (UIColor *)zl_placeholderColor {
    return self.zl_placeholderLabel.textColor;
}

- (void)setZl_placeholderFont:(UIFont *)zl_placeholderFont {
    self.zl_placeholderLabel.font = zl_placeholderFont;
    [self updatePlaceholderLabelConstraints];
}

- (UIFont *)zl_placeholderFont {
    return self.zl_placeholderLabel.font;
}
- (void)updatePlaceholderLabelConstraints{
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = self.textContainerInset;
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    
    CGFloat y = textContainerInset.top;
//    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = self.zl_placeholderFont.lineHeight;
        
    [self.zl_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(x);
        make.top.mas_equalTo(self.mas_top).mas_offset(y);
        make.right.mas_equalTo(self.mas_right).mas_offset(-x);
        make.height.mas_equalTo(height);
    }];
}

@end
