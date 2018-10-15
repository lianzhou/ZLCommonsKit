//
//  ENImagePickerController.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/1.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENImagePickerController.h"
#import "JZDropDownListView.h"
#import "JZDropDownItem.h"
#import "ENPhotoLibraryManager.h"
#import "ENTitleView.h"
#import "PBViewController.h"
#import "JZAlertHUD.h"
#import "JZSystemMacrocDefine.h"
#import "UIScrollView+JZEmptyDataSet.h"
#import <TOCropViewController/TOCropViewController.h>
#import "JZStringMacrocDefine.h"
static CGFloat itemPickerMargin = 5;
static CGFloat imagePickerBarMargin = 45.0f;

@interface ENImagePickerController ()<UICollectionViewDelegate,UICollectionViewDataSource,ENAssetViewCellDelegate,PBViewControllerDataSource,PBViewControllerDelegate,TOCropViewControllerDelegate>

@property(nonatomic,strong) ENAlbumModel * albumModel;
@property(nonatomic,strong) UICollectionView * pickerCollectionView;
@property(nonatomic,strong) UIBarButtonItem * leftBarButtonItem;
@property(nonatomic,strong) UIBarButtonItem * rightBarButtonItem;
@property(nonatomic,strong) ENTitleView * enTitleView;

@property(nonatomic,strong) JZDropDownListView * dropDownListView;

//当前相册查看的大图
@property (nonatomic, strong) NSMutableDictionary<NSNumber * , ENPhoto *> * visiblePhotos;

//预览查看大图
@property (nonatomic, strong) NSMutableDictionary<NSNumber * , ENPhoto *> * visiblePrePhotos;
//预览查看大图的数据源
@property (nonatomic, strong) NSMutableArray<ENAssetModel *> *selectedPreModels;

//所有查看过的大图
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber * , ENPhoto *> *> * visibleAllPhotos;

@property (nonatomic, strong) UIButton * previewButton;

@property (nonatomic, assign) BOOL isPreview;

@end

@implementation ENImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.allowPickingVideo = YES;
        self.allowPickingImage = YES;
        self.allowsEditing = NO;
        
        self.columnNumber = 4;
        self.minImagesCount = 0;
        self.maxImagesCount = 9;
        self.maxVideosCount = 1;
        self.visibleAllPhotos = [@{} mutableCopy];
        self.visiblePrePhotos = [@{} mutableCopy];
        
        self.selectedPreModels = [@[] mutableCopy];
        self.isPreview = NO;
        //        self.photoPreviewMaxWidth = 600.0f;
        //        self.photoWidth = 828.0f;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick:)];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    
    self.enTitleView.attributedTitle = @"相册";
    self.navigationItem.titleView = self.enTitleView;
    //    [self.enTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(200, 40));
    //    }];
    NSMutableArray * selectedModels = [@[] mutableCopy];
    
    if (self.selectedModels.count >0) {
        if ([[self.selectedModels firstObject] isKindOfClass:[ENCameraModel class]]) {
            ENCameraModel * cameraModel = (ENCameraModel *)[self.selectedModels firstObject];
            [selectedModels addObject:cameraModel.assetModel];
        }
    }
    if (selectedModels.count == 0) {
        [selectedModels addObjectsFromArray:self.selectedModels];
    }
    
    if (selectedModels.count>0) {
        [selectedModels enumerateObjectsUsingBlock:^(ENAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.count = (idx+1);
            obj.isSelected = YES;
        }];
    }
    self.selectedModels = [@[] mutableCopy];
    [self.selectedModels addObjectsFromArray:selectedModels];
    
    WEAKSELF
    self.enTitleView.titleViewWithTitleButtonClick = ^BOOL(UIButton *sender) {
        [weakSelf.dropDownListView animateShowOrHiden];
        return YES;
    };
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pickerCollectionView];
    [self.view addSubview:self.previewButton];
    [self makeConstraints];
    [JZSystemUtils assetsAuthorizationStatusAuthorized:^{
        [[ENPhotoLibraryManager manager] getAllAlbums:weakSelf.allowPickingVideo allowPickingImage:self.allowPickingImage completion:^(NSArray<ENAlbumModel *> *albumModels) {
            [weakSelf createNavigationItemTitleView:albumModels];
        }];
    } restricted:^{
        
        [weakSelf.pickerCollectionView setupEmptyDataText:@"此应用程序没有权限访问您的照片或视频" subText:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许\"%@\"访问你的手机相册",[JZSystemUtils getTheAppName]] emptyImage:nil];
        if(JZ_IOS8) {
            [weakSelf.pickerCollectionView setupEmptyButtonText:@"跳转设置" emptyButtonImage:nil tapBlock:^{
                NSLog(@"跳转");
                [JZSystemUtils openSystemSetting];
            }];
        }
        
    }];
    
}

