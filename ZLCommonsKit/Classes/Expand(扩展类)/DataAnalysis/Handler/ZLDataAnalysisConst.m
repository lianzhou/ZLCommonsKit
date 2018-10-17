//
//  ZLDataAnalysisConst.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDataAnalysisConst.h"


NSString * ZL_ModuleEvents [] = {
    [ModuleEvent_ZL_AppStart]                         = @"$AppStart",
    [ModuleEvent_ZL_AppQuit]                          = @"$AppEnd",
    [ModuleEvent_ZL_AppInstall]                       = @"AppInstall",
    
    [ModuleEvent_ZL_AppViewScreen]                    = @"$AppViewScreen",
    
    [ModuleEvent_ZL_ButtonClick]                      = @"buttonClick",
    [ModuleEvent_ZL_AdClick]                          = @"adClick",
    [ModuleEvent_ZL_Search]                           = @"search",
    [ModuleEvent_ZL_ViewCourseDetail]                 = @"viewCourseDetail",
    
    [ModuleEvent_ZL_AccountRechargeClick]             = @"accountRechargeClick",
    [ModuleEvent_ZL_GetAccountRecharge]               = @"getAccountRecharge",
    
    [ModuleEvent_ZL_PointRechargeClick]               = @"pointRechargeClick",
    [ModuleEvent_ZL_GetPointRecharge]                 = @"getPointRecharge",
    
    [ModuleEvent_ZL_EliveOpenClick]                   = @"eliveOpenClick",
    
    [ModuleEvent_ZL_AirCourseOpenClick]               = @"airCourseOpenClick",
    
    [ModuleEvent_ZL_Share]                            = @"share",
    
    [ModuleEvent_ZL_StartWatchCourseVideo]            = @"startWatchCourseVideo",
    [ModuleEvent_ZL_FinishWatchCourseVideo]           = @"finishWatchCourseVideo",
   
    [ModuleEvent_ZL_AnnouncementRelease]              = @"announcementRelease",
    [ModuleEvent_ZL_NewsRelease]                      = @"newsRelease",
    [ModuleEvent_ZL_AssignWork]                       = @"assignWork",
    [ModuleEvent_ZL_SubmitWork]                       = @"submitWork",

    [ModuleEvent_ZL_ImproveStart]                     = @"improveStart",
    [ModuleEvent_ZL_ImproveFinish]                    = @"improveFinish",
    
    [ModuleEvent_ZL_CourseFinish]                     = @"courseFinish",
    
};

@implementation ZLDataAnalysisConst

@end
