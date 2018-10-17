//
//  ZLDatabaseOperation.h
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

#import "ZLDatabaseCRUDCondition.h"

typedef void (^ZLDatabaseOperationQuerySuccessBlock) (FMResultSet *resultSet);

typedef void (^ZLDatabaseOperationUpdateSuccessBlock) (void);

typedef void (^ZLDatabaseOperationFaildBlock) (NSError *error);


@interface ZLDatabaseOperation : NSObject

@property (nonatomic,readonly)NSString *dbPath;

@property (nonatomic,strong)ZLDatabaseCRUDCondition *actionCondition;

@property (nonatomic,copy)ZLDatabaseOperationQuerySuccessBlock QuerySuccess;

@property (nonatomic,copy)ZLDatabaseOperationUpdateSuccessBlock updateSuccess;

@property (nonatomic,copy)ZLDatabaseOperationFaildBlock faild;


@end
