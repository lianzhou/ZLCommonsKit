//
//  NSObject+PerformSelector.h
//  ResponderChainDemo
//
//  Created by wangjingfei on 2017/8/10.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray <id> *)objects;

@end
