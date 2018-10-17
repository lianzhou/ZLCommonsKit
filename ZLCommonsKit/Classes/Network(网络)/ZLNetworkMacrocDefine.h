//
//  ZLNetworkMacrocDefine.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#ifndef ZLNetworkMacrocDefine_h
#define ZLNetworkMacrocDefine_h

/*! @brief *
 *  网络请求
 */
typedef NS_ENUM(NSUInteger, ZLNetworkRequestType){
    ZLNetworkRequestTypeOrange,        // 橘子网络的请求
    ZLNetworkRequestTypeXKP,           // 新开普的请求
    ZLNetworkRequestTypeYouKu,         //优酷的请求
};

/*! @brief *
 *  网络请求类型
 */
typedef NS_ENUM (NSUInteger, ZLHttpRequestMethod) {
    ZLHttpRequestMethod_POST,
    ZLHttpRequestMethod_GET,
    ZLHttpRequestMethod_DELETE,
    ZLHttpRequestMethod_PUT,
};

/*! @brief *
 *  网络请求任务类型
 */
typedef NS_ENUM(NSUInteger, ZLNetworkTaskType){
    ZLNetworkTaskTypeJsonRequest,  //json请求
    ZLNetworkTaskTypeXmlRequest,   //xml请求
    ZLNetworkTaskTypeUploadFile,   //上传文件
    ZLNetworkTaskTypeDownloadFile, //下载文件
};
#import <AFNetworking/AFNetworking.h>

#endif /* ZLNetworkMacrocDefine_h */
