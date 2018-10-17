//
//  ZLDatabaseMacrocDefine.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#ifndef ZLDatabaseMacrocDefine_h
#define ZLDatabaseMacrocDefine_h

/*! @brief *
 *  数据库操作类型
 */
typedef NS_ENUM(NSUInteger, ZLDatabaseAction) {
    ZLDatabaseActionSelect,
    ZLDatabaseActionInsert,
    ZLDatabaseActionUpdate,
    ZLDatabaseActionDelete,
    ZLDatabaseActionCreateTable,
};
/*! @brief *
 *  查询
 */
typedef NS_ENUM(NSUInteger, ZLDatabaseWhereOperation) {
    ZLDatabaseWhereOperationEqual,
    ZLDatabaseWhereOperationBigger,
    ZLDatabaseWhereOperationSmaller,
    ZLDatabaseWhereOperationBiggerEqual,
    ZLDatabaseWhereOperationSmallerEqual,
};
/*! @brief *
 *  SortOperation
 */
typedef NS_ENUM(NSUInteger, ZLDatabaseSortOperation) {
    ZLDatabaseSortOperationDESC,
    ZLDatabaseSortOperationASC,
};
/*! @brief *
 *  字段类型
 */
typedef NS_ENUM(NSUInteger, ZLDatabaseValueType) {
    ZLDatabaseValueTypeText,
    ZLDatabaseValueTypeVarchar,
    ZLDatabaseValueTypeInt,
    ZLDatabaseValueTypeBigInt,
};
#import <FMDB/FMDB.h>

#endif /* ZLDatabaseMacrocDefine_h */
