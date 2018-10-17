//
//  BaseModel.h
//  BaseTableViewDemo
//
//  Created by zhangjiang on 2017/5/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  cell的显示类型
 */
typedef NS_ENUM(NSInteger, ZLTitleCollectionCellModelType) {
    /**
     *  默认类型
     */
    ZLTitleCollectionCellModelTypeDefault = 0,
    /**
     *  自定义
     */
    ZLTitleCollectionCustomCell = 1,
};


@interface ZLBaseTitleModel : NSObject
{
    id _actionTarget;
    SEL _actionSel;
}
/**
 *  重用标识符
 */
@property (nonatomic, copy) NSString *identifier;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  标题大小
 */
@property (nonatomic, strong)UIFont   *titleFont;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *detailTitle;
/**
 *  副标题大小
 */
@property (nonatomic, strong)UIFont   *detailFont;
/**
 *  cell的大小
 */
@property (nonatomic, assign)CGSize  modelSize;

@property (nonatomic, assign) ZLTitleCollectionCellModelType collectionCellModelType ;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (void)normalCellForSel:(SEL)arg1 target:(id)arg2;
- (void)makeNormalCell:(id)arg1;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3;

+ (Class)classForContentType:(ZLTitleCollectionCellModelType)contentType;
/**
 *  计算底部线的宽度
 */
-(CGRect)bottomlineWidth;

@end
