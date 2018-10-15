//
//  JZExceptionHandler.h
//  eStudy(comprehensive)
//
//  Created by Allen_Xu on 2018/1/8.
//  Copyright © 2018年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JZExceptionHandler : NSObject{
    BOOL dismissed;
}

+ (instancetype)sharedHandler;


@end
