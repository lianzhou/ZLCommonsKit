//
//  ENAssetViewCell.h
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/1.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "ENPhotoLibraryManager.h"
#import "JZSystemMacrocDefine.h"


typedef void (^ENAssetSelectImageCount)(NSInteger index);

@class ENAssetViewCell;
@protocol ENAssetViewCellDelegate <NSObject>
@optional

- (void)assetViewCell:(ENAssetViewCell *)assetCell selectPhotoButtonAssetModel:(ENAssetModel *)assetModel selectImageCount:(ENAssetSelectImageCount)selectImageCount;

@end


@interface ENAssetViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView * imageView;

@property (nonatomic, weak) id <ENAssetViewCellDelegate> delegate;

- (void)settingModelAssetModel:(ENAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath;

@end
