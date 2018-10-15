//
//  JZDataAnalysisProfileAttributesModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZDataAnalysisBaseModel.h"

@interface JZDataAnalysisProfileAttributesModel : JZDataAnalysisBaseModel

@property (nonatomic, copy) NSString * name;//姓名
@property (nonatomic, copy) NSString * eLearningID;//e学云ID
@property (nonatomic, copy) NSString * gender;//性别 男 or 女
@property (nonatomic, copy) NSString * yearofBirth;//出生年份
@property (nonatomic, copy) NSString * province;//省份
@property (nonatomic, copy) NSString * city;//城市
@property (nonatomic, copy) NSString * area;//区域
@property (nonatomic, copy) NSString * Email;//邮箱
@property (nonatomic, copy) NSString * phone;//手机
@property (nonatomic, copy) NSString * userType;//用户类型 '家长，学生，家长且教师，教师，家长（没有孩子）
@property (nonatomic, assign) BOOL hasUsedPoint;//是否使用积分
@property (nonatomic, assign) BOOL isdiscounted;//是否使用卡券
@property (nonatomic, assign) BOOL hasPaid;//是否付费
@property (nonatomic, assign) NSDate * registrateTime;//注册时间
@property (nonatomic, copy) NSString * registrateChannel;//注册渠道
@property (nonatomic, copy) NSDate * firstConsumeTime;//首次消费时间
@property (nonatomic, copy) NSString * schoolName;//学校名称
@property (nonatomic, copy) NSString * schoolType;//学校类型
@property (nonatomic, copy) NSString * gradeName;//年级
@property (nonatomic, copy) NSString * className;//班级名称
@property (nonatomic, copy) NSString * lastLoginTime;//上次登录时间
@property (nonatomic, copy) NSString * cumulativeLoginTime;//累计登陆天数
@property (nonatomic, strong) NSArray * connectedID;//亲子e学云账号
@property (nonatomic, assign) NSInteger connectedNum;//亲子数量
@property (nonatomic, copy) NSString * appVersion;//APP版本

@end
