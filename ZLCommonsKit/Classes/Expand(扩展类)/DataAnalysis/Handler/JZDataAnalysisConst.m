//
//  JZDataAnalysisConst.m
//  eStudy(comprehensive)
//
//  Created by Allen_Xu on 2017/12/22.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZDataAnalysisConst.h"


NSString * JZ_ModuleEvents [] = {
    [ModuleEvent_JZ_AppStart]                         = @"$AppStart",
    [ModuleEvent_JZ_AppQuit]                          = @"$AppEnd",
    [ModuleEvent_JZ_AppInstall]                       = @"AppInstall",
    
    [ModuleEvent_JZ_AppViewScreen]                    = @"$AppViewScreen",
    
    [ModuleEvent_JZ_ButtonClick]                      = @"buttonClick",
    [ModuleEvent_JZ_AdClick]                          = @"adClick",
    [ModuleEvent_JZ_Search]                           = @"search",
    [ModuleEvent_JZ_ViewCourseDetail]                 = @"viewCourseDetail",
    
    [ModuleEvent_JZ_AccountRechargeClick]             = @"accountRechargeClick",
    [ModuleEvent_JZ_GetAccountRecharge]               = @"getAccountRecharge",
    
    [ModuleEvent_JZ_PointRechargeClick]               = @"pointRechargeClick",
    [ModuleEvent_JZ_GetPointRecharge]                 = @"getPointRecharge",
    
    [ModuleEvent_JZ_EliveOpenClick]                   = @"eliveOpenClick",
    
    [ModuleEvent_JZ_AirCourseOpenClick]               = @"airCourseOpenClick",
    
    [ModuleEvent_JZ_Share]                            = @"share",
    
    [ModuleEvent_JZ_StartWatchCourseVideo]            = @"startWatchCourseVideo",
    [ModuleEvent_JZ_FinishWatchCourseVideo]           = @"finishWatchCourseVideo",
   
    [ModuleEvent_JZ_AnnouncementRelease]              = @"announcementRelease",
    [ModuleEvent_JZ_NewsRelease]                      = @"newsRelease",
    [ModuleEvent_JZ_AssignWork]                       = @"assignWork",
    [ModuleEvent_JZ_SubmitWork]                       = @"submitWork",

    [ModuleEvent_JZ_ImproveStart]                     = @"improveStart",
    [ModuleEvent_JZ_ImproveFinish]                    = @"improveFinish",
    
    [ModuleEvent_JZ_CourseFinish]                     = @"courseFinish",
    
};

@implementation JZDataAnalysisConst

@end
