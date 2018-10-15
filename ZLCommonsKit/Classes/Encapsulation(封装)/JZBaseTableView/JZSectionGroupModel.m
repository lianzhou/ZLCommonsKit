//
//  JZSectionGroupModel.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZSectionGroupModel.h"
#import <libkern/OSAtomic.h>

@interface JZSectionGroupModel()
{
    NSMutableArray     *_groupModelList;
     OSSpinLock          _lock;
}

@end

@implementation JZSectionGroupModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _groupModelList = [@[] mutableCopy];
        _lock = OS_SPINLOCK_INIT;
    }
    return self;
}
- (id)objectAtIndex:(NSUInteger)index{
    
    if (index>_groupModelList.count) {
        return nil;
    }
    [self lock];
    id objcModel = [_groupModelList objectAtIndex:index];
    [self unlock];
    return objcModel;
}

- (NSUInteger)indexOfObject:(id)anObject{
    
    if (!anObject) {
        return 0;
    }
    [self lock];
    NSUInteger index = [_groupModelList indexOfObject:anObject];
    [self unlock];
    return index;
}
- (id)lastObject{
    [self lock];
    id objcModel = [_groupModelList lastObject];
    [self unlock];
    return objcModel;
}
- (id)firstObject{
    [self lock];
    id objcModel = [_groupModelList firstObject];
    [self unlock];

    return objcModel;
}
- (void)addCell:(JZTableViewCellModel *)cell{
    [self lock];
    [_groupModelList addObject:cell];
    [self unlock];
}

- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(JZTableViewCellModel * obj, NSUInteger idx, BOOL *stop))block{
    [self lock];
    [_groupModelList enumerateObjectsUsingBlock:block];
    [self unlock];

}
- (void)addCellModelList:(NSMutableArray <JZTableViewCellModel *>*)cellModelList {
    [self lock];
    [_groupModelList addObjectsFromArray:cellModelList];
    [self unlock];

}
- (NSUInteger)getCellCount{
    return _groupModelList.count;
}


- (void)removeCellModel:(JZTableViewCellModel *)cellModel
{
    [self lock];
    [_groupModelList removeObject:cellModel];
    [self unlock];
    
}

- (void)removeCellModelAtIndex:(NSUInteger)index
{
    [self lock];
    if (index <= _groupModelList.count) {
        [_groupModelList removeObjectAtIndex:index];
    }
    [self unlock];
}



- (void)insertCellModelObject:(JZTableViewCellModel *)cellModel atIndex:(NSUInteger)index
{
    [self lock];
    if (index<=_groupModelList.count) {
        [_groupModelList insertObject:cellModel atIndex:index];
    }
    [self unlock];
}
- (void)removeAllCellModelObject {
    
    [self lock];
    if (_groupModelList.count > 0) {
        [_groupModelList removeAllObjects];
    }
    [self unlock];
}
- (void)lock
{
    OSSpinLockLock(&_lock);
}

- (void)unlock
{
    OSSpinLockUnlock(&_lock);
}
@end
