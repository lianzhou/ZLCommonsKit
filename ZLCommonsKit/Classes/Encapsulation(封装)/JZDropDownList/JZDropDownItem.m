//
//  JZDropDownItem.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "JZDropDownItem.h"

@interface JZDropDownItem ()

@end

@implementation JZDropDownItem


+(instancetype)downItemWithTitle:(NSString *)title withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok
{
    JZDropDownItem *item = [[JZDropDownItem alloc]init];
    item.title = title;
    item.iconName = nil;
    item.isShowIcon = NO;
    item.dropSelectedBlcok = dropSelectedBlcok;
    return item;
}

+ (instancetype)downItemWithTitle:(NSString *)title
{
    JZDropDownItem *item = [[JZDropDownItem alloc]init];
    item.title = title;
    item.iconName = nil;
    item.isShowIcon = NO;
    return item;
}
+(instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok
{
    JZDropDownItem *item = [[JZDropDownItem alloc]init];
    item.title = title;
    item.iconName = iconName;
    item.dropSelectedBlcok = dropSelectedBlcok;
    item.isShowIcon = YES;
    return item;
}

+ (instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName
{
    JZDropDownItem *item = [[JZDropDownItem alloc]init];
    item.title = title;
    item.iconName = iconName;
    item.isShowIcon = YES;
    return item;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.info = [[JZDropDownCellConfig alloc] init];
        self.isHidenCell = YES;
    }
    return self;
}

@end

@implementation JZDropDownCellConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight = 45.0f;
        self.cellName = @"JZDropDownItemCell";
        self.cellIdentifier = @"JZDropDownItemCellIdentifier";
    }
    return self;
}

@end
