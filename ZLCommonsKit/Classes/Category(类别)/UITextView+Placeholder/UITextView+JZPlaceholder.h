//
//  UITextView+JZPlaceholder.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (JZPlaceholder)


@property (nonatomic, strong,readonly) UILabel *jz_placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *jz_placeholder;
@property (nonatomic, strong) IBInspectable UIColor  *jz_placeholderColor;
@property (nonatomic, strong) IBInspectable UIFont   *jz_placeholderFont;


@end
