//
//  JZDataAnalysisSetHandler.m
//  eStudy(comprehensive)
//
//  Created by Allen_Xu on 2017/12/22.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZDataAnalysisSetHandler.h"
#import "MJExtension.h"
 
@implementation JZDataAnalysisSetHandler

+ (void)registerPublicAttributes:(JZDataAnalysisPublicAttributesModel *)model{
    
//    JZDataAnalysisPublicAttributesModel * _publicModel = (JZDataAnalysisPublicAttributesModel *)model;
//
//    NSDictionary * _dic = [_publicModel mj_keyValues];
//
//    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:_dic];
 
}

+ (void)trackModuleEvent:(ModuleEvent )eventType WithAttributes:(JZDataAnalysisBaseModel *)model{
    
//    JZDataAnalysisBaseModel * _moduleAttributesModel = (JZDataAnalysisBaseModel *)model;
//    NSDictionary * _dic = [_moduleAttributesModel mj_keyValues];
//
//    [[SensorsAnalyticsSDK sharedInstance] track:JZ_ModuleEvents[eventType] withProperties:_dic];
}

+ (void)trackModuleEvent:(ModuleEvent )eventType{
    
//    [[SensorsAnalyticsSDK sharedInstance] track:JZ_ModuleEvents[eventType] ];
}

+ (void)trackModuleEventDurationBegin:(ModuleEvent )eventType{
    
//     [[SensorsAnalyticsSDK sharedInstance] trackTimerBegin:JZ_ModuleEvents[eventType]];
}

+ (void)trackModuleEventDurationEnd:(ModuleEvent)eventType{
    
//    [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:JZ_ModuleEvents[eventType] ];
}

+ (void)trackModuleEventDurationEnd:(ModuleEvent )eventType WithAttributes:(JZDataAnalysisBaseModel *)model{
    
//    JZDataAnalysisBaseModel * _moduleAttributesModel = (JZDataAnalysisBaseModel *)model;
//    NSDictionary * _dic = [_moduleAttributesModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:JZ_ModuleEvents[eventType] withProperties:_dic];
}

+ (void)setUserProfileWithAttributes:(JZDataAnalysisProfileAttributesModel *)model{
    
//    JZDataAnalysisProfileAttributesModel * _profileModel = (JZDataAnalysisProfileAttributesModel *)model;
//    NSDictionary * _dic = [_profileModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] set:_dic];
}


+ (void)setOnceUserProfilesWithAttributes:(JZDataAnalysisProfileAttributesModel *)model{
    
//    JZDataAnalysisProfileAttributesModel * _profileModel = (JZDataAnalysisProfileAttributesModel *)model;
//    NSDictionary * _dic = [_profileModel mj_keyValues];
//    [[SensorsAnalyticsSDK sharedInstance] setOnce:_dic];
}

+ (void)setUserProfileAttribute:(NSString *)modelAttribute toContent:(id)newContent{
    
//    [[SensorsAnalyticsSDK sharedInstance] set:modelAttribute to:newContent];
 
}



@end