- (void)makeConstraints{
    [self.pickerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-imagePickerBarMargin);
    }];
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, imagePickerBarMargin));
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}
- (void)createNavigationItemTitleView:(NSArray<ENAlbumModel *> *)models{
    
    NSMutableArray * titleArrayM = [@[] mutableCopy];
    
    ENAlbumModel * firstModel = [models firstObject];
    if (firstModel) {
        self.enTitleView.attributedTitle = firstModel.name;
        [self changeAlbumModel:firstModel];
    }
    NSMutableDictionary * photoDicM = [@{} mutableCopy];
    [self.visibleAllPhotos setObject:photoDicM forKey:[NSNumber numberWithInteger:0]];
    self.visiblePhotos = photoDicM;
    WEAKSELF
    for (ENAlbumModel * albumModel in models) {
        JZDropDownItem * item1 = [JZDropDownItem downItemWithTitle:albumModel.name withSelectedBlock:^(NSUInteger idex, JZDropDownItem * info) {
            if (![weakSelf.visibleAllPhotos.allKeys containsObject:[NSNumber numberWithInteger:idex]]) {
                NSMutableDictionary * photoDicM = [@{} mutableCopy];
                [weakSelf.visibleAllPhotos setObject:photoDicM forKey:[NSNumber numberWithInteger:idex]];
                weakSelf.visiblePhotos = photoDicM;
            }else{
                weakSelf.visiblePhotos = [weakSelf.visibleAllPhotos objectForKey:[NSNumber numberWithInteger:idex]];
            }
            weakSelf.enTitleView.attributedTitle = info.title;
            [weakSelf changeAlbumModel:albumModel];
        }];
        item1.info.cellName = @"JZImageDropDownCell";
        item1.info.cellIdentifier = @"JZImageDropDownCell";
        item1.customData = albumModel;
        [titleArrayM addObject:item1];
    }
    
    JZDropDownConfig * dropDownConfig = [[JZDropDownConfig alloc]init];
    dropDownConfig.isShowArrow = NO;
    dropDownConfig.dropDownItems = titleArrayM;
    dropDownConfig.dropDownViewWidth = [UIScreen mainScreen].bounds.size.width;
    dropDownConfig.dropDownViewLeft = [UIScreen mainScreen].bounds.size.width/2;
    self.dropDownListView = [[JZDropDownListView alloc]initWithConfig:dropDownConfig];
    [self.dropDownListView presentPointingAtView:self.enTitleView inView:self.view dropDownListViewShowType:JZDropDownListViewShowTypeCenter];
    
}
- (void)changeAlbumModel:(ENAlbumModel *)albumModel{
    self.albumModel = albumModel;
    WEAKSELF
    [self getAssetsFromFetchResult:albumModel completion:^(NSArray<ENAssetModel *> *models) {
        weakSelf.albumModel.models = models;
        [weakSelf.pickerCollectionView reloadData];
    }];
}
- (void)getAssetsFromFetchResult:(ENAlbumModel *)albumModel completion:(void (^)(NSArray<ENAssetModel *> *models))completion{
    
    [[ENPhotoLibraryManager manager] getAllAssetWithAlbums:albumModel selectedModels:self.selectedModels allowPickingVideo:self.allowPickingVideo allowPickingImage:self.allowPickingImage completion:completion];
    
}

- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender {
    [self doneButtonClick];
}

