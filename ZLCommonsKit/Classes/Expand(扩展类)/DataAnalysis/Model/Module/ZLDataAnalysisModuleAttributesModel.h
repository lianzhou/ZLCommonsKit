//
//  ZLDataAnalysisModuleAttributesModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDataAnalysisBaseModel.h"
@class


    ZLDataAnalysisEventAppStart,
    ZLDataAnalysisEventAppQuit,
    ZLDataAnalysisEventAppInstall,
    ZLDataAnalysisEventAppViewScreen,
    ZLDataAnalysisEventButtonClick,
    ZLDataAnalysisEventAdClick,
    ZLDataAnalysisEventSearch,
    ZLDataAnalysisEventViewCourseDetail,
    ZLDataAnalysisEventAccountRechargeClick,
    ZLDataAnalysisEventGetAccountRecharge,
    ZLDataAnalysisEventPointRechargeClick,
    ZLDataAnalysisEventGetPointRecharge,
    ZLDataAnalysisEventEliveOpenClick,
    ZLDataAnalysisEventAirCourseOpenClick,
    ZLDataAnalysisEventShare,
    ZLDataAnalysisEventStartWatchCourseVideo,
    ZLDataAnalysisEventFinishWatchCourseVideo,
    ZLDataAnalysisEventAnnouncementRelease,
    ZLDataAnalysisEventNewsRelease,
    ZLDataAnalysisEventAssignWork,
    ZLDataAnalysisEventSubmitWork,
    ZLDataAnalysisEventImproveStart,
    ZLDataAnalysisEventImproveFinish,
    ZLDataAnalysisEventCourseFinish
;

//仅供引用子类名,实际埋点不使用该model,而是使用特定event对应的model
@interface ZLDataAnalysisModuleAttributesModel : ZLDataAnalysisBaseModel

@end

# pragma mark -01- App 启动
@interface ZLDataAnalysisEventAppStart : ZLDataAnalysisBaseModel

@end
# pragma mark -02- App 退出
@interface ZLDataAnalysisEventAppQuit : ZLDataAnalysisBaseModel

@end

# pragma mark -03- App 激活
@interface ZLDataAnalysisEventAppInstall : ZLDataAnalysisBaseModel

@end

# pragma mark -04- App浏览页面
@interface ZLDataAnalysisEventAppViewScreen : ZLDataAnalysisBaseModel
@property (nonatomic, copy) NSString * moduleName;//一级模块 作业，学情，空间，我的，消息，教学，成长轨迹，授课，资源
@property (nonatomic, copy) NSString * submoduleNmae;//二级模块 学情分析，课程学习，周边教育，作业详情，提分，布置作业，e直播，成长日志，成绩，食谱，报平安，学习日周月报，官方活动，动态，考勤，积分商城，一卡通，钱包，在线咨询，消息，教材设置，上传素材，智慧课堂
@end

# pragma mark -05- 按钮点击
@interface ZLDataAnalysisEventButtonClick : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * moduleName;//一级模块 作业，学情，空间，我的，消息，教学，成长轨迹，授课，资源
@property (nonatomic, copy) NSString * submoduleNmae;//二级模块 学情分析，课程学习，周边教育，作业详情，提分，布置作业，e直播，成长日志，成绩，食谱，报平安，学习日周月报，官方活动，动态，考勤，积分商城，一卡通，钱包，在线咨询，消息，教材设置，上传素材，智慧课堂
@property (nonatomic, copy) NSString * buttonType;//按钮类型
@property (nonatomic, copy) NSString * buttonName;//按钮名称

@end

# pragma mark -06- 广告点击
@interface ZLDataAnalysisEventAdClick : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * adTitle;//广告名称 - 取接口返回的参数
@property (nonatomic, copy) NSString * adID;//广告ID
@property (nonatomic, copy) NSString * adPage;//所在页面: 开屏广告，积分商城广告，辅导广告，e学云教育平台首页广告

@end

# pragma mark -07- 搜索
@interface ZLDataAnalysisEventSearch : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * keyword;//关键词
@property (nonatomic, assign) BOOL hasResult;//是否有结果
@property (nonatomic, assign) BOOL isHistoryWordUsed;//是否使用历史词
@property (nonatomic, assign) BOOL isRecommendWordUsed;//是否使用推荐词

