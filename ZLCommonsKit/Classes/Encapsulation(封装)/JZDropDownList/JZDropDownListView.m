//
//  JZDropDownListView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZDropDownListView.h"
#import "JZDropDownItem.h"
#import "JZDropDownItemCell.h"
#import <Masonry/Masonry.h>


@interface JZDropDownListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView * topArrowImageView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * showView;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) JZDropDownConfig * dropDownConfig;

@property (nonatomic,assign) BOOL isAnimate;

@end

@implementation JZDropDownListView

- (instancetype)initWithConfig:(JZDropDownConfig *)dropDownConfig {
    self = [super init];
    if (self) {
        self.dropDownConfig = dropDownConfig;
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.isShow = NO;
    self.isAnimate = NO;
    
    [self addSubview:self.contentView];
    if (self.dropDownConfig.isShowArrow) {
        [self.contentView addSubview:self.topArrowImageView];
    }
    [self addSubview:self.showView];
    [self.showView addSubview:self.tableView];
    if (self.dropDownConfig.cornerRadius >0) {
        self.showView.layer.masksToBounds = YES;
        self.showView.layer.cornerRadius =self.dropDownConfig.cornerRadius;
    }
    [self makeConstraints];
}
#pragma mark - 约束
- (void)makeConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self); 
    }];
}

#pragma mark - 对外公开函数
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)targetButtonItem dropDownListViewShowType:(JZDropDownListViewShowType)dropDownListViewShowType {
    UIView *targetView = (UIView *)[targetButtonItem performSelector:@selector(view)];
    if (nil == targetView) {
        NSLog(@"！！！请查看一下当前的 UIBarButtonItem: %@", targetButtonItem);
        return;
    }
    UIView *containerView = targetView.window;
    
    if (nil == containerView) {
        NSLog(@"！！！请查看一下当前的 UIBarButtonItem: %@", targetButtonItem);
        return;
    }

    [self presentPointingAtView:targetView inView:containerView dropDownListViewShowType:dropDownListViewShowType];
}
- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView dropDownListViewShowType:(JZDropDownListViewShowType)dropDownListViewShowType{
    [containerView addSubview:self];
    if (dropDownListViewShowType == JZDropDownListViewShowTypeNormal) {
        self.dropDownConfig.dropDownViewLeft = targetView.frame.origin.x + (targetView.frame.size.width/2);
    }else if (dropDownListViewShowType == JZDropDownListViewShowTypeLeft){
        self.dropDownConfig.dropDownViewLeft = 0.1f;
    }else if (dropDownListViewShowType == JZDropDownListViewShowTypeRight){
        self.dropDownConfig.dropDownViewLeft = -0.1f;
    }else if (dropDownListViewShowType == JZDropDownListViewShowTypeCenter){
        self.dropDownConfig.dropDownViewLeft = [UIScreen mainScreen].bounds.size.width/2 - self.dropDownConfig.dropDownViewWidth/2;
    }
    if (0.1f >= self.dropDownConfig.dropDownViewLeft) {
        self.dropDownConfig.dropDownViewLeft = targetView.frame.origin.x + (targetView.frame.size.width/2);
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_top);
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.height.mas_equalTo(0.0);
    }];

    if (self.dropDownConfig.isShowArrow) {
        [self.topArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 11.5));
            make.top.mas_equalTo(self.dropDownConfig.dropDownViewTop);
            make.left.mas_equalTo(self.dropDownConfig.dropDownViewLeft-(15/2));
        }];
    }
    CGFloat tableViewHeight = 0;
    for (JZDropDownItem * dropDownItem in self.dropDownConfig.dropDownItems) {
        tableViewHeight += dropDownItem.info.cellHeight;
    }
    if (tableViewHeight > self.dropDownConfig.dropDownViewMAXHeight) {
        tableViewHeight = self.dropDownConfig.dropDownViewMAXHeight;
    }
    self.dropDownConfig.dropDownViewMAXHeight = tableViewHeight;

    CGFloat dropDownViewLeft = self.dropDownConfig.dropDownViewLeft - (self.dropDownConfig.dropDownViewWidth/2);
    if (self.dropDownConfig.dropDownViewLeft - (self.dropDownConfig.dropDownViewWidth/2) <= 0) {
        dropDownViewLeft = 0.1f;
    }else if ([UIScreen mainScreen].bounds.size.width - self.dropDownConfig.dropDownViewLeft<=(self.dropDownConfig.dropDownViewWidth/2)){
        dropDownViewLeft = -0.1f;
    }
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.dropDownConfig.dropDownViewWidth, 0));
        if (self.dropDownConfig.isShowArrow) {
            make.top.mas_equalTo(self.dropDownConfig.dropDownViewTop +11.5f);
        }else{
            make.top.mas_equalTo(self.dropDownConfig.dropDownViewTop);
        }
        if (dropDownViewLeft>=0) {
            make.left.mas_equalTo(self).mas_offset(dropDownViewLeft);
        }else{
            make.right.mas_equalTo(self).mas_offset(dropDownViewLeft);
        }
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.showView); 
    }];
}

