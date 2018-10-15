//
//  JZNetworkTask.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import "JZNetworkTask.h"
#import "JZSystemMacrocDefine.h"

@implementation JZNetworkTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskType = JZNetworkTaskTypeJsonRequest;
        _requestMethod = JZHttpRequestMethod_POST;
        _host = @"";
        _requestHeaders = [@{} mutableCopy];
        _taskIdentifier = [JZSystemUtils currentTimeStampString];
        _timeoutInterval = 30.0f;
    }
    return self;
}
- (JZNetworkTask *)httpRequestMethod:(JZHttpRequestMethod)method URL:(NSString *)interface params:(NSDictionary *)params success:(JZRequestSuccessBlock)successBlock failure:(JZRequestFailureBlock)failureBlock{
    JZNetworkTask  * task = [[JZNetworkTask alloc]init];
    task.requestMethod = method;
    task.interface = interface;
    task.params = params;
    task.successBlock = successBlock;
    task.failureBlock = failureBlock;
    
    return task;
}

@end
