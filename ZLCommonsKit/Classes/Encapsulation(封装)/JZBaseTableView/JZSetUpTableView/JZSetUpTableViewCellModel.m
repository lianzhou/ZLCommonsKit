//
//  JZSetUpTableViewCellModel.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "JZSetUpTableViewCellModel.h"

@interface JZSetUpTableViewCellModel ()

@end

@implementation JZSetUpTableViewCellModel
+ (id)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2 title:(id)arg3 accessoryType:(long long)arg4{
    JZSetUpTableViewCellModel * setUpTableViewCellModel = [[JZSetUpTableViewCellModel alloc]init];
    [setUpTableViewCellModel normalCellForSel:arg1 target:arg2];
    setUpTableViewCellModel.title = arg3;
    setUpTableViewCellModel.accessoryType = arg4;
    return setUpTableViewCellModel;
}

- (UIView *)accessoryViewWithType:(JZTableViewCellAccessoryType)accessoryType{

    if (accessoryType<5) {
        NSAssert(NO, @"[系统自带的,不用自定义<accessoryType>]");
    }
    switch (accessoryType) {
        case JZTableViewCellAccessoryDetailSwitch:
        {
            UISwitch * switchView =[[UISwitch alloc]init];
            [switchView addTarget:self action:@selector(switchViewOnClick:) forControlEvents:UIControlEventValueChanged];
            return switchView;
        }
            break;
            
        default:
            break;
    }
    return [[UIView alloc]init];

}
- (void)switchViewOnClick:(UISwitch *)sender{

}
@end
