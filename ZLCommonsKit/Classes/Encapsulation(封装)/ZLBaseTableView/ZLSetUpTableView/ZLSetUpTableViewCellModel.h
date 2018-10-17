//
//  ZLSetUpTableViewCellModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLTableViewCellModel.h"

typedef NS_ENUM(NSInteger, ZLTableViewCellAccessoryType) {
    ZLTableViewCellAccessoryNone = UITableViewCellAccessoryNone,
    ZLTableViewCellAccessoryDisclosureIndicator = UITableViewCellAccessoryDisclosureIndicator,
    ZLTableViewCellAccessoryDetailDisclosureButton=UITableViewCellAccessoryDetailDisclosureButton ,
    ZLTableViewCellAccessoryCheckmark=UITableViewCellAccessoryCheckmark,
    ZLTableViewCellAccessoryDetailButton=UITableViewCellAccessoryDetailButton,
    ZLTableViewCellAccessoryDetailSwitch,
};

@interface ZLSetUpTableViewCellModel : ZLTableViewCellModel
/**
 *  图片
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *detailTitle;



/*
 * 右边控件的type
 */
@property (nonatomic) ZLTableViewCellAccessoryType    accessoryType;

+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;

- (UIView *)accessoryViewWithType:(ZLTableViewCellAccessoryType)accessoryType;
@end
