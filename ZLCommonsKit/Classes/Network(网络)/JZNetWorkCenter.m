//
//  JZNetWorkCenter.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import "JZNetWorkCenter.h"
#import "JZStringMacrocDefine.h"
#import "JZAppConfig.h"
#import "NSString+Extension.h"
#import "JZSystemUtils.h"


@interface JZNetWorkCenter ()

@property (nonatomic,assign) int i;

@end

@implementation JZNetWorkCenter

+ (JZNetWorkCenter *)shareCenter
{
    static JZNetWorkCenter *_netWorkCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _netWorkCenter = [[self alloc]init];
    });
    return _netWorkCenter;
}
- (NSString *)requestWithCondition:(JZNetWorkCenterCondition*)condition
                  withSuccessBlock:(JZRequestSuccessBlock)success
                    withFaildBlock:(JZRequestFailureBlock)faild{

    if (condition.requestType == JZNetworkRequestTypeOrange) {
        return [self OrangeRequestWithCondition:condition withSuccessBlock:success withFaildBlock:faild];
    }else if (condition.requestType == JZNetworkRequestTypeXKP){
        return [self XKPRequestWithCondition:condition withSuccessBlock:success withFaildBlock:faild];
    }else if (condition.requestType == JZNetworkRequestTypeYouKu){
        return [self youKuRequestWithCondition:condition withSuccessBlock:success withFaildBlock:faild];
    }
    JZNetworkTask * task = [[JZNetworkTask alloc]init];
    return task.taskIdentifier;
    
    
//    condition.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:[JZNetWorkCenter requestHeaders:condition.requestHeaders isLogin:condition.isLogin]];
//
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://it.teach.juziwl.cn:8090/"]];
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = condition.timeoutInterval;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
////    accessToken
//    if (!JZStringIsNull([JZAppConfig shareInstance].apiConfigItem.accessToken)) {
//
//        [manager.requestSerializer setValue:[JZAppConfig shareInstance].apiConfigItem.accessToken forHTTPHeaderField:@"accessToken"];
//    }
//
//
//    if (condition.requestHeaders.count >0) {
//
//        [condition.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//        }];
//    }else{
//    }
//
//    [manager POST:condition.interface parameters:condition.params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)responseObject;
//        success(nil,responseObject,200);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        networkTask.task = task;
////        [self failureWithTask:networkTask error:error];
//    }];
//    return nil;
    
}
- (NSString *)OrangeRequestWithCondition:(JZNetWorkCenterCondition*)condition
                  withSuccessBlock:(JZRequestSuccessBlock)success
                    withFaildBlock:(JZRequestFailureBlock)faild{
    
    JZNetworkTask * task = [[JZNetworkTask alloc]init];
    if (JZStringIsNull(condition.host)) {
        task.host = [JZAppConfig shareInstance].apiConfigItem.host;
    }else{
        task.host = condition.host;
    }
    task.timeoutInterval = condition.timeoutInterval;
    task.subKey = condition.subKey;
    task.isNoUseAES = condition.isNoUseAES;
    task.params = condition.params;
    task.requestMethod = condition.requestMethod;
    task.interface = condition.interface;
    task.fileModels = condition.fileModels;
    task.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:[JZNetWorkCenter requestHeaders:condition.requestHeaders isLogin:condition.isLogin]];;
    
   
    task.successBlock = success;
    task.failureBlock = faild;
    task.taskType=condition.taskType;
    if (task.taskType == JZNetworkTaskTypeJsonRequest) {
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeXmlRequest){
        [[JZNetWorkManager shareXMLManager]  addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeUploadFile){
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeDownloadFile){
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else{
        NSCAssert(NO, @"一个非法请求");
    }
    
    return task.taskIdentifier;
}
- (NSString *)youKuRequestWithCondition:(JZNetWorkCenterCondition *)condition
                       withSuccessBlock:(JZRequestSuccessBlock)success
                         withFaildBlock:(JZRequestFailureBlock)faild{
    JZNetworkTask *task = [[JZNetworkTask alloc]init];
    task.timeoutInterval = condition.timeoutInterval;
    task.params = condition.params;
    task.requestMethod = condition.requestMethod;
    task.interface = condition.interface;
    task.successBlock = success;
    task.failureBlock = faild;
    if (task.taskType == JZNetworkTaskTypeJsonRequest) {
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeXmlRequest){
        [[JZNetWorkManager shareXMLManager]  addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeUploadFile){
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else if (task.taskType == JZNetworkTaskTypeDownloadFile){
        [[JZNetWorkManager shareJSONManager] addTask:task];
    }else{
        NSCAssert(NO, @"一个非法请求");
    }
    return task.taskIdentifier;
}
- (NSString *)XKPRequestWithCondition:(JZNetWorkCenterCondition*)condition
                              withSuccessBlock:(JZRequestSuccessBlock)success
                                withFaildBlock:(JZRequestFailureBlock)faild{
    
    JZNetworkTask * task = [[JZNetworkTask alloc]init];
    if (JZStringIsNull(condition.host)) {
        task.host = JZ_XKP_CARD_BASE_URL;
    }else{
        task.host = condition.host;
    }
    task.taskType = JZNetworkTaskTypeXmlRequest;
    task.timeoutInterval = condition.timeoutInterval;
    task.params = condition.params;
    task.requestMethod = condition.requestMethod;
    task.interface = condition.interface;
    task.successBlock = success;
    task.failureBlock = faild;
   
   if (task.taskType == JZNetworkTaskTypeXmlRequest){
        [[JZNetWorkManager shareXMLManager]  addTask:task];
    }else{
        NSCAssert(NO, @"一个非法请求");
    }
    return task.taskIdentifier;
}


- (void)cancelRequest:(NSString *)requestIdentifier{

}
- (void)cancelRequestList:(NSMutableArray <NSString *>*)identifierList{

}

+ (NSMutableDictionary *)requestHeaders:(NSMutableDictionary *)requestHeaders isLogin:(BOOL)isLogin{
    

    if (!isLogin) {
        if (requestHeaders) {
            [requestHeaders addEntriesFromDictionary:[self authenticationDictionary]];
            return requestHeaders;
        }else{
            if ([JZStringUitil stringIsNull:[JZAppConfig shareInstance].apiConfigItem.userId]&&
                [JZStringUitil stringIsNull:[JZAppConfig shareInstance].apiConfigItem.accessToken]) {
//                NSCAssert(NO, @"[userId]或者[accessToken]为空,请检查!!!");
                return nil;
            }
            
            NSMutableDictionary * requestHeader = [@{
                                                     @"Uid":[JZAppConfig shareInstance].apiConfigItem.userId,
                                                     @"AccessToken":[JZAppConfig shareInstance].apiConfigItem.accessToken,
                                                     
                                                     @"source":@"101",
                                                     @"Accept":@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
                                                     }
                                                   mutableCopy];
            
            

            
            [requestHeader addEntriesFromDictionary:[self authenticationDictionary]];
//            NSLog(@"requestHeader ------- %@",requestHeader);
            return requestHeader;
        }
    }else{
        if (!requestHeaders) {
            requestHeaders = [@{} mutableCopy];
        }
        [requestHeaders addEntriesFromDictionary:[self authenticationDictionary]];
//        NSLog(@"requestHeaders ------- %@",requestHeaders);
        return requestHeaders;
    }
    return nil;
}
#define JZYYYYMMddHHmmss @"yyyy-MM-dd HH:mm:ss"//2015-07-21 13:27:30
+ (NSMutableDictionary *)authenticationDictionary{
    NSMutableDictionary * authenticationParams = [@{} mutableCopy];
    
//    NSString * obtainSixRandomNo = [NSString obtainSixRandomNo];
//    NSString * obtainCurrentTime = [NSString obtainCurrentTime];
//    NSString * formattCurrentTime = [obtainCurrentTime stringByReplacingOccurrencesOfString:@" " withString:@""];
//    formattCurrentTime = [formattCurrentTime stringByReplacingOccurrencesOfString:@":" withString:@""];
//    formattCurrentTime = [formattCurrentTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
////    NSLog(@"formattCurrentTime（请求时的时间）: ---------- %@",formattCurrentTime);
//    NSString * transId = [NSString stringWithFormat:@"%@%@",formattCurrentTime,obtainSixRandomNo];
////    NSLog(@"transId --------- %@",transId);
//    NSString * syssign = [NSString stringWithFormat:@"exueyunServ%@",transId];
    [authenticationParams setObject:@"exueyun" forKey:@"SENDER"];
    [authenticationParams setObject:@"exueyunServ" forKey:@"RECEIVER"];
    [authenticationParams setObject:@"exueyunServ" forKey:@"SERVCODE"];
    [authenticationParams setObject:@"request" forKey:@"MSGTYPE"];
    [authenticationParams setObject:@"2.0" forKey:@"VERSION"];
    if (!JZStringIsNull([JZAppConfig shareInstance].apiConfigItem.clientType)) {
        [authenticationParams setObject:[NSString stringWithFormat:@"3:%@:%@",[self clientTypeWithUserType],[JZSystemUtils obtainVersionNumber]] forKey:@"clientType"];
    }else{
        [authenticationParams setObject:[NSString stringWithFormat:@"3:1:%@",[JZSystemUtils obtainVersionNumber]] forKey:@"clientType"];
    }
//
//    [authenticationParams setObject:obtainCurrentTime forKey:@"TIME"];
//    [authenticationParams setObject:transId forKey:@"TRANSID"];
//    [authenticationParams setObject:[syssign md5String] forKey:@"SYSSIGN"];

    
    return authenticationParams;
}

+ (NSString *)clientTypeWithUserType{
    
    NSString *clientType = [JZAppConfig shareInstance].apiConfigItem.clientType;
    
    if ([clientType isEqualToString:@"0"]) {
        return @"1";
    }else if ([clientType isEqualToString:@"1"]){
        return @"3";
    }else if ([clientType isEqualToString:@"2"]){
        return @"2";
    }else if ([clientType isEqualToString:@"4"]){
        return @"4";
    }
    return @"1";
}

@end
