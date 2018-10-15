//
//  UIResponder+Router.h
//  ResponderChainDemo
//
//  Created by wangjingfei on 2017/8/10.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName withObject:(id)obj withUserInfo:(id)userInfo;

@end
