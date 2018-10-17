//
//  ZLBaseTableViewCell.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLTableViewCellModel.h"
#import "ZLSectionGroupModel.h"

@interface ZLBaseTableViewCell : UITableViewCell

// custom code

/* 虚方法 */
- (void)settingModelData:(ZLTableViewCellModel *)contentModel  groupModel:(ZLSectionGroupModel *)groupModel indexPath:(NSIndexPath *)indexPath;

@end
