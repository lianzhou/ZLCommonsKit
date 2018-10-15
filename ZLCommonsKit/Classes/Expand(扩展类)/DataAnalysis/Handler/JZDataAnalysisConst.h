//
//  JZDataAnalysisConst.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

// Massive custom event keys
// 事件合计21种
extern  NSString *  JZ_ModuleEvents[];
typedef NS_ENUM(NSInteger, ModuleEvent) {
    ModuleEvent_JZ_AppStart = 0,//app启动
    ModuleEvent_JZ_AppQuit,//app退出
    ModuleEvent_JZ_AppInstall,//app安装
    ModuleEvent_JZ_AppViewScreen,//浏览页面
  
    ModuleEvent_JZ_ButtonClick,//按钮点击
    ModuleEvent_JZ_AdClick,//广告点击
    ModuleEvent_JZ_Search,//搜索
    ModuleEvent_JZ_ViewCourseDetail,//浏览内容详情页
    
    ModuleEvent_JZ_AccountRechargeClick,//点击账户充值
    ModuleEvent_JZ_GetAccountRecharge,//发起账户充值
 
    ModuleEvent_JZ_PointRechargeClick,//点击积分充值
    ModuleEvent_JZ_GetPointRecharge,//发起积分充值
 
    ModuleEvent_JZ_EliveOpenClick,//点击开通e直播

    ModuleEvent_JZ_AirCourseOpenClick,//点击开通空中课堂

    ModuleEvent_JZ_Share,//分享

    ModuleEvent_JZ_StartWatchCourseVideo,//开始观看视频
    ModuleEvent_JZ_FinishWatchCourseVideo,//结束观看视频
  
    ModuleEvent_JZ_AnnouncementRelease,//发布通知
    ModuleEvent_JZ_NewsRelease,//发布动态
    ModuleEvent_JZ_AssignWork,//布置作业
    ModuleEvent_JZ_SubmitWork,//提交作业

    ModuleEvent_JZ_ImproveStart,//开始提分
    ModuleEvent_JZ_ImproveFinish,//完成提分
    
    ModuleEvent_JZ_CourseFinish,//完成课程
  
};
 
@interface JZDataAnalysisConst : NSObject

@end
