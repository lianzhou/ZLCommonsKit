//
//  JZDropDownItemCell.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/11.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
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
