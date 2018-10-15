//
//  JZTableViewCellModel.h
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

typedef void(^didSelectRowAtIndexPathWithModel)(NSIndexPath *indexPath);

@interface JZTableViewCellModel : JZBaseObject
{
    __weak id _actionTarget;
    SEL _actionSel;
}
@property (nonatomic, copy) NSString                        *identifier;

@property (nonatomic, copy) NSString                        *cellClassName;

@property (nonatomic, assign)CGFloat                        rowHeight;

//跳转页面
@property (nonatomic, copy) NSString                        *viewControllerName;

//点击cell跳转页面所需参数
@property (nonatomic, strong)NSDictionary                   *propertyDic;

@property (nonatomic, strong) id<NSObject> cellNeedModel;

@property (nonatomic,copy) didSelectRowAtIndexPathWithModel didSelectRowAtIndexPath;

+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2;

- (void)normalCellForSel:(SEL)arg1 target:(id)arg2;
- (void)makeNormalCell:(id)arg1;

@end
