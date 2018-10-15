//
//  JZNetWorkCenterCondition.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import "JZNetWorkCenterCondition.h"

@implementation JZNetWorkCenterCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskType = JZNetworkTaskTypeJsonRequest;
        _requestMethod = JZHttpRequestMethod_POST;
        _requestType = JZNetworkRequestTypeOrange;
        _timeoutInterval = 30.0f;
        _isLogin = NO;
    }
    return self;
}

@end