- (void)previewButtonClick:(UIButton *)sender{
    
    if (self.selectedModels.count == 0) {
        return;
    }
    
    self.isPreview = YES;
    [self.visiblePrePhotos removeAllObjects];
    [self.selectedPreModels removeAllObjects];
    [self.selectedPreModels addObjectsFromArray:self.selectedModels];
    
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.blurBackground = YES;
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = 0;
    pbViewController.pb_select = YES;
    [self presentViewController:pbViewController animated:YES completion:nil];
    
}
- (void)doneButtonClick {
    if (self.minImagesCount && self.selectedModels.count < self.minImagesCount) {
        NSString *title = [NSString stringWithFormat:@"Select a minimum of %zd photos", self.minImagesCount];
        NSLog(@"%@",title);
        return;
    }
    
    NSMutableArray *photos = [@[] mutableCopy];
    NSMutableArray *assets = [@[] mutableCopy];
    NSMutableArray *infoArr = [@[] mutableCopy];
    for (NSInteger i = 0; i < self.selectedModels.count; i++) {
        [photos addObject:@1];
        [assets addObject:@1];
        [infoArr addObject:@1];
    }
    self.rightBarButtonItem.enabled = NO;
    //    [JZAlertHUD hudShowMessage:@"加载中..." toView:self.view];
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSInteger i = 0; i < self.selectedModels.count; i++) {
        ENAssetModel *model = self.selectedModels[i];
        dispatch_group_enter(group);
        //         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        dispatch_group_async(group, queue, ^{
        
        CGFloat assetWidth = [UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale;
        if ([model.asset isKindOfClass:[PHAsset class]]) {
            
            PHAsset *asset = (PHAsset *)model.asset;
            assetWidth = asset.pixelWidth;
        }
        
        [[ENPhotoLibraryManager manager] getPhotoWithAsset:model.asset photoWidth:assetWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) {
                return;
            }
            if (photo) {
                [photos replaceObjectAtIndex:i withObject:photo];
            }
            if (info)  {
                [infoArr replaceObjectAtIndex:i withObject:info];
            }
            [assets replaceObjectAtIndex:i withObject:model];
            //                dispatch_semaphore_signal(semaphore);
            dispatch_group_leave(group);
        } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            if(error){
                dispatch_group_leave(group);
            }
            //                  dispatch_semaphore_signal(semaphore);
        } networkAccessAllowed:YES];
        //        });
    }
    dispatch_group_notify(group, queue, ^{
        //        for (NSInteger i = 0; i < self.selectedModels.count; i++) {
        //            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
            self.rightBarButtonItem.enabled = YES;
        });
    });
}

- (void)didGetAllPhotos:(NSMutableArray *)photos assets:(NSMutableArray *)assets infoArr:(NSMutableArray *)infoArr {
    if (infoArr.count>0 || assets.count>0 || photos.count>0) {
        WEAKSELF
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr dismiss:^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
    }
    
    
}

- (void)callDelegateMethodWithPhotos:(NSMutableArray *)photos assets:(NSMutableArray *)assets infoArr:(NSMutableArray *)infoArr dismiss:(void (^)(void))dismiss{
    
    
    ENAssetModel *model = [assets firstObject];
    if (!model) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:failure:)]) {
            [self.delegate imagePickerController:self failure:@"获取相册资源失败"];
        }
        return;
    }
    
    if (model.type == ENAssetModelMediaTypeVideo) {
        [JZAlertHUD showHUDTitle:@"正在压缩..." toView:self.view];
        WEAKSELF
        [[ENPhotoLibraryManager manager] getVideoOutputPathWithAsset:model.asset completion:^(NSString *outputPath) {
            ENCameraModel * assetVideoModel = [[ENCameraModel alloc] init];
            assetVideoModel.cameraVodeoLocal = outputPath;
            assetVideoModel.cameraImage =  [weakSelf firstFrameWithVideoURL:outputPath model:model];
            assetVideoModel.cameraVodeoLength = model.duration;
            assetVideoModel.assetModel = model;
            NSMutableDictionary * outputSettings = [@{} mutableCopy];
            [outputSettings setObject:[NSNumber numberWithFloat:model.pixelHeight] forKey:AVVideoHeightKey];
            [outputSettings setObject:[NSNumber numberWithFloat:model.pixelWidth] forKey:AVVideoWidthKey];
            assetVideoModel.outputSettings = outputSettings;
            
            [JZAlertHUD hideHUD:weakSelf.view];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(imagePickerController:didFinishVideoModel:)]) {
                [weakSelf.delegate imagePickerController:weakSelf didFinishVideoModel:assetVideoModel];
            }
            if (dismiss) {
                dismiss();
            }
        }];
        
    }else{
        
        if (self.allowsEditing && photos.count == 1) {
            
            TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:[photos firstObject]];
            cropViewController.delegate = self;
            cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
            cropViewController.aspectRatioLockEnabled = YES;
            cropViewController.aspectRatioPickerButtonHidden = YES;
            
            cropViewController.resetAspectRatioEnabled = NO;
            [self presentViewController:cropViewController animated:YES completion:nil];
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageList:)]) {
            [self.delegate imagePickerController:self didFinishPickingImageList:photos];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageList:assetModelList:infoArr:)]) {
            [self.delegate imagePickerController:self didFinishPickingImageList:photos assetModelList:assets infoArr:infoArr];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageList:infoArr:)]) {
            [self.delegate imagePickerController:self didFinishPickingImageList:photos infoArr:infoArr];
        }
        if (dismiss) {
            dismiss();
        }
    }
    
    
    
    
}
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageList:)]) {
        [self.delegate imagePickerController:self didFinishPickingImageList:[@[image] mutableCopy]];
    }
    
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    
}
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark ---- 获取图片第一帧 
- (UIImage *)firstFrameWithVideoURL:(NSString *)url model:(ENAssetModel *)model
{  
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:opts];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 30);
    imageGenerator.maximumSize = CGSizeMake(model.pixelWidth, model.pixelHeight);
    NSError *error = nil;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:&error];
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    if (image) {
        return image;
    }
    return nil;
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.albumModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ENAssetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ENAssetViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    ENAssetModel * assetModel = [self.albumModel.models objectAtIndex:indexPath.row];
    [cell settingModelAssetModel:assetModel indexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.isPreview = NO;
    
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.blurBackground = YES;
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = indexPath.row;
    pbViewController.pb_select = YES;
    [self presentViewController:pbViewController animated:YES completion:nil];
}


