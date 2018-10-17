//
//  ZLBaseTableViewDataSource.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLSectionGroupModel.h"
#import "ZLBaseTableViewCell.h"

@interface ZLBaseTableViewDataSource : NSObject

@property (nonatomic, strong) NSArray *dataSource;

+ (instancetype)datasourceForTableView:(UITableView *)tableView withItems:(NSArray *)items;

@property (nonatomic, strong) UIView * headerView;

@property (nonatomic, copy) void (^scrollViewDidScroll)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^scrollViewWillBeginDragging)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^scrollViewDidEndScrollingAnimation)(UIScrollView *scrollView);



@end
