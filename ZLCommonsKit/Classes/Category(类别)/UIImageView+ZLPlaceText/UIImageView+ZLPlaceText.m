//
//  UIImageView+ZLPlaceText.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

static const void *kZLUIImageViewTextLabelKey = "kZLUIImageViewTextLabelKey";

static const void *kZLUIImageViewTextBgColorKey = "kZLUIImageViewTextBgColorKey";

#import "UIImageView+ZLPlaceText.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "ZLStringMacrocDefine.h"


@implementation UIImageView (ZLPlaceText)


- (void)setZl_textLabel:(UILabel *)zl_textLabel {
    
    objc_setAssociatedObject(self,
                             kZLUIImageViewTextLabelKey,
                             zl_textLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)zl_textLabel {
    
    UILabel *zl_textLabel = objc_getAssociatedObject(self, kZLUIImageViewTextLabelKey);
    if (zl_textLabel == nil || ![zl_textLabel isKindOfClass:[UILabel class]]) {
        
        zl_textLabel = [[UILabel alloc] init];
        zl_textLabel.textColor = [UIColor whiteColor];
        zl_textLabel.font = [UIFont systemFontOfSize:15.0f];
        zl_textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:zl_textLabel];
        self.zl_textLabel = zl_textLabel;
        [zl_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.centerY.mas_equalTo(0);
        }];
        self.backgroundColor = self.zl_textBgColor;
    }
    return zl_textLabel;
}

- (void)setZl_text:(NSString *)zl_text {
    
    if (ZLStringIsNull(zl_text)) {
        self.zl_textLabel.text = @"";
    } else {
        self.zl_textLabel.text = zl_text;
        
    }
}

- (NSString *)zl_text {
    return self.zl_textLabel.text;
}

- (void)setZl_textBgColor:(UIColor *)zl_textBgColor {
    
    objc_setAssociatedObject(self,
                             kZLUIImageViewTextBgColorKey,
                             zl_textBgColor,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (UIColor *)zl_textBgColor {
    
    return objc_getAssociatedObject(self, kZLUIImageViewTextBgColorKey);
}

@end
