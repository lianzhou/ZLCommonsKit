//
//  UIViewController+ZLLandscape.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZLLandscape)

/**
 * 是否需要横屏(默认 NO, 即当前 viewController 不支持横屏).
 */
@property(nonatomic,assign) BOOL zl_shouldAutoLandscape;

@end
