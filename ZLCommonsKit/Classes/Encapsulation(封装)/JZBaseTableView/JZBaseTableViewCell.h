//
//  JZBaseTableViewCell.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/19.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZTableViewCellModel.h"
#import "JZSectionGroupModel.h"

@interface JZBaseTableViewCell : UITableViewCell

// custom code

/* 虚方法 */
- (void)settingModelData:(JZTableViewCellModel *)contentModel  groupModel:(JZSectionGroupModel *)groupModel indexPath:(NSIndexPath *)indexPath;

@end
