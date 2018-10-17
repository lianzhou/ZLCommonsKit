//
//  UIScrollView+ZLRefresh.h
//  ZLCommonsKit
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLRefreshHeader.h"

@interface UIScrollView (ZLRefresh)

@property (nonatomic, weak, readonly) ZLRefreshHeader * ZL_header;

- (void)addRefreshHeaderWithNormal:(BOOL)isNormal Handle:(void (^)())handle;

@end
