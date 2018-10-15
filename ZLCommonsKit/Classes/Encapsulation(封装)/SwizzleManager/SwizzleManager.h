//
//  SwizzleManager.h
//  e学云学生版
//
//  Created by juziwl on 15/11/4.
//  Copyright © 2015年 李长恩. All rights reserved.
//
//  所有的注入操作都在这个类里面管理，降低与View Controller的耦合
#import <Foundation/Foundation.h>

@interface SwizzleManager : NSObject

+ (void)createAllHooks;

//静态就交换静态，实例方法就交换实例方法
void SwizzlingMethod(Class c, SEL origSEL, SEL newSEL);

@end
