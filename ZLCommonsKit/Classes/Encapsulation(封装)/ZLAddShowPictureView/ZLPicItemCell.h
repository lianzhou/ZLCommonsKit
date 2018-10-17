//
//  ZLPicItemCell.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemActionBlock)(UIView *imageView);
typedef void(^DeleteActionBlock)(void);
typedef void(^LongPressedActionBlock)(UILongPressGestureRecognizer *press);
@class ZLPicModel;


@interface ZLPicItemCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *itemView;
@property(nonatomic,strong)UIView *deleteView;
@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,copy)ItemActionBlock actionBlock;
@property(nonatomic,copy)DeleteActionBlock deleteBlock;


- (void)imageWithImageStr:(NSString *)imageStr withCurrentIndex:(NSInteger)currentIndex withImageArr:(NSMutableArray *)imageArray;

@end
//仅仅显示
@interface ZLShowPicCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *mainImageView;
@property(nonatomic, strong)UIButton *picNumBtn;
@property(nonatomic,copy)ItemActionBlock actionBlock;

@property(nonatomic, copy)LongPressedActionBlock pressBlock;

- (void)collectionCelDataWithModel:(ZLPicModel *)picModel withIndexPath:(NSIndexPath *)indexPath;


@end

