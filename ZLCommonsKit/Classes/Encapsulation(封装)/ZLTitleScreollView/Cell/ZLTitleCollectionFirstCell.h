//
//  ZLTitleCollectionFirstCell.h
//  TitleTableViewDemo
//
//  Created by zhangjiang on 2017/6/14.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import "ZLTitleCollectionBaseCell.h"

@interface ZLTitleCollectionFirstCell : ZLTitleCollectionBaseCell

@property (nonatomic,copy) NSString    *titleString;

@property (nonatomic,strong) UILabel    *titleLabel;


- (void)setSelectFont:(UIFont *)titleSelectFont color:(UIColor *)titleSelectColor ;

- (void)setNoSelectFont:(UIFont *)titleFont color:(UIColor *)titleColor;


@end
