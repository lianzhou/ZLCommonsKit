//
//  ZLNetworkTask.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import "ZLNetworkTask.h"
#import "ZLSystemMacrocDefine.h"

@implementation ZLNetworkTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskType = ZLNetworkTaskTypeJsonRequest;
        _requestMethod = ZLHttpRequestMethod_POST;
        _host = @"";
        _requestHeaders = [@{} mutableCopy];
        _taskIdentifier = [ZLSystemUtils currentTimeStampString];
        _timeoutInterval = 30.0f;
    }
    return self;
}
- (ZLNetworkTask *)httpRequestMethod:(ZLHttpRequestMethod)method URL:(NSString *)interface params:(NSDictionary *)params success:(ZLRequestSuccessBlock)successBlock failure:(ZLRequestFailureBlock)failureBlock{
    ZLNetworkTask  * task = [[ZLNetworkTask alloc]init];
    task.requestMethod = method;
    task.interface = interface;
    task.params = params;
    task.successBlock = successBlock;
    task.failureBlock = failureBlock;
    
    return task;
}

@end
