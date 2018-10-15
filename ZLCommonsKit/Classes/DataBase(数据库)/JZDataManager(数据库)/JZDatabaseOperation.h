//
//  JZDatabaseOperation.h
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

#import "JZDatabaseCRUDCondition.h"

typedef void (^JZDatabaseOperationQuerySuccessBlock) (FMResultSet *resultSet);

typedef void (^JZDatabaseOperationUpdateSuccessBlock) (void);

typedef void (^JZDatabaseOperationFaildBlock) (NSError *error);


@interface JZDatabaseOperation : NSObject

@property (nonatomic,readonly)NSString *dbPath;

@property (nonatomic,strong)JZDatabaseCRUDCondition *actionCondition;

@property (nonatomic,copy)JZDatabaseOperationQuerySuccessBlock QuerySuccess;

@property (nonatomic,copy)JZDatabaseOperationUpdateSuccessBlock updateSuccess;

@property (nonatomic,copy)JZDatabaseOperationFaildBlock faild;


@end
