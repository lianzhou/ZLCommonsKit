//
//  JZNetworkMacrocDefine.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#ifndef JZNetworkMacrocDefine_h
#define JZNetworkMacrocDefine_h

/*! @brief *
 *  网络请求
 */
typedef NS_ENUM(NSUInteger, JZNetworkRequestType){
    JZNetworkRequestTypeOrange,        // 橘子网络的请求
    JZNetworkRequestTypeXKP,           // 新开普的请求
    JZNetworkRequestTypeYouKu,         //优酷的请求
};

/*! @brief *
 *  网络请求类型
 */
typedef NS_ENUM (NSUInteger, JZHttpRequestMethod) {
    JZHttpRequestMethod_POST,
    JZHttpRequestMethod_GET,
    JZHttpRequestMethod_DELETE,
    JZHttpRequestMethod_PUT,
};

/*! @brief *
 *  网络请求任务类型
 */
typedef NS_ENUM(NSUInteger, JZNetworkTaskType){
    JZNetworkTaskTypeJsonRequest,  //json请求
    JZNetworkTaskTypeXmlRequest,   //xml请求
    JZNetworkTaskTypeUploadFile,   //上传文件
    JZNetworkTaskTypeDownloadFile, //下载文件
};
#import <AFNetworking/AFNetworking.h>

#endif /* JZNetworkMacrocDefine_h */
