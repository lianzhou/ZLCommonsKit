//
//  JZAppConfig.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>
#import "JZBaseTabBarController.h"
#import "JZCollectionUtils.h"

@interface JZAPIConfigItem : NSObject

//服务器时间戳
@property (nonatomic, assign) long long timeStamp;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *clientType;

@property (nonatomic, assign) JZNetEnvironmentType environmentType;

@property (nonatomic, strong) NSDictionary <NSNumber * ,NSString *>* environmentDictionary;

@property (nonatomic, copy) NSString *host;


@end

@interface JZAppConfig : NSObject

@property (nonatomic, strong) JZBaseTabBarController*tabBarController;

@property (nonatomic, strong) JZAPIConfigItem * apiConfigItem;

//上传资源的地址
@property (copy, nonatomic)NSString *uploadHost;

+ (instancetype)shareInstance;

- (void)registedModuleServices:(NSMutableArray <id<NSObject>> *)moduleServices;

- (void)registedModuleServices:(NSMutableArray <id<NSObject>> *)moduleServices protocol:(Protocol *)protocol;
- (void)addModuleService:(id<NSObject>)moduleService protocol:(Protocol *)protocol;

- (NSMutableArray <id<NSObject>>*)moduleServicesWithProtocol:(Protocol *)protocol;

- (BOOL)checkValidService:(Protocol *)service;

- (NSMutableDictionary *)appModuleService;

@end
