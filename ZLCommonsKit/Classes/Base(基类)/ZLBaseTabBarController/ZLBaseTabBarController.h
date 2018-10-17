//
//  ZLBaseTabBarController.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#import <UIKit/UIKit.h>
#import "ZLTabBarItem.h"

UIKIT_EXTERN NSString *const ZLTabBarItemController;
UIKIT_EXTERN NSString *const ZLTabBarItemTitle;
UIKIT_EXTERN NSString *const ZLTabBarItemImage;
UIKIT_EXTERN NSString *const ZLTabBarItemSelectedImage;
UIKIT_EXTERN NSString *const ZLTabBarItemSelectedColor;
UIKIT_EXTERN NSString *const ZLTabBarItemColor;

@interface ZLBaseTabBarController : UITabBarController

@property(nonatomic) NSUInteger selectedBarItemIndex;

@property (nonatomic, strong)  NSMutableArray <ZLTabBarItem *>* tabBarItems;


- (void)touchTabBarItemGotoTop:(dispatch_block_t)block;

- (void)hideTopAnimateSelectedIndex:(NSInteger)manualIndex;
- (void)showTopAnimateSelectedIndex:(NSInteger)manualIndex;
@end