@end

# pragma mark -08- 浏览内容详情页
@interface ZLDataAnalysisEventViewCourseDetail : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * contentType;//内容类型 动态，课程，e直播
@property (nonatomic, copy) NSString * contentID;//内容ID
@property (nonatomic, copy) NSString * contentTitle;//内容名称
@property (nonatomic, copy) NSString * contentFirstCate;//内容一级分类 e启学霸，学科辅导
@property (nonatomic, copy) NSString * contentSecondCate;//内容二级分类 e启学霸：课程分类、学习方法、学科提升、学习习惯、家庭教育、学霸历程/学科辅导：课内、课外
@property (nonatomic, copy) NSString * contentThirdCat;//内容三级分类 （学科辅导）年级、科目、知识点、艺术素养，生活常识，心理健康，思维训练

@end

# pragma mark -09- 点击账户充值
@interface ZLDataAnalysisEventAccountRechargeClick : ZLDataAnalysisBaseModel


@end

# pragma mark -10- 发起账户充值
@interface ZLDataAnalysisEventGetAccountRecharge : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * actualPayment;//内容类型 动态，课程，e直播
@property (nonatomic, copy) NSString * PaymentType;//内容ID

@end

# pragma mark -11- 点击积分充值
@interface ZLDataAnalysisEventPointRechargeClick : ZLDataAnalysisBaseModel

@end

# pragma mark -12- 发起积分充值
@interface ZLDataAnalysisEventGetPointRecharge : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * rechargeNum;//数值
@property (nonatomic, copy) NSString * actualPayment;//数值 如果是钱包，则为0
@property (nonatomic, copy) NSString * PaymentType;//支付方式 支付宝，微信，钱包

@end

# pragma mark -13- 点击开通e直播
@interface ZLDataAnalysisEventEliveOpenClick : ZLDataAnalysisBaseModel

@property (nonatomic, assign) NSInteger validDuration;//购买时长  月数 int

@end

# pragma mark -14- 点击开通空中课堂
@interface ZLDataAnalysisEventAirCourseOpenClick : ZLDataAnalysisBaseModel

@end

# pragma mark -15- 分享
@interface ZLDataAnalysisEventShare : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * contentType;//内容类型 广告，官方活动
@property (nonatomic, copy) NSString * contentID;//内容ID  广告id
@property (nonatomic, copy) NSString * contentTitle;//内容名称 官方活动名称
@property (nonatomic, copy) NSString * moduleName;//一级模块

@end

# pragma mark -16- 开始观看视频
@interface ZLDataAnalysisEventStartWatchCourseVideo : ZLDataAnalysisBaseModel

@end


# pragma mark -17- 结束观看视频
@interface ZLDataAnalysisEventFinishWatchCourseVideo : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * contentType;//内容类型 动态，课程，e直播，空中课堂
@property (nonatomic, copy) NSString * contentID;//内容ID
@property (nonatomic, copy) NSString * contentTitle;//内容名称
@property (nonatomic, copy) NSString * contentFirstCate;//内容一级分类 e启学霸，学科辅导
@property (nonatomic, copy) NSString * contentSecondCate;//内容二级分类 e启学霸：课程分类、学习方法、学科提升、学习习惯、家庭教育、学霸历程/学科辅导：课内、课外
@property (nonatomic, copy) NSString * contentThirdCate;//内容三级分类（学科辅导）年级、科目、知识点、艺术素养，生活常识，心理健康，思维训练
@property (nonatomic, copy) NSString * teacherID;// 老师ID
@property (nonatomic, copy) NSString * teacherName;//老师姓名
@property (nonatomic, copy) NSString * airSchoolID;//空中学校ID
@property (nonatomic, copy) NSString * airSchoolName;//空中学校名称
@property (nonatomic, assign) NSDate * startTime;//开课时间
@property (nonatomic, assign) NSDate * endTime;//预计结束时间

@end

# pragma mark -18- 发布通知
@interface ZLDataAnalysisEventAnnouncementRelease : ZLDataAnalysisBaseModel

@end

# pragma mark -19- 发布动态
@interface ZLDataAnalysisEventNewsRelease : ZLDataAnalysisBaseModel

