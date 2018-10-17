//
//  ZLNavigationProtocol.h
//  Pods
//
//  Created by zhoulian on 17/8/24.
//
//

#import <Foundation/Foundation.h>

@class ZLBaseNavigationController;
@protocol ZLNavigationProtocol <NSObject>

- (void)configNavigation:(ZLBaseNavigationController *)navigationController;
//加锁
@end