- (void)animateShowOrHiden{
    if (self.isShow) {
        [self hidenMenu];
    }else{
        [self showMenu];
    }
}
#pragma mark - 私有函数

- (void)showMenu {
    
    if (self.isShow) {
        return;
    }
    if (self.isAnimate) {
        return;
    }
    [self.contentView layoutIfNeeded];
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.dropDownConfig.dropDownViewWidth, self.dropDownConfig.dropDownViewMAXHeight));
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    self.isAnimate = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isAnimate = NO;
        self.isShow = YES;
        self.contentView.hidden = NO;
        self.hidden = NO;
    }]; 
    
}
- (void)hidenMenu {
    if (!self.isShow) {
        return;
    }
    if (self.isAnimate) {
        return;
    }
    [self.contentView layoutIfNeeded];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.0f);
    }];
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.dropDownConfig.dropDownViewWidth, 0));
    }];
    self.isAnimate = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.contentView.hidden = YES;
        self.hidden = YES;
        self.isAnimate = NO;
        self.isShow = NO;
    }]; 
}
#pragma mark - UITableViewDelegate,UITableViewDataSource


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dropDownConfig.dropDownItems) {
        return 1;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dropDownConfig.dropDownItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     JZDropDownItem * dropDownItem = [self.dropDownConfig.dropDownItems objectAtIndex:indexPath.row];
    return dropDownItem.info.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JZDropDownItem * dropDownItem = [self.dropDownConfig.dropDownItems objectAtIndex:indexPath.row];
    NSString *cellIdentifier = dropDownItem.info.cellIdentifier;

    if ((!dropDownItem.info.cellName || [dropDownItem.info.cellName isKindOfClass:[NSNull class]] || dropDownItem.info.cellName.length == 0 || [dropDownItem.info.cellName isEqualToString:@""])) {
        NSAssert(NO, @"[cell <dropDownItem.info.cellName> 为空]");
    }
    Class cellClass = NSClassFromString(dropDownItem.info.cellName);
    JZDropDownCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [(JZDropDownCell *)[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell cellDateWithItem:dropDownItem];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JZDropDownItem * dropDownItem = [self.dropDownConfig.dropDownItems objectAtIndex:indexPath.row];
    if (dropDownItem && dropDownItem.isHidenCell) {
        [self hidenMenu];
    }
    if (dropDownItem.dropSelectedBlcok) {
        dropDownItem.dropSelectedBlcok(indexPath.row,dropDownItem);
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownListView:withSelectedItem:withIndx:)]) {
        [self.delegate dropDownListView:self withSelectedItem:dropDownItem withIndx:indexPath.row];
        return;
    }
}

#pragma mark -手势

- (void)hideContentViewTap:(UITapGestureRecognizer *)tapSender{     
    [self hidenMenu];
}
#pragma mark - topArrowImageView
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideContentViewTap:)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc]init];
        _showView.clipsToBounds = YES;
    }
    return _showView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)topArrowImageView {
    if (!_topArrowImageView) {
        _topArrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lce_dropdown_arrowImage_top"]];
    }
    return _topArrowImageView;
}
- (void)dealloc{
    [self removeFromSuperview];
}
@end



@implementation JZDropDownConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShowArrow = YES;
        self.dropDownViewWidth = 100.0f;
        self.dropDownViewMAXHeight = 240.0f;
    }
    return self;
}
- (NSMutableArray <JZDropDownItem *>*)dropDownItems{
    if (!_dropDownItems) {
        _dropDownItems = [@[] mutableCopy];
    }
    return _dropDownItems;
}
@end
