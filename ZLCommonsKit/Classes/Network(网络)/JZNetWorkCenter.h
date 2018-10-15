//
//  JZNetWorkCenter.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import <Foundation/Foundation.h>
#import "JZNetWorkManager.h"
#import "JZNetWorkCenterCondition.h"


@interface JZNetWorkCenter : NSObject

+ (JZNetWorkCenter *)shareCenter;

- (NSString *)requestWithCondition:(JZNetWorkCenterCondition*)condition
                  withSuccessBlock:(JZRequestSuccessBlock)success
                    withFaildBlock:(JZRequestFailureBlock)faild;

- (void)cancelRequest:(NSString *)requestIdentifier;
- (void)cancelRequestList:(NSMutableArray <NSString *>*)identifierList;

+ (NSMutableDictionary *)authenticationDictionary;

@end
