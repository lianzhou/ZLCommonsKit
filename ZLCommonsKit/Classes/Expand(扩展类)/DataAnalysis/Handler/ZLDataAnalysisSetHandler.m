//
//  ZLDataAnalysisSetHandler.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDataAnalysisSetHandler.h"
#import "MJExtension.h"
 
@implementation ZLDataAnalysisSetHandler

+ (void)registerPublicAttributes:(ZLDataAnalysisPublicAttributesModel *)model{
    
//    ZLDataAnalysisPublicAttributesModel * _publicModel = (ZLDataAnalysisPublicAttributesModel *)model;
//
//    NSDictionary * _dic = [_publicModel mj_keyValues];
//
//    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:_dic];
 
}

+ (void)trackModuleEvent:(ModuleEvent )eventType WithAttributes:(ZLDataAnalysisBaseModel *)model{
    
//    ZLDataAnalysisBaseModel * _moduleAttributesModel = (ZLDataAnalysisBaseModel *)model;
//    NSDictionary * _dic = [_moduleAttributesModel mj_keyValues];
//
//    [[SensorsAnalyticsSDK sharedInstance] track:ZL_ModuleEvents[eventType] withProperties:_dic];
}

+ (void)trackModuleEvent:(ModuleEvent )eventType{
    
//    [[SensorsAnalyticsSDK sharedInstance] track:ZL_ModuleEvents[eventType] ];
}

+ (void)trackModuleEventDurationBegin:(ModuleEvent )eventType{
    
//     [[SensorsAnalyticsSDK sharedInstance] trackTimerBegin:ZL_ModuleEvents[eventType]];
}

+ (void)trackModuleEventDurationEnd:(ModuleEvent)eventType{
    
//    [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:ZL_ModuleEvents[eventType] ];
}

+ (void)trackModuleEventDurationEnd:(ModuleEvent )eventType WithAttributes:(ZLDataAnalysisBaseModel *)model{
    
//    ZLDataAnalysisBaseModel * _moduleAttributesModel = (ZLDataAnalysisBaseModel *)model;
//    NSDictionary * _dic = [_moduleAttributesModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:ZL_ModuleEvents[eventType] withProperties:_dic];
}

+ (void)setUserProfileWithAttributes:(ZLDataAnalysisProfileAttributesModel *)model{
    
//    ZLDataAnalysisProfileAttributesModel * _profileModel = (ZLDataAnalysisProfileAttributesModel *)model;
//    NSDictionary * _dic = [_profileModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] set:_dic];
}


+ (void)setOnceUserProfilesWithAttributes:(ZLDataAnalysisProfileAttributesModel *)model{
    
//    ZLDataAnalysisProfileAttributesModel * _profileModel = (ZLDataAnalysisProfileAttributesModel *)model;
//    NSDictionary * _dic = [_profileModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] setOnce:_dic];
}

+ (void)setUserProfileAttribute:(NSString *)modelAttribute toContent:(id)newContent{
    
//    [[SensorsAnalyticsSDK sharedInstance] set:modelAttribute to:newContent];
 
}



@end
