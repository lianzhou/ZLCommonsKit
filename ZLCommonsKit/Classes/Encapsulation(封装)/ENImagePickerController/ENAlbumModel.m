//
//  ENAlbumModel.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/3.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENAlbumModel.h"

@implementation ENAlbumModel

@end

@implementation ENAssetModel

- (void)changeSelectImageCount:(NSInteger)count {
    if (self && self.count > count) {
        self.count -= 1;
        if (self.changeSelectImageCount) {
            self.changeSelectImageCount();
        }
    }
}

@end
