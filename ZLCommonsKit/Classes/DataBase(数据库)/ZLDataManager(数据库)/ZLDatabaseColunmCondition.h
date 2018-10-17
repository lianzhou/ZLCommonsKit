//
//  ZLDatabaseColunmCondition.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLDatabaseMacrocDefine.h"

@interface ZLDatabaseColunmCondition : NSObject


/*! @brief *
 * 主键
 */
@property (nonatomic,assign)BOOL isPrimary;

/*! @brief *
 * 自增长的ID
 */
@property (nonatomic,assign)BOOL isAutoIncrease;

/*! @brief *
 * 类型
 */
@property (nonatomic,assign)ZLDatabaseValueType valueType;


/*! @brief *
 * 长度
 */
@property (nonatomic,assign)NSInteger limitLength;

/*! @brief *
 * 属性
 */
@property (nonatomic,strong)NSString *colunmName;

/*! @brief *
 * 默认值
 */
@property (nonatomic,strong)NSString *defaultValue;

/*! @brief *
 * 是否不可以为空
 */
@property (nonatomic,assign)BOOL isNotNull;

/*! @brief *
 * sql
 */
@property (nonatomic,readonly)NSString *sqlString;


@end
