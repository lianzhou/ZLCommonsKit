//
//  ZLNetWorkCenter.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import <Foundation/Foundation.h>
#import "ZLNetWorkManager.h"
#import "ZLNetWorkCenterCondition.h"


@interface ZLNetWorkCenter : NSObject

+ (ZLNetWorkCenter *)shareCenter;

- (NSString *)requestWithCondition:(ZLNetWorkCenterCondition*)condition
                  withSuccessBlock:(ZLRequestSuccessBlock)success
                    withFaildBlock:(ZLRequestFailureBlock)faild;

- (void)cancelRequest:(NSString *)requestIdentifier;
- (void)cancelRequestList:(NSMutableArray <NSString *>*)identifierList;

+ (NSMutableDictionary *)authenticationDictionary;

@end
