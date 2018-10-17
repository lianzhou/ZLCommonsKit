//
//  ZLDatabaseCRUDCondition.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDatabaseCRUDCondition.h"
#import "ZLStringMacrocDefine.h"

@implementation ZLDatabaseCRUDCondition

- (NSString *)sqlString
{
    switch (self.action) {
        case ZLDatabaseActionCreateTable:
        {
            return [self buildCreateTableQuery];
        }
            break;
            
        case ZLDatabaseActionDelete:
        {
            return [self buildDeleteQuery];
        }
            break;
            
        case ZLDatabaseActionSelect:
        {
            return [self buildSelectQuery];
        }
            break;
            
        case ZLDatabaseActionUpdate:
        {
            return [self buildUpdateQuery];
        }
            break;
            
        case ZLDatabaseActionInsert:
        {
            return @"";
        }
            break;
        default:
            break;
    }
}

- (NSString *)buildCreateTableQuery
{
    if ([ZLStringUitil stringIsNull:self.tableName]) {
        NSLog(@"%@ 建表错误没有表名字",NSStringFromClass([ZLDatabaseCRUDCondition class]));
        return nil;
    }
    if (self.createColunmConditions.count == 0) {
        NSLog(@"%@ 建表错误没有属性字段",NSStringFromClass([ZLDatabaseCRUDCondition class]));
        return nil;
    }
    
    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"create table if not exists %@ (",self.tableName];
    
    for (NSInteger index = 0 ; index < self.createColunmConditions.count ; index ++) {
        
        ZLDatabaseColunmCondition *colunm = [self.createColunmConditions objectAtIndex:index];
        
        if (index != self.createColunmConditions.count - 1) {
            
            [sql appendFormat:@"%@,",colunm.sqlString];
            
        }else{
            
            [sql appendFormat:@"%@)",colunm.sqlString];
        }
    }
    
    NSLog(@"%@",sql);
    
    return sql;
}

- (NSString *)buildSelectQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    if (self.queryColoums.count == 0) {
        NSString * whereConditionSql = [self whereConditionSql];
        if (ZLStringIsNull(whereConditionSql)) {
            [sql appendFormat:@"select * from %@ ",self.tableName];
        }else{
            [sql appendFormat:@"select * from %@ where %@",self.tableName,[self whereConditionSql]];
        }
        
    }else{
        
        [sql appendFormat:@"select %@ from %@ where %@",[self.queryColoums componentsJoinedByString:@","],self.tableName,[self whereConditionSql]];
        
    }
    
    return sql;
}

- (NSString *)buildUpdateQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    return sql;
}

- (NSString *)buildDeleteQuery
{
    NSMutableString *sql = [NSMutableString string];
    
    NSString *conditionStr = [self whereConditionSql];
    if (ZLStringIsNull(conditionStr)) {
        [sql appendFormat:@"delete from %@",self.tableName];
    }else{
        [sql appendFormat:@"delete from %@ where %@",self.tableName,[self whereConditionSql]];
    }
    return sql;
}

- (NSString *)updateFormatSql
{
    if (self.updateValues.count == 0) {
        NSLog(@"试图更新表，缺没有任何更新值！");
        return @"";
    }
    
    NSDictionary *item = [self.updateValues firstObject];
    
    NSMutableString *sql = [NSMutableString string];
    
    switch (self.action) {
        case ZLDatabaseActionInsert:
        {
            [sql appendFormat:@"insert into %@ (%@) values %@",self.tableName,[self updateKeysToString:item.allKeys],[self argumentTupleOfSize:item.allKeys.count]];
        }
            break;
        case ZLDatabaseActionUpdate:
        {
            [sql appendFormat:@"update %@ set %@ where %@",self.tableName,[self argumentTupleOfSizeWithParams:item.allKeys],[self whereConditionSql]];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"formate sql :%@",sql);
    
    return sql;
}

- (NSString *)whereConditionSql
{
    NSMutableString *sql = [NSMutableString string];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZLDatabaseWhereCondition *condition = self.andConditions[index];
        
        if (index != self.andConditions.count -1) {
            
            [sql appendFormat:@"%@ and ",condition.sqlformat];
            
        }else{
            
            [sql appendFormat:@"%@",condition.sqlformat];
        }
        
    }
    
    return sql;
}

- (NSArray *)andConditionValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZLDatabaseWhereCondition *condition = self.andConditions[index];
        
        [values addObject:condition.value];
    }
    
    return values;
}

- (NSArray *)updateWhereValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        ZLDatabaseWhereCondition *condition = self.andConditions[index];
        
        [values addObject:condition.value];
    }
    
    return values;
}

- (NSArray *)updateFormateValues
{
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSDictionary *item in self.updateValues) {
        
        [valueArray addObject:item.allValues];
    }
    
    return valueArray;
}

- (NSString *)updateValuesToString:(NSArray *)array
{
    NSMutableString *sql = [NSMutableString string];
    
    for (NSInteger index = 0;index < array.count;index ++) {
        
        if (index != array.count-1) {
            
            [sql appendFormat:@"%@,",array[index]];
            
        }else{
            
            [sql appendFormat:@"'%@'",array[index]];
            
        }
    }
    
    return sql;
}

- (NSString *)updateKeysToString:(NSArray *)array
{
    return [array componentsJoinedByString:@","];
}

- (NSString *)argumentTupleOfSize:(NSUInteger)tupleSize
{
    NSMutableArray * tupleString = [[NSMutableArray alloc] init];
    [tupleString addObject:@"("];
    for (NSUInteger columnIdx = 0; columnIdx < tupleSize; columnIdx++)
    {
        if (columnIdx > 0)
        {
            [tupleString addObject:@","];
        }
        [tupleString addObject:@"?"];
    }
    [tupleString addObject:@")"];
    
    return [tupleString componentsJoinedByString:@" "];
}

- (NSString *)argumentTupleOfSizeWithParams:(NSArray *)params
{
    NSMutableArray * tupleString = [[NSMutableArray alloc] init];
    for (NSUInteger columnIdx = 0; columnIdx < params.count; columnIdx++)
    {
        if (columnIdx > 0)
        {
            [tupleString addObject:@","];
        }
        [tupleString addObject:[params objectAtIndex:columnIdx]];
        [tupleString addObject:@"="];
        [tupleString addObject:@"?"];
    }
    
    return [tupleString componentsJoinedByString:@" "];
}

- (BOOL)isValidate
{
    BOOL isValidate = YES;
    
    if ([ZLStringUitil stringIsNull:self.tableName]) {
        isValidate = NO;
        _conditionErrorMsg = @"没有表名";
        return isValidate;
    }
    
    switch (self.action) {
        case ZLDatabaseActionInsert:
        {
            if (self.updateValues.count == 0) {
                _conditionErrorMsg = @"插入一行记录但是没有任何值可以用";
                isValidate = NO;
            }
        }
            break;
        default:
            break;
    }
    
    return isValidate;
}

@end
