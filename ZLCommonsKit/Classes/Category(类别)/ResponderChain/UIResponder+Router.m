//
//  UIResponder+Router.m
//  ResponderChainDemo
//
//  Created by wangjingfei on 2017/8/10.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import "UIResponder+Router.h"


@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName withObject:(id)obj withUserInfo:(id)userInfo;
{
    [[self nextResponder] routerEventWithName:eventName withObject:obj withUserInfo:userInfo];
}

@end
