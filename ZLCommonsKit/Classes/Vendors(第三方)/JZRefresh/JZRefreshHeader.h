//
//  JZRefreshHeader.h
//  eStudy
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZRefreshHeader : UIView

UIKIT_EXTERN const CGFloat SURefreshHeaderHeight;
UIKIT_EXTERN const CGFloat SURefreshPointRadius;

@property (nonatomic, copy) void(^handle)();

@property (nonatomic, assign)BOOL isNormal;

#pragma mark - 停止动画
- (void)endRefreshing;


@end
