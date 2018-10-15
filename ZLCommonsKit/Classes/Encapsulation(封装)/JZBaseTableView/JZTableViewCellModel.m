//
//  JZTableViewCellModel.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 李长恩 on 17/5/19.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "JZTableViewCellModel.h"
#import "JZSystemMacrocDefine.h"

@implementation JZTableViewCellModel

- (void)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2{
    _actionTarget = arg2;
    _actionSel = arg1;
}

- (void)makeNormalCell:(id)arg1{
    if (_actionTarget) {
        if ([_actionTarget respondsToSelector:_actionSel]) {
            JZPerformSelectorLeakWarning(
                [_actionTarget performSelector:_actionSel withObject:arg1 withObject:self];
            );            
        }
    }
}

+ (id)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2{
    JZTableViewCellModel * tableViewCellModel = [[JZTableViewCellModel alloc]init];
    [tableViewCellModel normalCellForSel:arg1 target:arg2];
    return tableViewCellModel;
}

#pragma mark - 懒加载

//- (CGFloat)rowHeight{
//    if (!_rowHeight) {
//        _rowHeight = 45.0f;
//    }
//    return _rowHeight;
//}


- (NSString *)identifier{
    if (!_identifier) {
        _identifier = @"tableViewCellModel";
    }
    return _identifier;
}
@end
