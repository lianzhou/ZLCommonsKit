 //
//  ZLBaseNavigationController.m
//  Pods
//
//  Created by zhoulian on 17/8/23.
//
//

#import "ZLBaseNavigationController.h"
#import "ZLContext.h"
#import "ZLNavigationProtocol.h"

@interface ZLBaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation ZLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * modules =  [[ZLContext shareInstance].appConfig moduleServicesWithProtocol:@protocol(ZLNavigationProtocol)];
    id <ZLNavigationProtocol> module = [modules firstObject];
    
    [module configNavigation:self];

    typeof(self) __weak weakSelf=self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    dispatch_async_on_main_queue(^{
         [super pushViewController:viewController animated:animated];
    });
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return  [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated { 
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ) { 
        self.interactivePopGestureRecognizer.enabled = NO; 
    } 
    return [super popToViewController:viewController animated:animated]; 
} 
#pragma mark UINavigationControllerDelegate 

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate { 
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) 
    {
        self.interactivePopGestureRecognizer.enabled = YES; 
    } 
} 

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer { 
    if ( gestureRecognizer ==self.interactivePopGestureRecognizer ) { 
        if ( self.viewControllers.count == 1 || 
            self.visibleViewController == [self.viewControllers objectAtIndex:0] || [self.zl_isNoUseGesture boolValue])
        { 
            return NO; 
        } 
    } 
    return YES;
} 

static const char *ZL_tempNavDelegateKey = "zl_tempNavDelegateKey";
- (void)setZl_tempNavDelegate:(id)zl_tempNavDelegate {
    objc_setAssociatedObject(self, &ZL_tempNavDelegateKey, zl_tempNavDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id)zl_tempNavDelegate {
    return objc_getAssociatedObject(self, &ZL_tempNavDelegateKey);
}

static const char *ZL_isNoUseGestureKey = "zl_isNoUseGestureKey";

- (void)setZl_isNoUseGesture:(NSNumber *)zl_isNoUseGesture {
    objc_setAssociatedObject(self, &ZL_isNoUseGestureKey, zl_isNoUseGesture, OBJC_ASSOCIATION_ASSIGN);
}
- (NSNumber *)zl_isNoUseGesture {
    return objc_getAssociatedObject(self, &ZL_isNoUseGestureKey);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
