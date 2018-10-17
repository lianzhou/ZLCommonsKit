//
//  ZLNetworkTask.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import <Foundation/Foundation.h>
#import "ZLNetworkMacrocDefine.h"
#import "ZLUploadFileModel.h"

@class ZLNetworkTask;
typedef void (^ZLRequestSuccessBlock)(ZLNetworkTask  * task, id  dictData, NSInteger statusCode);
typedef void (^ZLRequestFailureBlock)(ZLNetworkTask  * task, NSError *error);
typedef void (^ZLRequestFailureProgressBlock) (ZLNetworkTask *task,NSProgress *progress);

typedef void (^ZLRequestFileDataFailureBlock)(ZLNetworkTask * task);

@interface ZLNetworkTask : NSObject

/*! @brief *
 *  任务唯一标示
 */
@property (nonatomic,readonly)NSString *taskIdentifier;

/*! @brief *
 *  接口
 */
@property (nonatomic,strong)NSString *interface; 

/*! @brief *
 *  主机地址
 */
@property (nonatomic,strong) NSString *host;
/*! @brief *
 *  参数
 */
@property (nonatomic,strong) NSDictionary *params;

/*! @brief *
 *  参数
 */
@property (nonatomic, copy) NSString *subKey;

/*! @brief *
 * request Header , 携带数据    Uid,AccessToken
 */
@property (strong, nonatomic) NSMutableDictionary *requestHeaders;

/*! @brief *
 * 超时,默认是30s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/*! @brief *
 * 请求任务类型, 默认是json
 */
@property (nonatomic,assign) ZLNetworkTaskType taskType;

/*! @brief *
 * 请求类型 默认是 POST的请求
 */
@property (nonatomic,assign) ZLHttpRequestMethod requestMethod;


/*! @brief *
 * sessionDataTask  
 */
@property (nonatomic,strong)  NSURLSessionDataTask  *task;

/*! @brief *
 * 成功的回调
 */
@property (nonatomic,copy) ZLRequestSuccessBlock successBlock;

/*! @brief *
 * 失败的回调
 */
@property (nonatomic,copy) ZLRequestFailureBlock failureBlock;

/*! @brief *
 *  进度回调
 */
@property (nonatomic,copy) ZLRequestFailureProgressBlock progressBlock;

@property (nonatomic,strong) NSMutableArray <ZLUploadFileModel *>*fileModels;

@property (nonatomic,copy) NSString *isNoUseAES;

- (ZLNetworkTask *)httpRequestMethod:(ZLHttpRequestMethod)method URL:(NSString *)interface params:(NSDictionary *)params success:(ZLRequestSuccessBlock)successBlock failure:(ZLRequestFailureBlock)failureBlock;

@end