#pragma mark - PBViewControllerDataSource

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    if (self.isPreview) {
        return self.selectedPreModels.count;
    }
    return self.albumModel.models.count;
}
- (ENPhoto *)viewController:(PBViewController *)viewController photoForPageAtIndex:(NSInteger)index {
    
    if (self.isPreview) {
        
        NSNumber * visibleKey = [NSNumber numberWithInteger:index];
        if ([self.visiblePrePhotos.allKeys containsObject:visibleKey]) {
            ENPhoto * photo = [self.visiblePrePhotos objectForKey:visibleKey];
            return photo;
        }
        
        ENAssetModel * assetModel = [self.selectedPreModels objectAtIndex:index];
        ENPhoto * photo = [ENPhoto photoWithAsset:assetModel];
        [self.visiblePrePhotos setObject:photo forKey:visibleKey];
        return photo;
    }
    
    NSNumber * visibleKey = [NSNumber numberWithInteger:index];
    if ([self.visiblePhotos.allKeys containsObject:visibleKey]) {
        ENPhoto * photo = [self.visiblePhotos objectForKey:visibleKey];
        return photo;
    }
    ENAssetModel * assetModel = [self.albumModel.models objectAtIndex:index];
    ENPhoto * photo = [ENPhoto photoWithAsset:assetModel];
    [self.visiblePhotos setObject:photo forKey:visibleKey];
    return photo;
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    if (self.isPreview) {
        return nil;
    }
    ENAssetViewCell *cell = (ENAssetViewCell *)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        if ([[self.pickerCollectionView visibleCells] containsObject:cell]) {
            return cell.imageView;
        }
    }
    
    return nil;
}

