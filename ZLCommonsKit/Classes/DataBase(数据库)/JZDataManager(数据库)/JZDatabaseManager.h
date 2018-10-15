//
//  JZDatabaseManager.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZDatabaseOperation.h"

@interface JZDatabaseManager : NSObject

+ (JZDatabaseManager *)shareManager;

- (void)addOperation:(JZDatabaseOperation *)operation;


@end
