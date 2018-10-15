//
//  JZDropDownItemCell.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZDropDownItem.h"


@interface JZDropDownCell : UITableViewCell

- (void)cellDateWithItem:(JZDropDownItem *)item;

@end


@interface JZDropDownItemCell : JZDropDownCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIColor *cellCorlor;
@property(nonatomic,strong)UIFont *cellTitleFont;

@property(nonatomic,assign)BOOL isShowIcon;




@end
