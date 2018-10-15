//
//  ENAssetViewCell.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/1.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENAssetViewCell.h"
#import "UIImage+Picker.h"
#import "JZDataHandler.h"

@interface ENAssetViewCell ()

@property(nonatomic,strong)ENAssetModel * assetModel;

@property(nonatomic,strong)UIView * imagebgView;
@property(nonatomic,strong)UIButton *selectPhotoButton;
@property(nonatomic,strong)UIImageView * selectImageView;
//@property(nonatomic,strong)UIImageView * typeImageView;

@property(nonatomic,strong)UILabel * selectLabel;
@property(nonatomic,strong)UILabel * timeLabel;

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation ENAssetViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}
- (void)initializer{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.imagebgView];
    [self.contentView addSubview:self.selectPhotoButton];
    [self.contentView addSubview:self.selectImageView];
//    [self.contentView addSubview:self.typeImageView];
    [self.contentView addSubview:self.selectLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self makeConstraints];
}
- (void)makeConstraints{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];   
    [self.imagebgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.imageView);
    }];
    [self.selectPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectPhotoButton.mas_right).mas_offset(-5);
        make.top.mas_equalTo(self.selectPhotoButton.mas_top).mas_offset(5);        
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
//    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(5);
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);        
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.selectImageView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
}
- (void)settingModelAssetModel:(ENAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath{
    _assetModel = assetModel;
    if (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)) {
        self.representedAssetIdentifier = [[ENPhotoLibraryManager manager] getAssetIdentifier:assetModel];
    }
    WEAKSELF
    self.imageRequestID = [[ENPhotoLibraryManager manager] getPhotoWithAsset:assetModel.asset photoWidth:self.frame.size.width*2 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {

        if (!([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)) {
            weakSelf.imageView.image = photo; return;
        }
        if ([weakSelf.representedAssetIdentifier isEqualToString:[[ENPhotoLibraryManager manager] getAssetIdentifier:assetModel]]) {
            weakSelf.imageView.image = photo;
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:weakSelf.imageRequestID];
        }
        if (!isDegraded) {
            weakSelf.imageRequestID = PHInvalidImageRequestID;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    
    if ((assetModel.type ==  ENAssetModelMediaTypeVideo) && (assetModel.duration !=0)) {
        self.timeLabel.text = [JZDataHandler hourMinuteTimeFromSecond:[NSString stringWithFormat:@"%d",assetModel.duration]];
        self.timeLabel.hidden = NO;
    }else{
        self.timeLabel.hidden = YES;
    }
    [self changePhotoButtonSelect];
    
    self.assetModel.changeSelectImageCount = ^{
        [weakSelf changePhotoButtonSelect];
    };
    
}

- (void)changePhotoButtonSelect{
    if (self.assetModel.isSelected) {
        self.imagebgView.hidden = NO;
        self.selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_yes"];
        if (self.assetModel.count >0) {
            self.selectLabel.text = [NSString stringWithFormat:@"%ld",self.assetModel.count];
        }
    }else{
        self.imagebgView.hidden = YES;
        self.selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_no"];
        self.selectLabel.text = [NSString stringWithFormat:@""];
    }
}
- (void)selectPhotoButtonClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetViewCell:selectPhotoButtonAssetModel:selectImageCount:)]) {
        WEAKSELF
        [self.delegate assetViewCell:self 
         selectPhotoButtonAssetModel:self.assetModel 
                    selectImageCount:^(NSInteger index) {
                        weakSelf.assetModel.isSelected = !self.assetModel.isSelected;
                        weakSelf.assetModel.count = index;
                        [weakSelf changePhotoButtonSelect];
                    }];
    }
}



#pragma mark - 懒加载
- (UILabel *)selectLabel{
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]init];
        _selectLabel.textAlignment = NSTextAlignmentCenter;
        _selectLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        _selectLabel.textColor = [UIColor whiteColor];
    }
    return _selectLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    return _timeLabel;
}
- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_no"];
    }
    return _selectImageView;
}
//- (UIImageView *)typeImageView{
//    if (!_typeImageView) {
//        _typeImageView = [[UIImageView alloc]init];
//    }
//    return _typeImageView;
//}

- (UIButton *)selectPhotoButton{
    if (!_selectPhotoButton) {
        _selectPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPhotoButton;
}
- (UIView *)imagebgView{
    if (!_imagebgView) {
        _imagebgView = [[UIView alloc]init];
        _imagebgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    }
    return _imagebgView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
- (void)dealloc{
    NSLog(@"++++++被销毁");
}
@end
