//
//  JZNetWorkManager.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import <Foundation/Foundation.h>
#import "JZNetworkTask.h"
#import "JZNetworkMacrocDefine.h"

/**
 *  一卡通信息
 */
#define JZ_CARD_CONSUME_ACCOUNT        @"admin"
#define JZ_CARD_CONSUME_PASSWORD       @"admin"
#define JZ_CARD_PASSWORD               @"123456"

//新开普的key
static const NSString *XKPParamKey = @"XKPParamKey";

@interface JZNetWorkManager : NSObject

+ (JZNetWorkManager *)shareJSONManager;
+ (JZNetWorkManager *)shareXMLManager;

- (void)addTask:(JZNetworkTask *)task;

@end
