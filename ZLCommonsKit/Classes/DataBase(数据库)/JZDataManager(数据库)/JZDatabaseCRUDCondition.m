//
//  JZDatabaseCRUDCondition.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import "JZDatabaseCRUDCondition.h"
#import "JZStringMacrocDefine.h"

@implementation JZDatabaseCRUDCondition

- (NSString *)sqlString
{
    switch (self.action) {
        case JZDatabaseActionCreateTable:
        {
            return [self buildCreateTableQuery];
        }
            break;
            
        case JZDatabaseActionDelete:
        {
            return [self buildDeleteQuery];
        }
            break;
            
        case JZDatabaseActionSelect:
        {
            return [self buildSelectQuery];
        }
            break;
            
        case JZDatabaseActionUpdate:
        {
            return [self buildUpdateQuery];
        }
            break;
            
        case JZDatabaseActionInsert:
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
    if ([JZStringUitil stringIsNull:self.tableName]) {
        NSLog(@"%@ 建表错误没有表名字",NSStringFromClass([JZDatabaseCRUDCondition class]));
        return nil;
    }
    if (self.createColunmConditions.count == 0) {
        NSLog(@"%@ 建表错误没有属性字段",NSStringFromClass([JZDatabaseCRUDCondition class]));
        return nil;
    }
    
    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"create table if not exists %@ (",self.tableName];
    
    for (NSInteger index = 0 ; index < self.createColunmConditions.count ; index ++) {
        
        JZDatabaseColunmCondition *colunm = [self.createColunmConditions objectAtIndex:index];
        
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
        if (JZStringIsNull(whereConditionSql)) {
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
    if (JZStringIsNull(conditionStr)) {
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
        case JZDatabaseActionInsert:
        {
            [sql appendFormat:@"insert into %@ (%@) values %@",self.tableName,[self updateKeysToString:item.allKeys],[self argumentTupleOfSize:item.allKeys.count]];
        }
            break;
        case JZDatabaseActionUpdate:
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
        
        JZDatabaseWhereCondition *condition = self.andConditions[index];
        
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
        
        JZDatabaseWhereCondition *condition = self.andConditions[index];
        
        [values addObject:condition.value];
    }
    
    return values;
}

- (NSArray *)updateWhereValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.andConditions.count; index ++) {
        
        JZDatabaseWhereCondition *condition = self.andConditions[index];
        
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
    
    if ([JZStringUitil stringIsNull:self.tableName]) {
        isValidate = NO;
        _conditionErrorMsg = @"没有表名";
        return isValidate;
    }
    
    switch (self.action) {
        case JZDatabaseActionInsert:
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
