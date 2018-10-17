//
//  ZLNetWorkManager.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import <Foundation/Foundation.h>
#import "ZLNetworkTask.h"
#import "ZLNetworkMacrocDefine.h"

/**
 *  一卡通信息
 */
#define ZL_CARD_CONSUME_ACCOUNT        @"admin"
#define ZL_CARD_CONSUME_PASSWORD       @"admin"
#define ZL_CARD_PASSWORD               @"123456"

//新开普的key
static const NSString *XKPParamKey = @"XKPParamKey";

@interface ZLNetWorkManager : NSObject

+ (ZLNetWorkManager *)shareJSONManager;
+ (ZLNetWorkManager *)shareXMLManager;

- (void)addTask:(ZLNetworkTask *)task;

@end
