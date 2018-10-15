//
//  UIViewController+JZLandscape.h
//  eStudy(parents)
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JZLandscape)

/**
 * 是否需要横屏(默认 NO, 即当前 viewController 不支持横屏).
 */
@property(nonatomic,assign) BOOL jz_shouldAutoLandscape;

@end
