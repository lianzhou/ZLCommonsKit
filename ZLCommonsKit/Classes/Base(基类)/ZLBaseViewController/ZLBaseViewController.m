//
//  ZLBaseViewController.m
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import "ZLBaseViewController.h"
#import "ZLCommonsKit.h"
#import <objc/runtime.h>

@interface ZLBaseViewController ()

@property(nonatomic,strong) UIImage * _barImage;

@end

@implementation ZLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout= UIRectEdgeNone; 
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)navigationBarBackgroundImageColor:(UIColor *)barColor{
    UIImage * barImage = [[[UIImage alloc]init] imageWithTintColor:barColor imageSize:CGSizeMake(1, 1)];
    self._barImage = barImage;
    [self.navigationController.navigationBar setBackgroundImage:barImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];    
}
- (void)pushViewController:(ZLBaseViewController *)viewController withParams:(NSDictionary *)params
{
    if (!ZLCheckObjectNull(params)) {
        if (params.count>0) {
            NSDictionary * propertys = params;
            [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([self checkIsExistPropertyWithInstance:viewController verifyPropertyName:key]) {
                    [viewController setValue:obj forKey:key];
                }
            }];
        }
    }
    [self pushViewController:viewController];
    
}
- (void)pushViewControllerName:(NSString *)instance withParams:(NSDictionary *)params{
    if (ZLStringIsNull(instance)) {
        NSAssert(NO, @"没有传进来要跳转的页面！！！！！！");
        return;
    }
    ZLBaseViewController * viewController = [[NSClassFromString(instance) alloc] init];
    [self pushViewController:viewController withParams:params];
}
- (void)pushViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

- (void)removeViewControllers:(NSArray <NSString *>*)viewControllers{
    
    NSMutableArray * viewControllersM =[@[] mutableCopy];
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * selfString =   NSStringFromClass([obj class]);
        if (![viewControllers containsObject:selfString]) {
            [viewControllersM addObject:obj];
        }
    }];
    [self asyncPushToViewController:^{
        [self.navigationController setViewControllers:viewControllersM animated:YES];
        
        NSLog(@"%@",self.navigationController.viewControllers);
    }];
}

- (void)asyncPushToViewController:(dispatch_block_t)block{
    if (ZL_IOS8) {
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
#pragma mark -UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName withObject:(id)obj withUserInfo:(id)userInfo {
    SEL action = NSSelectorFromString(eventName);
    [self performSelector:action withObjects:nil];
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
