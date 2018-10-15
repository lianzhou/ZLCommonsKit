//
//  JZDatabaseWhereCondition.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZDatabaseMacrocDefine.h"

@interface JZDatabaseWhereCondition : NSObject

@property (nonatomic,strong)NSString *columName;

@property (nonatomic,assign)JZDatabaseWhereOperation operation;

@property (nonatomic,strong)NSString *value;

@property (nonatomic,readonly)NSString *sqlformat;


@end
