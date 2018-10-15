//
//  JZDatabaseWhereCondition.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZDatabaseWhereCondition.h"

@implementation JZDatabaseWhereCondition

- (NSString *)sqlformat
{
    NSMutableString *sql = [NSMutableString string];
    
    NSString *operate = [[self operationDict]objectForKey:@(self.operation)];
    
    [sql appendFormat:@"%@ %@ '%@'",self.columName,operate,self.value];
    
    return sql;
}

- (NSDictionary *)operationDict
{
    return @{
             @(JZDatabaseWhereOperationEqual) : @"=",
             
             @(JZDatabaseWhereOperationBigger) : @">",
             
             @(JZDatabaseWhereOperationSmaller) : @"<",
             
             @(JZDatabaseWhereOperationBiggerEqual) : @">=",
             
             @(JZDatabaseWhereOperationSmallerEqual) : @"<=",
             
             };
}


@end
