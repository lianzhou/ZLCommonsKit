//
//  ZLTableViewCellModel.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLTableViewCellModel.h"
#import "ZLSystemMacrocDefine.h"

@implementation ZLTableViewCellModel

- (void)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2{
    _actionTarget = arg2;
    _actionSel = arg1;
}

- (void)makeNormalCell:(id)arg1{
    if (_actionTarget) {
        if ([_actionTarget respondsToSelector:_actionSel]) {
            ZLPerformSelectorLeakWarning(
                [_actionTarget performSelector:_actionSel withObject:arg1 withObject:self];
            );            
        }
    }
}

+ (id)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2{
    ZLTableViewCellModel * tableViewCellModel = [[ZLTableViewCellModel alloc]init];
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
