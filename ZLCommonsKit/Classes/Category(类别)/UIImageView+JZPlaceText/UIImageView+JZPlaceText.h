//
//  UIImageView+JZPlaceText.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JZPlaceText)

@property(nonatomic, strong, readonly) UILabel *jz_textLabel;

@property(nonatomic, strong) UIColor *jz_textBgColor;

@property(nonatomic, copy) NSString *jz_text;     //需要先设置jz_textBgColor

@end
