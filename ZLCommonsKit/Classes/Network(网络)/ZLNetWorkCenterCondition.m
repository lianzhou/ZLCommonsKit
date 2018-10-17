//
//  ZLNetWorkCenterCondition.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import "ZLNetWorkCenterCondition.h"

@implementation ZLNetWorkCenterCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskType = ZLNetworkTaskTypeJsonRequest;
        _requestMethod = ZLHttpRequestMethod_POST;
        _requestType = ZLNetworkRequestTypeOrange;
        _timeoutInterval = 30.0f;
        _isLogin = NO;
    }
    return self;
}

@end
