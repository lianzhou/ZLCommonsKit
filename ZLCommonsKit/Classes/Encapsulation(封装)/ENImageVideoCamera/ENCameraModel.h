//
//  ENCameraModel.h
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ENAlbumModel.h"

@interface ENCameraModel : NSObject

@property (nonatomic,strong) UIImage * cameraImage;
@property (nonatomic,assign) BOOL isPortrait;

@property (nonatomic,copy) NSString * cameraVodeoLocal; 
@property (nonatomic,strong) NSDictionary<NSString *, id> *outputSettings;
@property (nonatomic,assign) int cameraVodeoLength; 

@property (nonatomic,assign,readonly) CGFloat videoHeight; 
@property (nonatomic,assign,readonly) CGFloat videoWidth; 

@property (nonatomic,strong) ENAssetModel *assetModel;
@end
