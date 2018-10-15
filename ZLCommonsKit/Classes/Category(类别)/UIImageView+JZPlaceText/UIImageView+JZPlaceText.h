//
//  UIImageView+JZPlaceText.h
//  eStudy(comprehensive)
//
//  Created by taobobo on 2017/12/8.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JZPlaceText)

@property(nonatomic, strong, readonly) UILabel *jz_textLabel;

@property(nonatomic, strong) UIColor *jz_textBgColor;

@property(nonatomic, copy) NSString *jz_text;     //需要先设置jz_textBgColor

@end
