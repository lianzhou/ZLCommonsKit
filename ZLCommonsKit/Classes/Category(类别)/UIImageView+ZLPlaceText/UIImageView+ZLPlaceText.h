//  UIImageView+ZLPlaceText.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZLPlaceText)

@property(nonatomic, strong, readonly) UILabel *zl_textLabel;

@property(nonatomic, strong) UIColor *zl_textBgColor;

/**
 需要先设置zl_textBgColor
 */
@property(nonatomic, copy) NSString *zl_text; 

@end
