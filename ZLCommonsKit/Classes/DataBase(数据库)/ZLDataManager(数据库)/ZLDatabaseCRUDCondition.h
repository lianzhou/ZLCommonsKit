//
//  ZLDatabaseCRUDCondition.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLDatabaseColunmCondition.h"
#import "ZLDatabaseWhereCondition.h"

@interface ZLDatabaseCRUDCondition : NSObject

@property (nonatomic,assign)ZLDatabaseAction action;
/* 表名 */
@property (nonatomic,strong)NSString *tableName;
//建表的属性字段
@property (nonatomic,strong)NSArray *createColunmConditions;

//需要创建或者更新的字段,@[@{},@{}]
@property (nonatomic,strong)NSArray *updateValues;

//属性字符串数组
@property (nonatomic,strong)NSArray *queryColoums;

//ZLDatabaseWhereCondition对象数组
@property (nonatomic,strong)NSArray *andConditions;


#pragma mark - 下面的是只读的,不可赋值

//更新的formate语句
@property (nonatomic,readonly)NSString *updateFormatSql;

//更新的值数组
@property (nonatomic,readonly)NSArray *updateFormateValues;

//条件查询时候的值，用来跟formate形式匹配
@property (nonatomic,readonly)NSArray *andConditionValues;

//更新的时候用的条件参数
@property (nonatomic,readonly)NSArray *updateWhereValues;

@property (nonatomic,readonly)NSString *sqlString;

@property (nonatomic,readonly)BOOL isValidate;

@property (nonatomic,readonly)NSString *conditionErrorMsg;

@end
