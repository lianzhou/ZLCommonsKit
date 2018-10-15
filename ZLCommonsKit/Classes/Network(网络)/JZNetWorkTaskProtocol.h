//
//  JZNetWorkTaskProtocol.h
//  JZCommonsKit
//
//  Created by li_chang_en on 2017/11/24.
//

#import <Foundation/Foundation.h>
#import "JZNetworkTask.h"
@class JZNetWorkManager;
@protocol JZNetWorkTaskProtocol <NSObject>

//自动刷新token
- (void)automaticRefreshTokenOnNetWorkManager:(JZNetWorkManager *)workManager task:(JZNetworkTask *)task successBlock:(JZRequestSuccessBlock)successBlock failureBlock:(JZRequestFailureBlock)failureBlock;

- (void)netWorkManagerMaintain:(JZNetWorkManager *)workManager task:(JZNetworkTask *)task response:(id)responseObject;


@end
