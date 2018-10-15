//
//  JZKeyBoarfToolCollectionCell.h
//  e学云
//
//  Created by 马金丽 on 17/5/18.
//  Copyright © 2017年 juziwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemSelectBlock)();
@interface JZKeyBoarfToolCollectionCell : UICollectionViewCell

@property(nonatomic,copy)ItemSelectBlock selectBlock;
- (void)setCellDataWithDict:(NSDictionary *)currentDict;

@end
