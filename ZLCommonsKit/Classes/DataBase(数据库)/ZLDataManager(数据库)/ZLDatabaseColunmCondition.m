//
//  ZLDatabaseColunmCondition.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDatabaseColunmCondition.h"
#import "ZLStringMacrocDefine.h"
@implementation ZLDatabaseColunmCondition


- (instancetype)init
{
    if (self = [super init]) {
        
        self.isPrimary = NO;
        self.isAutoIncrease = NO;
    }
    return self;
}

- (NSString *)sqlString
{
    NSMutableString *sql = [NSMutableString string];
    
    //属性
    [sql appendFormat:@"%@ ",self.colunmName];
    
    //类型
    switch (self.valueType) {
        case ZLDatabaseValueTypeText:
        {
            [sql appendString:@"text "];
        }
            break;
        case ZLDatabaseValueTypeVarchar:
        {
            [sql appendFormat:@"varchar(%ld) ",self.limitLength];
        }
            break;
        case ZLDatabaseValueTypeBigInt:
        {
            [sql appendString:@"bigint "];
        }
            break;
        case ZLDatabaseValueTypeInt:
        {
            [sql appendString:@"INTEGER "];
        }
            break;
        default:
            break;
    }
    
    //是否主键
    if (self.isPrimary) {
        [sql appendFormat:@"primary key "];
    }
    
    //是否自增  AUTO_INCREMENT
    if (self.isAutoIncrease) {
        [sql appendFormat:@"AUTOINCREMENT "];
    }
    
    //是否不可以为空
    if (self.isNotNull) {
        
        [sql appendString:@"not null "];
    }
    
    //默认值
    if (![ZLStringUitil stringIsNull:self.defaultValue]) {
        [sql appendFormat:@"default %@",self.defaultValue];
    }
    
    return sql;
}



@end
