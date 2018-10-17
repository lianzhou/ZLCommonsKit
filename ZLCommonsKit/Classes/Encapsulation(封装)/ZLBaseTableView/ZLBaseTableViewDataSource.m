//
//  ZLBaseTableViewDataSource.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLBaseTableViewDataSource.h"
#import "ZLStringMacrocDefine.h"

@interface ZLBaseTableViewDataSource()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZLBaseTableViewDataSource
+ (instancetype)datasourceForTableView:(UITableView *)tableView withItems:(NSArray *)items
{
    return [[self alloc] initWithTableView:tableView withItems:items];
}

- (instancetype)initWithTableView:(UITableView *)tableView withItems:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        NSAssert(tableView, @"空的tableView");
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _dataSource = items;
    }
    
    return self;
}
- (void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    [_tableView setTableHeaderView:headerView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:indexPath.section];
    ZLTableViewCellModel *model = [groupModel objectAtIndex:indexPath.row];
    
    if (model.didSelectRowAtIndexPath) {
        model.didSelectRowAtIndexPath(indexPath);
    }
    [model makeNormalCell:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:indexPath.section];
    ZLTableViewCellModel *model = [groupModel objectAtIndex:indexPath.row];
    return model.rowHeight <= 0?44:model.rowHeight;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:section];
    return [groupModel getCellCount];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:indexPath.section];
    ZLTableViewCellModel *model = [groupModel objectAtIndex:indexPath.row];
    
    if (ZLStringIsNull(model.cellClassName)) {
        NSAssert(NO, @"[cell <cellClassName> 为空]");
    }
    
    Class cellClass = NSClassFromString(model.cellClassName);
    ZLBaseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    if (!cell) {
        cell = [(ZLBaseTableViewCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.identifier];
    }        
    [cell settingModelData:model groupModel:groupModel indexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:section];
    if (groupModel.headerView) {
        return groupModel.headerView.bounds.size.height;
    }
    return 0.01;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZLSectionGroupModel *groupModel = [self.dataSource objectAtIndex:section];
    if (groupModel.headerView) {
        return groupModel.headerView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollViewWillBeginDragging) {
        self.scrollViewWillBeginDragging(scrollView);
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.scrollViewDidEndScrollingAnimation) {
        self.scrollViewDidEndScrollingAnimation(scrollView);
    }
}
@end
