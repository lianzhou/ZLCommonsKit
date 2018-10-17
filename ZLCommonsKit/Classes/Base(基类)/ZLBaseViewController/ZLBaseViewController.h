//
//  ZLBaseViewController.h
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import <UIKit/UIKit.h>

@interface ZLBaseViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t popCompletion;

- (void)navigationBarBackgroundImageColor:(UIColor *)barColor;

- (void)pushViewController:(ZLBaseViewController *)viewController withParams:(NSDictionary *)params;
- (void)pushViewControllerName:(NSString *)instance withParams:(NSDictionary *)params;

- (void)removeViewControllers:(NSArray <NSString *>*)viewControllers;

- (void)asyncPushToViewController:(dispatch_block_t)block;

@end
