//
//  ZLSafeMutableArray.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>

@interface ZLSafeMutableArray : NSObject
{
@protected
    //    pthread_mutex_t     _mutex;
    NSMutableArray      *_safeArray;
    OSSpinLock          _lock;
}

@property (nonatomic, strong) NSMutableArray *safeArray;

- (id)objectAtIndex:(NSUInteger)index;

- (BOOL)containsObject:(id)anObject;

- (NSUInteger)indexOfObject:(id)obj;

- (void)addObject:(id)anObject;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;;
- (void)removeObjectAtIndex:(NSUInteger)index;;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)insertObjectsFromArray:(NSArray *)otherArray atIndex:(NSInteger)index;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObject:(id)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray;
- (void)setArray:(NSArray *)otherArray;
- (void)subArrayWithRange:(NSRange)range;

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (NSInteger)count;

@end

// 增加去重操作
@interface ZLSafeSetArray : ZLSafeMutableArray

@end
