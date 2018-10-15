//
//  UIImageView+JZPlaceText.m
//  eStudy(comprehensive)
//
//  Created by taobobo on 2017/12/8.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

static const void *kJZUIImageViewTextLabelKey = "kJZUIImageViewTextLabelKey";

static const void *kJZUIImageViewTextBgColorKey = "kJZUIImageViewTextBgColorKey";

#import "UIImageView+JZPlaceText.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "JZStringMacrocDefine.h"


@implementation UIImageView (JZPlaceText)


- (void)setJz_textLabel:(UILabel *)jz_textLabel {
    
    objc_setAssociatedObject(self,
                             kJZUIImageViewTextLabelKey,
                             jz_textLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)jz_textLabel {
    
    UILabel *jz_textLabel = objc_getAssociatedObject(self, kJZUIImageViewTextLabelKey);
    if (jz_textLabel == nil || ![jz_textLabel isKindOfClass:[UILabel class]]) {
        
        jz_textLabel = [[UILabel alloc] init];
        jz_textLabel.textColor = [UIColor whiteColor];
        jz_textLabel.font = [UIFont systemFontOfSize:15.0f];
        jz_textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:jz_textLabel];
        self.jz_textLabel = jz_textLabel;
        [jz_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.centerY.mas_equalTo(0);
        }];
        self.backgroundColor = self.jz_textBgColor;
    }
    return jz_textLabel;
}

- (void)setJz_text:(NSString *)jz_text {
    
    if (JZStringIsNull(jz_text)) {
        self.jz_textLabel.text = @"";
    } else {
        self.jz_textLabel.text = jz_text;
        
    }
}

- (NSString *)jz_text {
    return self.jz_textLabel.text;
}

- (void)setJz_textBgColor:(UIColor *)jz_textBgColor {
    
    objc_setAssociatedObject(self,
                             kJZUIImageViewTextBgColorKey,
                             jz_textBgColor,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (UIColor *)jz_textBgColor {
    
    return objc_getAssociatedObject(self, kJZUIImageViewTextBgColorKey);
}

@end
