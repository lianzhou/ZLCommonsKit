//
//  ZLTitleCollectionCell.h
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBaseTitleModel.h"
#import "Masonry.h"

@interface ZLTitleCollectionBaseCell : UICollectionViewCell


- (void)settingModelData:(ZLBaseTitleModel *)contentModel indexPath:(NSIndexPath *)indexPath;

- (void)setSelectCellTransform:(CGAffineTransform)transform;

- (void)setNoSelectCellTransform:(CGAffineTransform)transform;


@end
