//
//  ZLBaseDataModel.m
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#import "ZLBaseDataModel.h"
#import "ZLStringMacrocDefine.h"
#import "ZLAppConfig.h"

@implementation ZLBaseDataModel

- (NSString *)errorMsg{
    if (!ZLStringIsNull(_errorMsg)) {
        return _errorMsg;
    }
    return @"请求繁忙,请稍后再试!";
}

- (void)setTimeStamp:(long long)timeStamp {
    
    _timeStamp = timeStamp;
    if (timeStamp) {
    
        [ZLAppConfig shareInstance].apiConfigItem.timeStamp = timeStamp;
    }
}



@end


@implementation ZLPaginationModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.rows = 10;
    }
    return self;
}

- (NSMutableDictionary *)fetchObjectParams{
    
    NSMutableDictionary * params = [@{} mutableCopy];
    [params setValue:[NSNumber numberWithInteger:self.page] forKey:@"page"];
    [params setValue:[NSNumber numberWithInteger:self.rows] forKey:@"rows"];
    return params;
}

- (void)addPageWithSuccess{
    self.page += 1;
}
- (void)initializeObjectPage {
    self.page = 1;
}
@end
