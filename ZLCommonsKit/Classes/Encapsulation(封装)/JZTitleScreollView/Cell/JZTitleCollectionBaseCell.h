//
//  JZTitleCollectionCell.h
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBaseTitleModel.h"
#import "Masonry.h"

@interface JZTitleCollectionBaseCell : UICollectionViewCell


- (void)settingModelData:(JZBaseTitleModel *)contentModel indexPath:(NSIndexPath *)indexPath;

- (void)setSelectCellTransform:(CGAffineTransform)transform;

- (void)setNoSelectCellTransform:(CGAffineTransform)transform;


@end
