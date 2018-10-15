//
//  JZDataAnalysisSetHandler.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZDataAnalysisConst.h"
#import "JZDataAnalysisBaseModel.h"
#import "JZDataAnalysisPublicAttributesModel.h"
#import "JZDataAnalysisModuleAttributesModel.h"
#import "JZDataAnalysisProfileAttributesModel.h"

@class JZDataAnalysisBaseModel ;
@interface JZDataAnalysisSetHandler : NSObject

# pragma mark - event

/**
 注册公共属性的值,可覆盖,优先级高于普通属性.在开启自动能采集（ enableAutoTrack: ）之前调用 registerSuperProperties: 接口，确保每个事件都会添加已设置的公共属性。

 @param model <#model description#>
 */
+ (void)registerPublicAttributes: (JZDataAnalysisPublicAttributesModel *)model;


/**
 在特点event处埋点(含自定义参数)

 @param eventType 埋点事件
 @param model 该埋点事件对应的model,在传入model之前对其赋值
 */
+ (void)trackModuleEvent:(ModuleEvent )eventType WithAttributes:(JZDataAnalysisBaseModel *)model;

/**
 在特点event处埋点(不含自定义参数)

 @param eventType 埋点事件
 */
+ (void)trackModuleEvent:(ModuleEvent )eventType;

# pragma mark - event duration

/**
 跟踪事件的周期,通过计时器统计事件的持续时间。首先，在事件开始时调用(1.7.4 及以后版本支持） trackModuleEventDurationBegin:  记录事件开始时间，该方法并不会真正发送事件；在事件结束时，调用 trackModuleEventDurationEnd: WithAttributes: ，SDK 会追踪 "Event" 事件，并自动将事件持续时间记录在事件属性 "event_duration" 中,两个方法需要合用.
 
 注意event的名称必须一致

 @param eventType 埋点事件
 */
+ (void)trackModuleEventDurationBegin:(ModuleEvent )eventType;
+ (void)trackModuleEventDurationEnd:(ModuleEvent)eventType;
+ (void)trackModuleEventDurationEnd:(ModuleEvent )eventType WithAttributes:(JZDataAnalysisBaseModel *)model;


# pragma mark - profile
/**
 设置用户profile(无则创建,有则覆盖),该方法可以粗放地去修改用户的某个属性.
 profile相当于一个属性,profiles指用户属性集合
 @param model JZDataAnalysisProfileAttributesModel
 */
+ (void)setUserProfileWithAttributes:(JZDataAnalysisProfileAttributesModel *)model;

/**
 设置用户profiles(有则return,无则创建)
 profile相当于一个属性,profiles指用户属性集合
 @param model JZDataAnalysisProfileAttributesModel
 */
+ (void)setOnceUserProfilesWithAttributes:(JZDataAnalysisProfileAttributesModel *)model;

/**
 根据用户profile的名称精准地去修改其值

 @param modelAttribute 被修改的参数名profile, 直接复制JZDataAnalysisProfileAttributesModel 的property名称即可
 @param newContent 该参数的新值
 */
+ (void)setUserProfileAttribute:(NSString *)modelAttribute toContent:(id)newContent;



 
@end
