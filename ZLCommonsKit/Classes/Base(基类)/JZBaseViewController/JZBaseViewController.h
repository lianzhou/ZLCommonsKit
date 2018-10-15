//
//  JZBaseViewController.h
//  JZCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import <UIKit/UIKit.h>

@interface JZBaseViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t popCompletion;

- (void)navigationBarBackgroundImageColor:(UIColor *)barColor;

- (void)pushViewController:(JZBaseViewController *)viewController withParams:(NSDictionary *)params;
- (void)pushViewControllerName:(NSString *)instance withParams:(NSDictionary *)params;

- (void)removeViewControllers:(NSArray <NSString *>*)viewControllers;

- (void)asyncPushToViewController:(dispatch_block_t)block;

@end
