//
//  JZNetWorkManager.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import "JZNetWorkManager.h"
#import "JZStringMacrocDefine.h"
#import "JZBaseDataModel.h"
#import "MJExtension.h"
#import "JZContext.h"
#import "JZNetWorkTaskProtocol.h"
#import "NSString+Extension.h"
#import "KeychainItemWrapper.h"
#import <AdSupport/AdSupport.h>
#import "JZSystemUtils.h"
@interface JZNetWorkManager()
{
    AFHTTPSessionManager *_manager;
}

@end

@implementation JZNetWorkManager

+ (JZNetWorkManager *)shareJSONManager {
//    static JZNetWorkManager *_netWorkManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken,^{
//        if (_netWorkManager == nil) {
//            _netWorkManager = [[JZNetWorkManager alloc]init:YES];
//        }
//    });
//    return _netWorkManager;
    return [[JZNetWorkManager alloc]init:YES];
}
+ (JZNetWorkManager *)shareXMLManager {
    static JZNetWorkManager *_netWorkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (_netWorkManager == nil) {
            _netWorkManager = [[JZNetWorkManager alloc]init:NO];
        }
    });
    return _netWorkManager;
}


-(instancetype)init:(BOOL)isJson{
    self = [super init];
    if (self) {        
        _manager = [AFHTTPSessionManager manager];
        if (isJson) {
        
            _manager.requestSerializer = [AFJSONRequestSerializer serializer];
            _manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [_manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            [_manager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
//            [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSString *wrapperKey = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:wrapperKey accessGroup:nil];
            NSString *appIdentifier = [NSString stringWithFormat:@"%@",[wrapper objectForKey:(id)kSecValueData]];
            if (JZStringIsNull(appIdentifier)) {
                appIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                [wrapper setObject:@"eStudyParentTeacher" forKey:(id)kSecAttrService];
                [wrapper setObject:@"eStudyParentTeacher" forKey:(id)kSecAttrAccount];
                [wrapper setObject:appIdentifier forKey:(id)kSecValueData];
                [wrapper setObject:(id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(id)kSecAttrAccessible];
            }
            NSString *requestTagString = [NSString stringWithFormat:@"%@/%@",[JZSystemUtils deviceString],appIdentifier];
            [_manager.requestSerializer setValue:requestTagString forHTTPHeaderField:@"TAG"];
            
        } else {
             [_manager.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
            _manager.requestSerializer.timeoutInterval = 30;
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
    }
    return self;
}

- (void)addTask:(JZNetworkTask *)task{
    
    if (task.taskType == JZNetworkTaskTypeJsonRequest) {
        [self addDataTask:task];
    }else if (task.taskType == JZNetworkTaskTypeXmlRequest){
        [self addXKPTask:task];
    }else if (task.taskType == JZNetworkTaskTypeUploadFile){
        [self addUploadFileTask:task];
    }else if (task.taskType == JZNetworkTaskTypeDownloadFile){
        [self addDownloadFileTask:task];
    }
}
#define CustomErrorDomain @"com.networkTask.test"
#define XDefultFailed  -1000

#pragma mark - 数据请求

- (void)addDataTask:(JZNetworkTask *)networkTask{

//    [self failureWithTask:networkTask error:error];
    
    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
    YYReachabilityStatus internetStatus = reachability.status;
    if (internetStatus == YYReachabilityStatusNone) {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络出了点小差~ 请检查您的网络!"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [NSError errorWithDomain:CustomErrorDomain code:XDefultFailed userInfo:userInfo];
        [self failureWithTask:networkTask error:customError];
        return;
    }
    
    JZHttpRequestMethod method = networkTask.requestMethod;
    NSString * URLString = [NSString stringWithFormat:@"%@%@",networkTask.host,networkTask.interface];
    id params = networkTask.params;
    
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = networkTask.timeoutInterval;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    if (networkTask.requestHeaders.count >0) {
        
        [networkTask.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }else{
////        [_manager.requestSerializer removeHTTPHeaderField:@"AccessToken"];
////        [_manager.requestSerializer removeHTTPHeaderField:@"AccessToken"];
//
//        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"AccessToken"];
    }

//    NSString *targetId = [_manager.requestSerializer valueForHTTPHeaderField:@"TRANSID"];
//    NSString *increase = [_manager.requestSerializer valueForHTTPHeaderField:@"increase"];
//    NSLog(@"targetId -------------- %@,increase ---------- %@",targetId,increase);
    NSLog(@"请求的接口%@",URLString);
    NSLog(@"请求的参数%@",params);
//    NSLog(@"increase ---------- %@ -- %@",increase,[_manager.requestSerializer HTTPRequestHeaders]);
    
    
    if (method == JZHttpRequestMethod_POST) {
        if (networkTask.taskType == JZNetworkRequestTypeXKP) {
            [_manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
                return params;
            }];
        }
        id parameters =params;
        if (!JZStringIsNull(networkTask.subKey)) {
            parameters =[params objectForKey:networkTask.subKey] ;
            NSLog(@"%@",parameters);
        }
        
        [_manager.requestSerializer setValue:JZIFISNULL(networkTask.isNoUseAES) forHTTPHeaderField:@"useAes"];
        [_manager.requestSerializer setValue:networkTask.host forHTTPHeaderField:@"aesHost"];
        
        [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            [self progressTask:networkTask progress:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {    
            networkTask.task = task;
            [self successWithTask:networkTask response:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            networkTask.task = task;
            [self failureWithTask:networkTask error:error];
        }];
    }else if (method == JZHttpRequestMethod_GET){
        [_manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            [self progressTask:networkTask progress:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            networkTask.task = task;
            [self successWithTask:networkTask response:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            networkTask.task = task;
            [self failureWithTask:networkTask error:error];
        }];
    }else if (method == JZHttpRequestMethod_DELETE){
        [_manager DELETE:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            networkTask.task = task;
            [self successWithTask:networkTask response:responseObject];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            networkTask.task = task;
            [self failureWithTask:networkTask error:error];
        }];
    }else if (method == JZHttpRequestMethod_PUT){
        [_manager PUT:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            networkTask.task = task;
            [self successWithTask:networkTask response:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            networkTask.task = task;
            [self failureWithTask:networkTask error:error];
        }];
    }

}

- (void)addXKPTask:(JZNetworkTask *)networkTask {
    
    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
    YYReachabilityStatus internetStatus = reachability.status;
    if (internetStatus == YYReachabilityStatusNone) {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络出了点小差~ 请检查您的网络!"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [NSError errorWithDomain:CustomErrorDomain code:XDefultFailed userInfo:userInfo];
        [self failureWithTask:networkTask error:customError];
        return;
    }
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",networkTask.host,networkTask.interface];
    id params = networkTask.params;
    
//    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    _manager.requestSerializer.timeoutInterval = networkTask.timeoutInterval;
//    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    [networkTask.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//    }];
    
    NSString *paramString = [params objectForKey:XKPParamKey];
    NSLog(@"请求的接口%@",URLString);
    NSLog(@"请求的参数%@",paramString);
    
    [_manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        return paramString;
    }];
    
    [_manager POST:URLString parameters:paramString progress:^(NSProgress * _Nonnull uploadProgress) {
        [self progressTask:networkTask progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        networkTask.task = task;
        [self successXMLWithTask:networkTask response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        networkTask.task = task;
        [self failureXMLWithTask:networkTask error:error];
    }];
}

#pragma mark - success failure progress

/*! @brief *
 * 执行任务成功回调

 @param task 任务实体类
 @param responseObject 成功返回
 */

int SYSSIGNCount = 10;

- (void)successWithTask:(JZNetworkTask *)task response:(id)responseObject{

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        if ([task.interface isEqualToString:@"family/user/updateUserRegistrationId"]) {
            NSLog(@"12121212121");
        }
        
        if (![task.host containsString:@"192.168"]) {
            JZBaseDataModel * dataModel = [JZBaseDataModel mj_objectWithKeyValues:responseObject];
            if (dataModel) {
                if (dataModel.status == 4001 || dataModel.status == 4002 || dataModel.status == 4005) {
                    
                    NSMutableArray * modules =  [[JZContext shareInstance].appConfig moduleServicesWithProtocol:@protocol(JZNetWorkTaskProtocol)];
                    id <JZNetWorkTaskProtocol> module = [modules firstObject];
                    if (module && [module respondsToSelector:@selector(automaticRefreshTokenOnNetWorkManager:task:successBlock:failureBlock:)]) {
                        [module automaticRefreshTokenOnNetWorkManager:self task:task successBlock:^(JZNetworkTask *task, id dictData, NSInteger statusCode) {
                            
                        } failureBlock:^(JZNetworkTask *task, NSError *error) {
                            
                        }];
                        return;
                    }
                    
                } else if(dataModel.status == 5050){

                    NSMutableArray * modules =  [[JZContext shareInstance].appConfig moduleServicesWithProtocol:@protocol(JZNetWorkTaskProtocol)];
                    id <JZNetWorkTaskProtocol> module = [modules firstObject];
                    if (module && [module respondsToSelector:@selector(netWorkManagerMaintain:task:response:)]) {
                        [module netWorkManagerMaintain:self task:task response:responseObject];
                        return;
                    }
                }else if(dataModel.status == 4020){
                    
                    if(SYSSIGNCount > 0){
                        SYSSIGNCount --;
                        [self addTask:task];
                    }
                    return;
                }
            }
        }
    }
    if (task.successBlock) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.task.response;
        task.successBlock(task,responseObject,response.statusCode);
    }
}

- (void)successXMLWithTask:(JZNetworkTask *)task response:(id)responseObject {
    
    if (task.successBlock) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.task.response;
        task.successBlock(task,responseObject,response.statusCode);
    }
}

- (void)failureXMLWithTask:(JZNetworkTask *)task error:(NSError *)error {
    
//    NSError *customError = [NSError errorWithDomain:CustomErrorDomain code:XDefultFailed userInfo:userInfo];
    if (task.failureBlock) {
        task.failureBlock(task,error);
    }
}

/*! @brief *
 * 执行任务失败回调
 @param task 任务实体类
 @param error 错误
 */
- (void)failureWithTask:(JZNetworkTask *)task error:(NSError *)error{
    
    NSString * customString = [self failureWithError:error];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:customString                                                                      forKey:NSLocalizedDescriptionKey];
    
    NSError *customError = [NSError errorWithDomain:CustomErrorDomain code:XDefultFailed userInfo:userInfo];
    if (task.failureBlock) {
        task.failureBlock(task,customError);
    }

}
- (NSString *)failureWithError:(NSError *)error {
    NSLog(@"%@",error.userInfo);
    if ([error.userInfo.allKeys containsObject:NSUnderlyingErrorKey]) {
        NSError *underlyError= [error.userInfo objectForKey:NSUnderlyingErrorKey];
        if(underlyError && [underlyError isKindOfClass:[NSError class]] && [underlyError.userInfo.allKeys containsObject:AFNetworkingOperationFailingURLResponseDataErrorKey]){
            NSData *responseErrorData = underlyError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (responseErrorData && [responseErrorData isKindOfClass:[NSData class]]) {
                NSString * responseError = [[NSString alloc]initWithData:responseErrorData encoding:NSUTF8StringEncoding];
                if (!JZStringIsNull(responseError)) {
                    NSDictionary *responseErrorDic = [NSString jsonStringToNSDictionary:responseError];
                    if (responseErrorDic && [responseErrorDic isKindOfClass:[NSDictionary class]] && [responseErrorDic.allKeys containsObject:@"error"]) {
                        NSDictionary *errorDic =   [responseErrorDic objectForKey:@"error"];
                        if (errorDic && [errorDic isKindOfClass:[NSDictionary class]] && [errorDic.allKeys containsObject:@"key"]) {
                            NSString * errorKey = [errorDic objectForKey:@"key"];
                            if (!JZStringIsNull(errorKey)) {
                                return errorKey;
                            }
                        }
                    }
                }
            }
        }
    }
    if (!JZStringIsNull(error.localizedDescription)) {
        return error.localizedDescription;
    }
    return @"网络繁忙,请稍后再试!";    
}
/*! @brief *
 进度
 */
- (void)progressTask:(JZNetworkTask *)task progress:(NSProgress *)uploadProgress{
    if (task.progressBlock) {
        task.progressBlock(task,uploadProgress);
    }
}
#pragma mark - UploadFile
- (void)addUploadFileTask:(JZNetworkTask *)networkTask{


    NSString * URLString = [NSString stringWithFormat:@"%@%@",networkTask.host,networkTask.interface];
    NSLog(@"请求的接口%@",URLString);
    _manager.requestSerializer.timeoutInterval = networkTask.timeoutInterval;   
    [networkTask.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { 
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//        [_manager.requestSerializer setValue:@"beb3400e-0be8-42d5-8609-ed4d07855b0d" forHTTPHeaderField:@"Uid"];
//        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"AccessToken"];
    }];
    [_manager POST:URLString parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [networkTask.fileModels enumerateObjectsUsingBlock:^(JZUploadFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            if (JZStringIsNull(obj.fileFullPath)) {
                if (obj.fileData) {
                    [formData appendPartWithFileData:obj.fileData name:@"files" fileName:obj.fileName mimeType:obj.fileType];
                }else{
                    
                }
            }else{
                NSError * error;
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:obj.fileFullPath] name:@"files" fileName:obj.fileName mimeType:obj.fileType error:&error];
                if (error) {
                    NSLog(@"%@",error);
                }
            }
        }];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [self progressTask:networkTask progress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        networkTask.task = task;
        
        [self successWithTask:networkTask response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        networkTask.task = task;
        [self failureWithTask:networkTask error:error];
    }];
}
- (NSMutableData *)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"--%@\r\n", boundary];
    [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName];
    [body appendFormat:@"Content-Type: %@\r\n\r\n",mimeType];
    [bodyData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:data];
    return bodyData;
}
#pragma mark - DownloadFile

- (void)addDownloadFileTask:(JZNetworkTask *)networkTask{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

}

@end


///**
// * 成功
// */
//SUCCESS(200, "操作成功"),
//
///**
// * 页面未找到
// */
//NOT_FOUND(404, "服务路径未找到"),
//
///**
// * 服务器内部错误
// */
//INTERNAL_ERROR(500, "服务器内部错误"),
//
///**
// * 系统繁忙，请稍后再试，对应SystemBusyException
// */
//SYSTEM_BUSY_ERR(-1, "系统繁忙，请稍后再试"),
///**
// * 过于频繁，请稍后再试,对应RequestFrequentException
// */
//REQUEST_FREQUENTLY_ERR(1100, "访问过于频繁，请稍后再试"),
///**
// * 访问过期,对应TokenExpireException
// */
//TOKEN_EXPIRE(4001, "访问过期"),
///**
// * 不合法的凭证，对应TokenIllegalException
// */
//TOKEN_ILLEGAL(4002, "不合法的凭证"),
///**
// * 没有权限访问,对应AccessNoAuthException
// */
//NO_AUTH(4005, "没有权限访问"),
///**
// * 业务错误,对应BusinessException,例如：数据库中值已经存在的异常，业务数据不完整的异常等
// */
//BUSINESS_ERROR(4006, "业务错误"),
//
///**
// * 配置错误,对应ConfigException,例如：配置的值不符合预期的规则
// */
//CONFIG_ERROR(4007, "配置错误"),
//
///**
// * 即时通讯错误,对应ImException
// */
//IM_ERROR(4008, "即时通讯错误"),
//
///**
// * 短信发送错误,对应SmsException
// */
//SMS_ERROR(4009, "短信发送错误"),
//
///**
// * 参数错误,对应ParamException
// */
//PARAM_ERROR(4100, "参数错误"),
//
///**
// * 扫码登录错误码
// */
//LOGIN_ERROR(4011, "登录失败"),
//
///**
// * 代理商、员工登录名已存在
// */
//USER_NAME_EXISTS(4012, "登录名已存在"),
//
///**
// * 文件大小超出限制
// */
//EXCEED_MAX_FILE_SIZE(4013, "文件大小超出限制"),
//
///**
// * 转换中
// */
//FILE_CONVERT(2001, "转换中"),
//
///**
// * 转换失败
// */
//FILE_CONVERT_ERROR(2002, "转换失败"),
//
///**
// * 大数据调用异常
// */
//BIG_DATA_INVOKE_EXCEPTION(4014, "大数据调用异常"),
//
///**
// * 数据导入异常
// */
//DATA_IMPORT_EXCEPTION(4015,"数据导入异常");
///**
// * 不合法的请求
// */
//DATA_IMPORT_EXCEPTION(4020,"不合法的请求");


