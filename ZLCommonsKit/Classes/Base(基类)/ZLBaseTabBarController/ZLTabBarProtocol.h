//
//  ZLTabBarProtocol.h
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>



@protocol ZLTabBarProtocol <NSObject>

- (NSArray *)tabBarItemsAttributes;

- (void)tabBarSelectedIndex:(NSUInteger)selectedIndex completionHandler:(void (^)(BOOL))completionHandler;

- (BOOL)tabBarShowShadowColor;

- (BOOL)tabBarScaleImageButtonAnimate;

- (NSInteger)selectedBarIndex;

@end
