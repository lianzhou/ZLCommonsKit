//
//  ZLImageDropDownCell.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/7.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ZLImageDropDownCell.h"

@implementation ZLImageDropDownCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializer];
    }
    return self;
}
- (void)initializer { 
    
    
    [self makeConstraints];
}


#pragma mark - 约束
- (void)makeConstraints {
    
}

- (void)cellDateWithItem:(ZLDropDownItem *)item{
    ENAlbumModel * albumModel = (ENAlbumModel *)item.customData;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@-(%ld)",item.title,(long)albumModel.count];
    
}


@end