#pragma mark - PBViewControllerDelegate
- (void)viewController:(PBViewController *)viewController didSelectPageAtIndex:(NSInteger)index didSelectPageAtPhoto:(ENPhoto *)photo success:(void (^)(NSInteger index))success failure:(void (^)(NSString *  error))failure{
    
    [self selectPhotoButtonAssetModel:photo.assetModel success:success failure:failure];
    if (self.isPreview) {
        [self.pickerCollectionView reloadData];
        return;
    }
    
    [self.pickerCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}
- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    NSLog(@"didLongPressedPageAtIndex: %@", @(index));
}
#pragma mark - 选择
- (void)selectPhotoButtonAssetModel:(ENAssetModel *)assetModel success:(void (^)(NSInteger index))success failure:(void (^)(NSString *error))failure{
    if (assetModel.type == ENAssetModelMediaTypeVideo) {
        CGFloat maxTime = 15.0f;
        if (self.maxVideosTime && self.maxVideosTime > 0) {
            maxTime = self.maxVideosTime;
        }
        if (assetModel.duration > maxTime) {
            if (failure) {
                failure([NSString stringWithFormat:@"视频不能超过%.f秒",maxTime]);
            }
            return;
        }
    }
    if (assetModel.isSelected) {
        [self.selectedModels removeObject:assetModel];
        if (self.selectedModels.count == 0) {
            [self.rightBarButtonItem setTitle:@"确定"];
            self.previewButton.highlighted = NO;
        }else{
            [self.rightBarButtonItem setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedModels.count]];
            self.previewButton.highlighted = YES;
            
        }
        [self.selectedModels enumerateObjectsUsingBlock:^(ENAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj changeSelectImageCount:assetModel.count];
        }];
    }else{
        if (self.selectedModels.count >= self.maxImagesCount) {
            if (failure) {
                failure(@"已经选择最大数");
            }
            return;
        }
        if (self.selectedModels.count > 0) {
            ENAssetModel * selectedAssetModel = (ENAssetModel *)[self.selectedModels firstObject];
            
            
            if (selectedAssetModel.type == ENAssetModelMediaTypeVideo) {
                if (selectedAssetModel.type !=assetModel.type) {
                    if (failure) {
                        failure(@"不能同时选择图片和视频");
                    }
                }else{
                    if (failure) {
                        failure(@"一次只能选择一个视频");
                    }
                }
                return;
            }else{
                if (selectedAssetModel.type !=assetModel.type &&
                    (selectedAssetModel.type == ENAssetModelMediaTypeVideo ||
                     assetModel.type == ENAssetModelMediaTypeVideo)) {
                        if (failure) {
                            failure(@"不能同时选择图片和视频");
                        }
                        return;
                    }
            }
        }
        [self.selectedModels addObject:assetModel];
        self.previewButton.highlighted = YES;
        [self.rightBarButtonItem setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedModels.count]];
    }
    if (success) {
        success(assetModel.isSelected?0:self.selectedModels.count);
    }
}
#pragma mark - ENAssetViewCellDelegate

- (void)assetViewCell:(ENAssetViewCell *)assetCell selectPhotoButtonAssetModel:(ENAssetModel *)assetModel selectImageCount:(ENAssetSelectImageCount)selectImageCount{
    
    //空间上传单个图片不能大于10M
    if(self.maxImagesCount==30){
        @autoreleasepool {
            if (@available(iOS 8.0, *)) {
                [[PHImageManager defaultManager] requestImageDataForAsset:assetModel.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    float imageSize = imageData.length; //convert to MB
                    imageSize = imageSize/(1024*1024.0);
                    JZLog(@"选择图片大小：%f",imageSize);
                    if(imageSize>10){
                        [JZAlertHUD showTipTitle:@"不能选择大于10M的图片"];
                    }
                    else
                    {
                        [self selectPhotoButtonAssetModel:assetModel success:^(NSInteger index) {
                            if (selectImageCount) {
                                selectImageCount(index);
                            }
                        } failure:^(NSString *error) {
                            NSLog(@"%@",error);
                            [JZAlertHUD showTipTitle:error];
                        }];
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    } else{
        [self selectPhotoButtonAssetModel:assetModel success:^(NSInteger index) {
            if (selectImageCount) {
                selectImageCount(index);
            }
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
            [JZAlertHUD showTipTitle:error];
        }];
    }
    
}
#pragma mark - 懒加载

- (UICollectionView *)pickerCollectionView{
    if (!_pickerCollectionView) {
        UICollectionViewFlowLayout * collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - (self.columnNumber + 1) * itemPickerMargin) / self.columnNumber;
        collectionViewLayout.itemSize = CGSizeMake(itemWH, itemWH);
        collectionViewLayout.minimumInteritemSpacing = itemPickerMargin;
        collectionViewLayout.minimumLineSpacing = itemPickerMargin;
        
        _pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64-imagePickerBarMargin) collectionViewLayout:collectionViewLayout];
        [_pickerCollectionView registerClass:[ENAssetViewCell class] forCellWithReuseIdentifier:@"ENAssetViewCell"];
        _pickerCollectionView.backgroundColor = [UIColor whiteColor];
        _pickerCollectionView.delegate = self;
        _pickerCollectionView.dataSource = self;
        _pickerCollectionView.alwaysBounceVertical = YES;
    }
    return _pickerCollectionView;
}
- (NSMutableArray *)selectedModels{
    if (!_selectedModels) {
        _selectedModels = [@[] mutableCopy];
    }
    return _selectedModels;
}
- (ENTitleView *)enTitleView{
    if (!_enTitleView) {
        _enTitleView = [[ENTitleView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200/2, self.navigationController.navigationBar.frame.size.height-40/2, 200, 40)];
    }
    return _enTitleView;
}
- (UIButton *)previewButton{
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(previewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _previewButton.highlighted = NO;
    }
    return _previewButton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    NSLog(@"%s--------被销毁",__func__);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
