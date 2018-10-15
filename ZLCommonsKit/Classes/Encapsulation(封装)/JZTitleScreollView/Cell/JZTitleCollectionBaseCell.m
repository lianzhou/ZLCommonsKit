//
//  JZTitleCollectionCell.m
//  TitleTableViewDemo
//
//  Created by Mac mini on 2017/5/16.
//  Copyright © 2017年 feixu. All rights reserved.
//

#import "JZTitleCollectionBaseCell.h"
#import "Masonry.h"


@implementation JZTitleCollectionBaseCell


- (void)settingModelData:(JZBaseTitleModel *)contentModel indexPath:(NSIndexPath *)indexPath {
    

}
- (void)setSelectCellTransform:(CGAffineTransform)transform {
    if (transform.tx >0) {
        self.transform = transform;
    } else {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }
}

- (void)setNoSelectCellTransform:(CGAffineTransform)transform {
    self.transform = transform;
}

@end
