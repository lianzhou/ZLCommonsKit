//
//  JZDataAnalysisPublicAttributesModel.h
//  eStudy(comprehensive)
//
//  Created by Allen_Xu on 2017/12/22.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//


/*
 [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"PlatformType" : @"iOS"}];
 *重复调用 registerSuperProperties: 会覆盖之前已设置的公共属性，公共属性会保存在 App 本地缓存中。可以通过 unregisterSuperProperty: 删除一个公共属性，使用 clearSuperProperties: 会删除所有已设置的事件公共属性。
 
 当事件公共属性和事件属性的 Key 冲突时，事件属性优先级最高，它会覆盖事件公共属性。
 注意：请在开启自动能采集（ enableAutoTrack: ）之前调用 registerSuperProperties: 接口，确保每个事件都会添加已设置的公共属性
 */

#import "JZDataAnalysisBaseModel.h"

@interface JZDataAnalysisPublicAttributesModel : JZDataAnalysisBaseModel
//平台类型 app,web，server
@property (nonatomic, copy) NSString * platform;
//userID
@property (nonatomic, copy) NSString * eLearningID;
//用户类型  家长，教师，学生，家长且教师，家长（无孩子)
@property (nonatomic, copy) NSString * userType;

//学生班级名称
@property (nonatomic, copy) NSString * studentClass;
//学生年级
@property (nonatomic, copy) NSString * studentGrade;
//学生学校名称
@property (nonatomic, copy) NSString * studentSchool;
//登录端  web端老师账号，教学端老师账号，家庭端学生账号，家庭端家长账号
@property (nonatomic, copy) NSString * loginEnd;
//是否登录ID
@property (nonatomic, assign) BOOL isLoginID;

@end
