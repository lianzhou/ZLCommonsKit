//
//  JZDatabaseManager.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import <Foundation/Foundation.h>
#import "JZDatabaseOperation.h"

@interface JZDatabaseManager : NSObject

+ (JZDatabaseManager *)shareManager;

- (void)addOperation:(JZDatabaseOperation *)operation;


@end
