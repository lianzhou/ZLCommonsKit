 //
//  JZBaseNavigationController.m
//  Pods
//
//  Created by zhoulian on 17/8/23.
//
//

#import "JZBaseNavigationController.h"
#import "JZContext.h"
#import "JZNavigationProtocol.h"

@interface JZBaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation JZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * modules =  [[JZContext shareInstance].appConfig moduleServicesWithProtocol:@protocol(JZNavigationProtocol)];
    id <JZNavigationProtocol> module = [modules firstObject];
    
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
            self.visibleViewController == [self.viewControllers objectAtIndex:0] || [self.jz_isNoUseGesture boolValue])
        { 
            return NO; 
        } 
    } 
    return YES;
} 

static const char *JZ_tempNavDelegateKey = "jz_tempNavDelegateKey";
- (void)setJz_tempNavDelegate:(id)jz_tempNavDelegate {
    objc_setAssociatedObject(self, &JZ_tempNavDelegateKey, jz_tempNavDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id)jz_tempNavDelegate {
    return objc_getAssociatedObject(self, &JZ_tempNavDelegateKey);
}

static const char *JZ_isNoUseGestureKey = "jz_isNoUseGestureKey";

- (void)setJz_isNoUseGesture:(NSNumber *)jz_isNoUseGesture {
    objc_setAssociatedObject(self, &JZ_isNoUseGestureKey, jz_isNoUseGesture, OBJC_ASSOCIATION_ASSIGN);
}
- (NSNumber *)jz_isNoUseGesture {
    return objc_getAssociatedObject(self, &JZ_isNoUseGestureKey);
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
