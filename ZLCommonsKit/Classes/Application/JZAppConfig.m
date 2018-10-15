//
//  JZAppConfig.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "JZAppConfig.h"
#import "JZStringMacrocDefine.h"
#import "JZModuleProtocol.h"

@interface JZAppConfig ()

@property (nonatomic, strong) NSMutableDictionary <NSString* , id<NSObject>> *appModuleService;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation JZAppConfig
+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id JZAppConfigInstance = nil;
    dispatch_once(&once_t, ^{
        JZAppConfigInstance = [[self alloc] init];
    });
    return JZAppConfigInstance;
}
- (void)registedModuleServices:(NSMutableArray <id<NSObject>> *)moduleServices{
    [self registedModuleServices:moduleServices protocol:@protocol(JZModuleProtocol)];
}

- (void)registedModuleServices:(NSMutableArray <id<NSObject>> *)moduleServices protocol:(Protocol *)protocol{
    if (JZStringIsNull(NSStringFromProtocol(protocol))) {
        return;
    }
    [self.lock lock];
    [self.appModuleService setObject:moduleServices forKey:NSStringFromProtocol(protocol)];
    [self.lock unlock];
}

- (NSMutableArray <id<NSObject>>*)moduleServicesWithProtocol:(Protocol *)protocol{
    if (![self checkValidService:protocol]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"<%@>还没有注册", NSStringFromProtocol(protocol)] userInfo:nil];
    }
    return [[self servicesDict] objectForKey:NSStringFromProtocol(protocol)];
}
- (void)addModuleService:(id<NSObject>)moduleService protocol:(Protocol *)protocol{
    if ([self checkValidService:protocol]) {
        NSMutableArray * moduleServices = [[self servicesDict] objectForKey:NSStringFromProtocol(protocol)];
        [moduleServices addObject:moduleService];
        [self registedModuleServices:moduleServices protocol:protocol];        
    }else{
        NSMutableArray * moduleServices = [@[] mutableCopy];
        [self registedModuleServices:moduleServices protocol:protocol];        
    }
}
- (BOOL)checkValidService:(Protocol *)protocol
{
    if (JZStringIsNull(NSStringFromProtocol(protocol))) {
        return NO;
    }

    return [[self servicesDict].allKeys containsObject:NSStringFromProtocol(protocol)];
}

- (NSDictionary *)servicesDict
{
    [self.lock lock];
    NSDictionary *dict = [self.appModuleService copy];
    [self.lock unlock];
    return dict;
}
- (void)setApiConfigItem:(JZAPIConfigItem *)apiConfigItem{
    _apiConfigItem = apiConfigItem;
}
#pragma mark - 懒加载
- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}
- (NSMutableDictionary *)appModuleService
{
    if (!_appModuleService) {
        _appModuleService = [@{} mutableCopy];
    }
    return _appModuleService;
}

- (NSString *)uploadHost {
    
    if (self.apiConfigItem.environmentType == JZNetEnvironmentTypeFormal) {
        return @"http://dfs.upload1.jzexueyun.com/";
    }
    return @"http://test.upload.juziwl.cn/";
}

@end

@implementation JZAPIConfigItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.environmentType       = JZNetEnvironmentTypeFormal;
    }
    return self;
}

- (NSString *)host{
    if (!_host) {
        _host = [[JZAppConfig shareInstance].apiConfigItem.environmentDictionary objectForKey:[NSNumber numberWithInteger:[JZAppConfig shareInstance].apiConfigItem.environmentType]];
    }
    if (JZStringIsNull(_host)) {
        _host = @"http://api.imexue.com";
    }
    return _host;
}
@end
