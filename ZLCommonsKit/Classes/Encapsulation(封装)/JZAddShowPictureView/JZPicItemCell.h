//
//  JZPicItemCell.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/3.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemActionBlock)(UIView *imageView);
typedef void(^DeleteActionBlock)(void);
typedef void(^LongPressedActionBlock)(UILongPressGestureRecognizer *press);
@class JZPicModel;


@interface JZPicItemCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *itemView;
@property(nonatomic,strong)UIView *deleteView;
@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,copy)ItemActionBlock actionBlock;
@property(nonatomic,copy)DeleteActionBlock deleteBlock;


- (void)imageWithImageStr:(NSString *)imageStr withCurrentIndex:(NSInteger)currentIndex withImageArr:(NSMutableArray *)imageArray;

@end
//仅仅显示
@interface JZShowPicCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *mainImageView;
@property(nonatomic, strong)UIButton *picNumBtn;
@property(nonatomic,copy)ItemActionBlock actionBlock;

@property(nonatomic, copy)LongPressedActionBlock pressBlock;

- (void)collectionCelDataWithModel:(JZPicModel *)picModel withIndexPath:(NSIndexPath *)indexPath;


@end

