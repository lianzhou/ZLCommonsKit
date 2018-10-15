//
//  UIScrollView+JZRefresh.h
//  eStudy
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRefreshHeader.h"

@interface UIScrollView (JZRefresh)

@property (nonatomic, weak, readonly) JZRefreshHeader * JZ_header;

- (void)addRefreshHeaderWithNormal:(BOOL)isNormal Handle:(void (^)())handle;

@end
