//
//  JZSectionGroupModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBaseObject.h"
#import "JZTableViewCellModel.h"



@interface JZSectionGroupModel : JZBaseObject


@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) id<NSObject> groupNeedModel;


- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;

- (id)lastObject;
- (id)firstObject;

- (void)addCell:(JZTableViewCellModel *)cell;

- (void)addCellModelList:(NSMutableArray <JZTableViewCellModel *>*)cellModelList;

- (NSUInteger)getCellCount;

- (void)removeCellModel:(JZTableViewCellModel *)cellModel;

- (void)removeCellModelAtIndex:(NSUInteger)index;

- (void)insertCellModelObject:(JZTableViewCellModel *)cellModel atIndex:(NSUInteger)index;

- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(JZTableViewCellModel * obj, NSUInteger idx, BOOL *stop))block;

- (void)removeAllCellModelObject;

@end
