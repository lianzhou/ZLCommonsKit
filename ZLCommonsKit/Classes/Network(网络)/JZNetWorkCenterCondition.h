//
//  JZNetWorkCenterCondition.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/26.
//

#import <Foundation/Foundation.h>
#import "JZNetworkMacrocDefine.h"
#import "JZUploadFileModel.h"

@interface JZNetWorkCenterCondition : NSObject

/*! @brief *
 * 请求任务类型, 默认是 橘子网络的请求
 */
@property (nonatomic,assign) JZNetworkRequestType requestType;


/*! @brief *
 * 请求类型 默认是 json请求
 */
@property (nonatomic,assign) JZNetworkTaskType taskType;
/*! @brief *
 * 请求类型 默认是 POST请求
 */
@property (nonatomic,assign) JZHttpRequestMethod requestMethod;

/*! @brief *
 * 接口 和上面的 interfaceType 二选一
 */
@property (nonatomic,strong)NSString *interface;
/*! @brief *
 * 如果该host有值,就不室友BaseUrl
 */
@property (nonatomic,strong)NSString *host;

/*! @brief *
 * 参数
 */
@property (nonatomic,strong)NSDictionary *params;

/*! @brief *
 * 参数
 */
@property (nonatomic,strong)NSString *subKey;

/*! @brief *
 * request Header , 携带数据    Uid,AccessToken
 */
@property (strong, nonatomic) NSMutableDictionary *requestHeaders;


/*! @brief *
 * 超时 默认是30s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/*! @brief *
 * 是否是登录界面
 */
@property (nonatomic, assign) BOOL isLogin;


@property (nonatomic,strong) NSMutableArray <JZUploadFileModel *>*fileModels;

@property (nonatomic,copy) NSString *isNoUseAES;


/*! @brief *
 * 接口的type
 */
//@property (nonatomic,assign) JZOrangeInterfaceType interfaceType NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "这个字段暂时废弃");

@end
