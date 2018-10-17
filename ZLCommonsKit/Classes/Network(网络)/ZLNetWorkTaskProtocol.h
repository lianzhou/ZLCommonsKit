//
//  ZLNetWorkTaskProtocol.h
//  ZLCommonsKit
//
//  Created by li_chang_en on 2017/11/24.
//

#import <Foundation/Foundation.h>
#import "ZLNetworkTask.h"
@class ZLNetWorkManager;
@protocol ZLNetWorkTaskProtocol <NSObject>

//自动刷新token
- (void)automaticRefreshTokenOnNetWorkManager:(ZLNetWorkManager *)workManager task:(ZLNetworkTask *)task successBlock:(ZLRequestSuccessBlock)successBlock failureBlock:(ZLRequestFailureBlock)failureBlock;

- (void)netWorkManagerMaintain:(ZLNetWorkManager *)workManager task:(ZLNetworkTask *)task response:(id)responseObject;


@end
