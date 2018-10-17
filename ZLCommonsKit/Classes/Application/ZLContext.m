//
//  ZLContext.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "ZLContext.h"

@interface ZLContext ()

@end

@implementation ZLContext

+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id ZLContextInstance = nil;
    dispatch_once(&once_t, ^{
        ZLContextInstance = [[[self class] alloc] init];
        if ([ZLContextInstance isKindOfClass:[ZLContext class]]) {
            ((ZLContext *) ZLContextInstance).dataConfig = [ZLDataConfig shareInstance];
            ((ZLContext *) ZLContextInstance).appConfig = [ZLAppConfig shareInstance];
        }
    });
    return ZLContextInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.openURLItem = [[ZLOpenURLItem alloc] init];
        self.notificationsItem = [[ZLNotificationsItem alloc] init];
        self.userActivityItem = [[ZLUserActivityItem alloc]init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
        self.touchShortcutItem = [[ZLShortcutItem alloc]init];
#endif
    }
    
    return self;
}

@end
