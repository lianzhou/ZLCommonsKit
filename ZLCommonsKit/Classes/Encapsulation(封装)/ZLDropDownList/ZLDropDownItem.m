//
//  ZLDropDownItem.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "ZLDropDownItem.h"

@interface ZLDropDownItem ()

@end

@implementation ZLDropDownItem


+(instancetype)downItemWithTitle:(NSString *)title withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok
{
    ZLDropDownItem *item = [[ZLDropDownItem alloc]init];
    item.title = title;
    item.iconName = nil;
    item.isShowIcon = NO;
    item.dropSelectedBlcok = dropSelectedBlcok;
    return item;
}

+ (instancetype)downItemWithTitle:(NSString *)title
{
    ZLDropDownItem *item = [[ZLDropDownItem alloc]init];
    item.title = title;
    item.iconName = nil;
    item.isShowIcon = NO;
    return item;
}
+(instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok
{
    ZLDropDownItem *item = [[ZLDropDownItem alloc]init];
    item.title = title;
    item.iconName = iconName;
    item.dropSelectedBlcok = dropSelectedBlcok;
    item.isShowIcon = YES;
    return item;
}

+ (instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName
{
    ZLDropDownItem *item = [[ZLDropDownItem alloc]init];
    item.title = title;
    item.iconName = iconName;
    item.isShowIcon = YES;
    return item;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.info = [[ZLDropDownCellConfig alloc] init];
        self.isHidenCell = YES;
    }
    return self;
}

@end

@implementation ZLDropDownCellConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight = 45.0f;
        self.cellName = @"ZLDropDownItemCell";
        self.cellIdentifier = @"ZLDropDownItemCellIdentifier";
    }
    return self;
}

@end