@end

# pragma mark -20- 布置作业
@interface ZLDataAnalysisEventAssignWork : ZLDataAnalysisBaseModel
@property (nonatomic, copy) NSString * workID;//作业ID
@property (nonatomic, copy) NSString * workType;//作业类型  题库作业，课外作业
@property (nonatomic, strong) NSArray * workPattern;//作业形式  语音，文字，图片，单选题，多选题
@property (nonatomic, copy) NSString * bookEdition;//教材版本
@property (nonatomic, copy) NSString * disciplineName;//科目
@property (nonatomic, strong) NSArray * chapterLIst;//章节列表
@property (nonatomic, strong) NSArray * knlList;//知识点列表
@property (nonatomic, strong) NSArray * problemID;//题目ID
@property (nonatomic, assign) NSInteger exerciseNum;//题目数量
@property (nonatomic, assign) NSInteger PractisedNum_chapter;//章节练习题量
@property (nonatomic, assign) NSInteger PractisedNum_knl;//知识点练习题量
@property (nonatomic, assign) NSInteger assignNum;//布置人数

@end

# pragma mark -21- 提交作业
@interface ZLDataAnalysisEventSubmitWork : ZLDataAnalysisBaseModel
@property (nonatomic, copy) NSString * workID;//作业ID
@property (nonatomic, copy) NSString * workType;//作业类型  题库作业，课外作业
@property (nonatomic, strong) NSArray * workPattern;//作业形式  语音，文字，图片，单选题，多选题
@property (nonatomic, copy) NSString * bookEdition;//教材版本
@property (nonatomic, copy) NSString * disciplineName;//科目
@property (nonatomic, strong) NSArray * chapterLIst;//章节列表
@property (nonatomic, strong) NSArray * knlList;//知识点列表
@property (nonatomic, strong) NSArray * problemID;//题目ID
@property (nonatomic, assign) NSInteger exerciseNum;//题目数量
@property (nonatomic, assign) NSInteger PractisedNum_chapter;//章节练习题量
@property (nonatomic, assign) NSInteger PractisedNum_knl;//知识点练习题量

@end


# pragma mark -22- 开始提分
@interface ZLDataAnalysisEventImproveStart : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * bookEdition;//教材版本
@property (nonatomic, copy) NSString * gradeName;//年级
@property (nonatomic, copy) NSString * disciplineName;//科目
@property (nonatomic, strong) NSArray * chapterLIst;//章节列表
@property (nonatomic, strong) NSArray * knlList;//知识点列表

@end

# pragma mark -23- 完成提分
@interface ZLDataAnalysisEventImproveFinish : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * bookEdition;//教材版本
@property (nonatomic, copy) NSString * gradeName;//年级
@property (nonatomic, copy) NSString * disciplineName;//科目
@property (nonatomic, strong) NSArray * chapterLIst;//章节列表
@property (nonatomic, strong) NSArray * knlList;//知识点列表

@end

# pragma mark -24- 完成课程
@interface ZLDataAnalysisEventCourseFinish : ZLDataAnalysisBaseModel

@property (nonatomic, copy) NSString * contentType;//内容类型 动态，课程，e直播，空中课堂
@property (nonatomic, copy) NSString * contentID;//内容ID
@property (nonatomic, copy) NSString * contentTitle;//内容名称
@property (nonatomic, copy) NSString * contentFirstCate;//内容一级分类 e启学霸，学科辅导
@property (nonatomic, copy) NSString * contentSecondCate;//内容二级分类 e启学霸：课程分类、学习方法、学科提升、学习习惯、家庭教育、学霸历程/学科辅导：课内、课外
@property (nonatomic, copy) NSString * contentThirdCate;//内容三级分类（学科辅导）年级、科目、知识点、艺术素养，生活常识，心理健康，思维训练
@property (nonatomic, assign) CGFloat  finishTime;//完成时间
@property (nonatomic, copy) NSString * teacherID;// 老师ID
@property (nonatomic, copy) NSString * teacherName;//老师姓名
@property (nonatomic, copy) NSString * airSchoolID;//空中学校ID
@property (nonatomic, copy) NSString * airSchoolName;//空中学校名称



@end
