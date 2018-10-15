//
//  UITextView+JZPlaceholder.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

static const void *kJZTextViewPlaceholderLabelKey = "kJZTextViewPlaceholderLabelKey";
static const void *kJZTextViewPlaceholderTextKey  = "kJZTextViewPlaceholderTextKey";

#import "UITextView+JZPlaceholder.h"
#import <objc/runtime.h>
#import <YYKit.h>
#import <Masonry/Masonry.h>
#import "JZStringMacrocDefine.h"
#import "NSString+Extension.h"

@implementation UITextView (JZPlaceholder)

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
//}

- (void)setJz_placeholderLabel:(UILabel *)jz_placeholderLabel {
    objc_setAssociatedObject(self,
                             kJZTextViewPlaceholderLabelKey,
                             jz_placeholderLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)jz_placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, kJZTextViewPlaceholderLabelKey);

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

        self.jz_placeholderLabel = placeholderLabel;
        
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(x);
            make.top.mas_equalTo(self.mas_top).mas_offset(y);
            make.right.mas_equalTo(self.mas_right).mas_offset(-x);
            make.height.mas_equalTo(height);
        }];
        
        placeholderLabel.enabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                selector:@selector(jz_placehoderTextChange:)
                                    name:UITextViewTextDidChangeNotification
                                  object:nil];
    }
    
    return placeholderLabel;
}

- (void)jz_placehoderTextChange:(NSNotification *)notification {
        if (!JZStringIsNull(self.text)) {
            self.jz_placeholderLabel.text = @"";
        } else {
            self.jz_placeholderLabel.text = self.jz_placeholder;
        }
}


- (void)setJz_placeholder:(NSString *)jz_placeholder {
    if (JZStringIsNull(jz_placeholder)) {
        objc_setAssociatedObject(self, kJZTextViewPlaceholderTextKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.jz_placeholderLabel removeFromSuperview];
        return;
    }
    
    objc_setAssociatedObject(self,
                             kJZTextViewPlaceholderTextKey,
                             jz_placeholder,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!JZStringIsNull(self.text)) {
        self.jz_placeholderLabel.text = @"";
    } else {
        CGSize placeholderSize = [jz_placeholder textSizeIn:CGSizeMake(MIN(self.jz_placeholderLabel.frame.size.width, kScreenWidth), 100) font:[self jz_placeholderFont]];
        CGFloat height =MAX(self.jz_placeholderFont.lineHeight, placeholderSize.height) ;
        [self.jz_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        self.jz_placeholderLabel.text = jz_placeholder;
    }
}

- (NSString *)jz_placeholder {
    return objc_getAssociatedObject(self, kJZTextViewPlaceholderTextKey);
}

- (void)setJz_placeholderColor:(UIColor *)jz_placeholderColor {
    self.jz_placeholderLabel.textColor = jz_placeholderColor;
}

- (UIColor *)jz_placeholderColor {
    return self.jz_placeholderLabel.textColor;
}

- (void)setJz_placeholderFont:(UIFont *)jz_placeholderFont {
    self.jz_placeholderLabel.font = jz_placeholderFont;
    [self updatePlaceholderLabelConstraints];
}

- (UIFont *)jz_placeholderFont {
    return self.jz_placeholderLabel.font;
}
- (void)updatePlaceholderLabelConstraints{
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = self.textContainerInset;
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    
    CGFloat y = textContainerInset.top;
//    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = self.jz_placeholderFont.lineHeight;
        
    [self.jz_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(x);
        make.top.mas_equalTo(self.mas_top).mas_offset(y);
        make.right.mas_equalTo(self.mas_right).mas_offset(-x);
        make.height.mas_equalTo(height);
    }];
}

@end
