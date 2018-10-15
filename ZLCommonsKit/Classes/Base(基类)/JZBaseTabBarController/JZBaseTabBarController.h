//
//  JZBaseTabBarController.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#import <UIKit/UIKit.h>
#import "JZTabBarItem.h"

UIKIT_EXTERN NSString *const JZTabBarItemController;
UIKIT_EXTERN NSString *const JZTabBarItemTitle;
UIKIT_EXTERN NSString *const JZTabBarItemImage;
UIKIT_EXTERN NSString *const JZTabBarItemSelectedImage;
UIKIT_EXTERN NSString *const JZTabBarItemSelectedColor;
UIKIT_EXTERN NSString *const JZTabBarItemColor;

@interface JZBaseTabBarController : UITabBarController

@property(nonatomic) NSUInteger selectedBarItemIndex;

@property (nonatomic, strong)  NSMutableArray <JZTabBarItem *>* tabBarItems;


- (void)touchTabBarItemGotoTop:(dispatch_block_t)block;

- (void)hideTopAnimateSelectedIndex:(NSInteger)manualIndex;
- (void)showTopAnimateSelectedIndex:(NSInteger)manualIndex;
@end
