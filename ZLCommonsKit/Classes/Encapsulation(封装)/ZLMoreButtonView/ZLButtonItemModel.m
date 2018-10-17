//
//  ZLButtonItemModel.m
//  ZLViewDemo
//
//  Created by wangjingfei on 2017/9/4.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import "ZLButtonItemModel.h"
#import <YYKit.h>

@implementation ZLButtonItemModel

- (CGSize)btnSize
{
    if (_btnSize.width == 0 || _btnSize.height == 0) {
        _btnSize = CGSizeMake(50, 40);
    }
    return _btnSize;
}
- (CGFloat)btnTitleSize
{
    if (!_btnTitleSize) {
        _btnTitleSize = 9.0f;
    }
    return _btnTitleSize;
}
- (UIColor *)btnTitleColor
{
    if (!_btnTitleColor) {
        _btnTitleColor = UIColorHex(0x666666);
    }
    return _btnTitleColor;
}
@end
