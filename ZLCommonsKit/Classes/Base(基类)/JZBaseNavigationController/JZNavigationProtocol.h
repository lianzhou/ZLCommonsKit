//
//  JZNavigationProtocol.h
//  Pods
//
//  Created by zhoulian on 17/8/24.
//
//

#import <Foundation/Foundation.h>

@class JZBaseNavigationController;
@protocol JZNavigationProtocol <NSObject>

- (void)configNavigation:(JZBaseNavigationController *)navigationController;
//加锁
@end
