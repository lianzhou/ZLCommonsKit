//
//  JZKeyBoarfToolCollectionCell.m
//  e学云
//
//  Created by 马金丽 on 17/5/18.
//  Copyright © 2017年 juziwl. All rights reserved.
//

#import "JZKeyBoarfToolCollectionCell.h"
#import "JZSystemMacrocDefine.h"

@interface JZKeyBoarfToolCollectionCell()

@property(nonatomic,strong)UIButton *itemImageBtn;
@property(nonatomic,strong)UILabel *itemTitleLabel;

@end

@implementation JZKeyBoarfToolCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    
    _itemImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _itemImageBtn.frame = CGRectMake(((SCREEN_WIDTH-30)/4-60)/2, 236/2-90, 60, 60);
    [self.contentView addSubview:_itemImageBtn];
    [_itemImageBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    _itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_itemImageBtn.frame), CGRectGetMaxY(_itemImageBtn.frame)+5, CGRectGetWidth(_itemImageBtn.frame), 20)];
    _itemTitleLabel.text = @"相机";
    _itemTitleLabel.font = [UIFont systemFontOfSize:15];
    _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_itemTitleLabel];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}


- (void)setCellDataWithDict:(NSDictionary *)currentDict
{
    
    [_itemImageBtn setImage:[UIImage imageNamed:[currentDict objectForKey:@"iconImageNormal"]] forState:UIControlStateNormal];
    [_itemImageBtn setImage:[UIImage imageNamed:[currentDict objectForKey:@"iconImageHigh"]] forState:UIControlStateHighlighted];
    _itemTitleLabel.text = [currentDict objectForKey:@"iconTitle"];
    
}

- (void)didSelectClick:(UIButton *)sender
{
    if (_selectBlock) {
        _selectBlock();
    }
}
@end
