//
//  JZDatabaseMacrocDefine.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#ifndef JZDatabaseMacrocDefine_h
#define JZDatabaseMacrocDefine_h

/*! @brief *
 *  数据库操作类型
 */
typedef NS_ENUM(NSUInteger, JZDatabaseAction) {
    JZDatabaseActionSelect,
    JZDatabaseActionInsert,
    JZDatabaseActionUpdate,
    JZDatabaseActionDelete,
    JZDatabaseActionCreateTable,
};
/*! @brief *
 *  查询
 */
typedef NS_ENUM(NSUInteger, JZDatabaseWhereOperation) {
    JZDatabaseWhereOperationEqual,
    JZDatabaseWhereOperationBigger,
    JZDatabaseWhereOperationSmaller,
    JZDatabaseWhereOperationBiggerEqual,
    JZDatabaseWhereOperationSmallerEqual,
};
/*! @brief *
 *  SortOperation
 */
typedef NS_ENUM(NSUInteger, JZDatabaseSortOperation) {
    JZDatabaseSortOperationDESC,
    JZDatabaseSortOperationASC,
};
/*! @brief *
 *  字段类型
 */
typedef NS_ENUM(NSUInteger, JZDatabaseValueType) {
    JZDatabaseValueTypeText,
    JZDatabaseValueTypeVarchar,
    JZDatabaseValueTypeInt,
    JZDatabaseValueTypeBigInt,
};
#import <FMDB/FMDB.h>

#endif /* JZDatabaseMacrocDefine_h */
