//
//  JZBaseTabBarController.m
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#import "JZBaseTabBarController.h"
#import "JZTabBarProtocol.h"
#import "JZContext.h"
#import "JZBaseNavigationController.h"
#import "JZSystemMacrocDefine.h"
#import "JZTabBar.h"

NSString *const JZTabBarItemController    = @"JZTabBarItemController";
NSString *const JZTabBarItemTitle         = @"JZTabBarItemTitle";
NSString *const JZTabBarItemImage         = @"JZTabBarItemImage";
NSString *const JZTabBarItemSelectedImage = @"JZTabBarItemSelectedImage";
NSString *const JZTabBarItemSelectedColor = @"JZTabBarItemSelectedColor";
NSString *const JZTabBarItemColor = @"JZTabBarItemColor";

#define TabBarItemTag  1993

@interface JZBaseTabBarController ()
{
    JZTabBarItem   * _lastTabBarItem;
    dispatch_block_t _touchTabBarItemGotoTopBlock;
    
    BOOL _customNavBarViewHideStatus;
    
    id <JZTabBarProtocol> _appTabBaeModule;
    
    NSArray <NSDictionary *>* _tabBarItemsAttributes;
}
@property(nonatomic,strong) JZTabBar *customerTabBar;

@end

@implementation JZBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomerTabBar];
    
    NSMutableArray * modules =  [[JZContext shareInstance].appConfig moduleServicesWithProtocol:@protocol(JZTabBarProtocol)];
    id <JZTabBarProtocol> module = [modules firstObject];
    if (module) {
        _appTabBaeModule = module;
    }else{
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"<创建TabBar没有实现 “JZTabBarProtocol”>"] userInfo:nil];
    }
    _tabBarItemsAttributes = [module tabBarItemsAttributes];
    
    NSMutableArray <UIViewController *>*  viewControllers = [@[] mutableCopy];
    [_tabBarItemsAttributes enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        [viewControllers addObject:[self addController:obj]];
        [self createTabBarItem:obj index:idx];
    }];
    [self setViewControllers:viewControllers];
    [self setSelectedIndex:[_appTabBaeModule selectedBarIndex]];

    
}
/* 添加控制器 */
-(UIViewController*)addController:(NSDictionary*)classDic
{
    NSString * className = [classDic objectForKey:JZTabBarItemController];
    NSString * classTitle = [classDic objectForKey:JZTabBarItemTitle];
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    JZBaseNavigationController *navCtr = [[JZBaseNavigationController alloc] initWithRootViewController:subViewController];
    subViewController.title = classTitle;
    return navCtr;
}
/* 创建自定义TabBar */
-(void)addCustomerTabBar{

    self.tabBar.translucent =NO;
    self.tabBar.tintColor = UIColorFromRGB(0xffffff);
    JZTabBar *customerTabBar=[[JZTabBar alloc] initWithFrame:CGRectZero];
    [self setValue:customerTabBar forKeyPath:@"tabBar"];
    if ([_appTabBaeModule tabBarShowShadowColor]) {
        [customerTabBar tabBarShowShadowColor];
    }
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height*2)];
    bgview.backgroundColor = [UIColor whiteColor];
    [customerTabBar addSubview:bgview];
    
    self.customerTabBar=customerTabBar;    
}
/* 创建自定义TabBarItem */
- (void)createTabBarItem:(NSDictionary*)imageDictionary index:(NSUInteger)idx{
    //坐标
    CGFloat width=SCREEN_WIDTH/_tabBarItemsAttributes.count;
    CGFloat topMargin=0;
    CGFloat height = 50;


    
    JZTabBarItem * tabBarItem = [[JZTabBarItem alloc]initWithFrame:CGRectMake(idx*width, topMargin, width, height)];
    tabBarItem.backgroundColor = [UIColor whiteColor];
    tabBarItem.image = [UIImage imageNamed:imageDictionary[JZTabBarItemImage]];
    tabBarItem.selectedImage = [UIImage imageNamed:imageDictionary[JZTabBarItemSelectedImage]];
    tabBarItem.title = imageDictionary[JZTabBarItemTitle];

    UIColor * selectedColor = imageDictionary[JZTabBarItemSelectedColor];
    UIColor * titleColor = imageDictionary[JZTabBarItemColor];
    tabBarItem.titleColor = titleColor;
    if (selectedColor) {
        if ([selectedColor isKindOfClass:[UIColor class]]) {
            tabBarItem.titleSelectedColor = selectedColor;
        }else{
            tabBarItem.titleSelectedColor = titleColor;
        }
    }else{
        tabBarItem.titleSelectedColor = titleColor;
    }
    
    tabBarItem.tag = idx+TabBarItemTag;
    [tabBarItem addTarget:self action:@selector(tabBarItemUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarItem addTarget:self action:@selector(tabBarItemDownAction:) forControlEvents:UIControlEventTouchDown];
    
    
    
    if (idx == [_appTabBaeModule selectedBarIndex]) {
        tabBarItem.selected = YES;
        _lastTabBarItem = tabBarItem;
    }

    tabBarItem.clipsToBounds = YES;
    
    [self.tabBarItems addObject:tabBarItem];
    [self.customerTabBar addSubview:tabBarItem];
}

- (void)setSelectedBarItemIndex:(NSUInteger)selectedBarItemIndex{
    if (selectedBarItemIndex >= self.tabBarItems.count) {
        selectedBarItemIndex = self.tabBarItems.count -1;
    }
    _selectedBarItemIndex = selectedBarItemIndex;
    JZTabBarItem * tabBarItem = [self.tabBarItems objectAtIndex:selectedBarItemIndex];
    [self tabBarItemDownAction:tabBarItem];
    [self tabBarItemUpAction:tabBarItem];
}
/* TabBarItem点击松开事件 */
-(void)tabBarItemUpAction:(JZTabBarItem*)sender
{    
    if (sender.selected == NO) {
        sender.selected = YES;
        if (_lastTabBarItem != sender) {
            _lastTabBarItem.selected = NO;
            _lastTabBarItem = (JZTabBarItem *)sender;
        }
    }else{
        
        if (sender.tag == 1+TabBarItemTag||sender.tag == TabBarItemTag) {
            if (sender.isTop) {
                if (_touchTabBarItemGotoTopBlock) {
                    _touchTabBarItemGotoTopBlock();
                }
            }
        }
    }
    
}
- (void)touchTabBarItemGotoTop:(dispatch_block_t)block{
    if (_touchTabBarItemGotoTopBlock) {
        _touchTabBarItemGotoTopBlock = nil;
    }
    _touchTabBarItemGotoTopBlock = block;
}
/* TabBarItem 点击按下事件 */
-(void)tabBarItemDownAction:(JZTabBarItem*)sender
{
    if ([_appTabBaeModule respondsToSelector:@selector(tabBarSelectedIndex:completionHandler:)]) {
        __block BOOL completionB = YES;
        [_appTabBaeModule tabBarSelectedIndex:sender.tag - TabBarItemTag completionHandler:^(BOOL completion) {
            completionB = completion;
        }];
        if (!completionB) {
            return;
        }
    }
    
    [self setSelectedIndex:sender.tag - TabBarItemTag];
    if ([_appTabBaeModule tabBarScaleImageButtonAnimate]) {
        JZTabBarItem * tabBarItem = self.tabBarItems[sender.tag - TabBarItemTag];
        [tabBarItem scaleImageButtonAnimate];
    }
    if (sender.tag > 1+TabBarItemTag) {
        JZTabBarItem * tabBarItem0 = self.tabBarItems[0];
        [tabBarItem0 removeAllAnimations];
        JZTabBarItem * tabBarItem1 = self.tabBarItems[1];
        [tabBarItem1 removeAllAnimations];
    }
}
- (void)showTopAnimateSelectedIndex:(NSInteger)manualIndex{
    JZTabBarItem * tabBarItem = self.tabBarItems[manualIndex];
    [tabBarItem showTopAnimate:self.selectedIndex == manualIndex?.8f:0.0f];
}
- (void)hideTopAnimateSelectedIndex:(NSInteger)manualIndex{
    JZTabBarItem * tabBarItem = self.tabBarItems[manualIndex];
    [tabBarItem hideTopAnimate:self.selectedIndex == manualIndex?.8f:0.0f];
}

- (NSMutableArray<JZTabBarItem *> *)tabBarItems
{
    if (!_tabBarItems) {
        _tabBarItems = [[NSMutableArray alloc]init];
    }
    return _tabBarItems;
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
