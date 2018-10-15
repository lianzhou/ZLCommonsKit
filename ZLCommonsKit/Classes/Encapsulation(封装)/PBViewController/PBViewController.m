//
//  PBViewController.m
//  PhotoBrowser
//


#import "PBViewController.h"
#import "PBImageScrollerViewController.h"
#import "UIView+PBSnapshot.h"
#import "PBImageScrollView.h"
#import "PBImageScrollView+internal.h"
#import "PBPresentAnimatedTransitioningController.h"
#import "ALActionSheetView.h"
#import "ENPhotoLibraryManager.h"
#import "JZAlertHUD.h"
#import <SDWebImage/SDWebImageManager.h>
#import "JZContext.h"
#import "JZSystemUtils.h"
#import "Masonry.h"

static const NSUInteger reusable_page_count = 3;

@interface PBViewController () <
    UIPageViewControllerDataSource,
    UIPageViewControllerDelegate,
    UIViewControllerTransitioningDelegate
>

@property (nonatomic, strong) NSArray<PBImageScrollerViewController *> *reusableImageScrollerViewControllers;
@property (nonatomic, assign, readwrite) NSInteger numberOfPages;
@property (nonatomic, assign, readwrite) NSInteger currentPage;
@property (nonatomic, assign, readwrite) NSInteger startPage;

@property (nonatomic, strong) UILabel *indicatorLabel;
@property (nonatomic, strong) UIButton *originalButton;

@property (nonatomic, strong) UIView *blurBackgroundView;

@property (nonatomic, strong) PBPresentAnimatedTransitioningController *transitioningController;
@property (nonatomic, assign) CGFloat velocity;

@property (nonatomic, assign) CGRect contentsRect;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, weak) UIView *lastThumbView;



@property (nonatomic,strong) NSMutableDictionary * photoDictionaryM;

@end

@implementation PBViewController

- (void)dealloc {
    NSLog(@"~~~~~~~~~~~%s~~~~~~~~~~~", __FUNCTION__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - respondsToSelector

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style
                  navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation
                                options:(NSDictionary *)options {
    NSMutableDictionary *dict = [(options ?: @{}) mutableCopy];
    [dict setObject:@(20) forKey:UIPageViewControllerOptionInterPageSpacingKey];
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:navigationOrientation
                                  options:dict];
    if (!self) {
        return nil;
    }
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.transitioningDelegate = self;
    _contentsRect = CGRectMake(0, 0, 1, 1);
    _blurBackground = YES;
    _hideThumb = YES;
    self.pb_select = NO;
    self.photoDictionaryM = [@{} mutableCopy];
    
    [JZContext shareInstance].currentViewController = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setNumberOfPages];

    [self _setCurrentPresentPageAnimated: NO];

    [self _addIndicator];

    [self _addBlurBackgroundView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMWPhotoLoadingDidEndNotification:) name:@"ENPHOTO_LOADING_DID_END_NOTIFICATION" object:nil];

    
    self.dataSource = self;
    self.delegate = self;
    
    [self _setupTransitioningController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self _updateIndicator];
    [self _updateBlurBackgroundView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.pb_delegate && [self.pb_delegate respondsToSelector:@selector(viewControllerWillDisappear:)]) {
        
        [self.pb_delegate viewControllerWillDisappear:self];
    }
}

#pragma mark - Public method


- (void)setPb_startPage:(NSInteger)pb_startPage {
    _startPage = pb_startPage;
    _pb_startPage = pb_startPage;
    _currentPage = pb_startPage;
}

- (void)setStartPage:(NSInteger)startPage {
    self.pb_startPage = startPage;
}

- (void)reload {
    [self reloadWithCurrentPage:0];
}
- (void)reloadWithCurrentPage:(NSInteger)index animated:(BOOL)animated{
    
    [self.photoDictionaryM removeAllObjects];
    
    self.pb_startPage = index;
    [self _setNumberOfPages];
    NSAssert(index < _numberOfPages, @"index(%@) beyond boundary.", @(index));
    [self _setCurrentPresentPageAnimated:animated];
    [self _updateIndicator];
    [self _updateBlurBackgroundView];
    [self _hideThumbView];
}
- (void)reloadWithCurrentPage:(NSInteger)index {
    [self reloadWithCurrentPage:index animated:YES];
}

#pragma mark - 私有函数

- (void)_setNumberOfPages {
    if ([self.pb_dataSource conformsToProtocol:@protocol(PBViewControllerDataSource)] &&
        [self.pb_dataSource respondsToSelector:@selector(numberOfPagesInViewController:)]) {
        self.numberOfPages = [self.pb_dataSource numberOfPagesInViewController:self];
    }
}

- (void)_setCurrentPresentPageAnimated:(BOOL)animated {
    self.currentPage = 0 < self.currentPage && self.currentPage < self.numberOfPages ? self.currentPage : 0;
    PBImageScrollerViewController *firstImageScrollerViewController = [self _imageScrollerViewControllerForPage:self.currentPage];
    [self setViewControllers:@[firstImageScrollerViewController] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    [firstImageScrollerViewController reloadData];
}

- (void)_addIndicator {
    [self.view addSubview:self.originalButton];

    if (self.numberOfPages == 1) {
        return;
    }

    [self.view addSubview:self.indicatorLabel];
    self.indicatorLabel.layer.zPosition = 1024;
}

- (void)_updateIndicator {
    
    
    if (self.originalButton) {

        [self.originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
            make.size.mas_equalTo(CGSizeMake(100, 35));
        }];
    }
    
    if (!self.indicatorLabel) {
        return;
    }
    NSString *indicatorText = [NSString stringWithFormat:@"%@/%@", @(self.currentPage + 1), @(self.numberOfPages)];
    self.indicatorLabel.text = indicatorText;
    [self.indicatorLabel sizeToFit];
    if ([JZSystemUtils iPhoneXDevice]) {
        self.indicatorLabel.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0f,
                                                  44);
    }else {
        self.indicatorLabel.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0f,
                                                 20);
    }
    
    
}

- (void)_addBlurBackgroundView {
    [self.view addSubview:self.blurBackgroundView];
    [self.view sendSubviewToBack:self.blurBackgroundView];
}

- (void)_updateBlurBackgroundView {
    self.blurBackgroundView.frame = self.view.bounds;
}

- (void)_hideStatusBarIfNeeded {
    self.presentingViewController.view.window.windowLevel = UIWindowLevelStatusBar;
}

- (void)_showStatusBarIfNeeded {
    self.presentingViewController.view.window.windowLevel = UIWindowLevelNormal;
}

- (PBImageScrollerViewController *)_imageScrollerViewControllerForPage:(NSInteger)page {
    if (page > self.numberOfPages - 1 || page < 0) {
        return nil;
    }
    
    PBImageScrollerViewController *imageScrollerViewController = self.reusableImageScrollerViewControllers[page % reusable_page_count];
    
    if (!self.pb_dataSource) {
        [NSException raise:@"Must implement `PBViewControllerDataSource` protocol." format:@""];
    }
    imageScrollerViewController.page = page;

    __weak typeof(self) weak_self = self;
    __weak typeof(imageScrollerViewController) weak_imageScrollerViewController = imageScrollerViewController;

    imageScrollerViewController.imageScrollView.handleLongPressActionInImageScrollView = ^{
        __strong typeof(weak_self) strong_self = weak_self;
        __strong typeof(weak_imageScrollerViewController) strong_imageScrollerViewController = weak_imageScrollerViewController;
        if (strong_self.pb_delegate && [strong_self.pb_delegate respondsToSelector:@selector(viewController:didLongPressedPageAtIndex:presentedImage:)]) {
            [strong_self.pb_delegate viewController:strong_self didLongPressedPageAtIndex:page presentedImage:strong_imageScrollerViewController.imageScrollView.imageView.image];
        }else{
            ALActionSheetView * actionSheetView = [[ALActionSheetView alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存"] handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {//保存
                    ENPhoto * photo = [strong_self photoForPageAtIndex:page];
                    [strong_self savePhotoWithImage:photo];
                }
            }];
            [actionSheetView show];
        }        
    };

    imageScrollerViewController.imageScrollView.handleSingleTapActionInImageScrollView = ^{
        __strong typeof(weak_self) strong_self = weak_self;
        __strong typeof(weak_imageScrollerViewController) strong_imageScrollerViewController = weak_imageScrollerViewController;
        if (strong_self.pb_delegate && [strong_self.pb_delegate respondsToSelector:@selector(viewController:didSingleTapedPageAtIndex:presentedImage:)]) {
            [strong_self.pb_delegate viewController:strong_self didSingleTapedPageAtIndex:page presentedImage:strong_imageScrollerViewController.imageScrollView.imageView.image];
        }else{
            [strong_self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    imageScrollerViewController.imageScrollerViewSelectImage = ^(ENPhoto *photo, void (^imageScrollerViewSelectImageCount)(NSInteger index)) {
        __strong typeof(weak_self) strong_self = weak_self;
        if ([strong_self.pb_delegate respondsToSelector:@selector(viewController:didSelectPageAtIndex:didSelectPageAtPhoto:success:failure:)]) {
            [strong_self.pb_delegate viewController:strong_self didSelectPageAtIndex:page didSelectPageAtPhoto:photo success:imageScrollerViewSelectImageCount failure:^(NSString * _Nullable error) {
                NSLog(@"%@",error);
            }];
        }   
    };
    

    if ([self.pb_dataSource conformsToProtocol:@protocol(PBViewControllerDataSource)]) {
        if ([self.pb_dataSource respondsToSelector:@selector(viewController:photoForPageAtIndex:)]) {
            ENPhoto * photo = [self photoForPageAtIndex:page];
            imageScrollerViewController.photo = photo;
        }
    }
    
    return imageScrollerViewController;
}




- (void)savePhotoWithImage:(ENPhoto *)photo{
    [photo loadUnderlyingImageAndNotify];
    ENPhotoLibraryManager * photoLibraryManager = [ENPhotoLibraryManager manager];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (photo.underlyingImage) {
            [photoLibraryManager savePhotoWithImage:photo.underlyingImage completion:^(ENAssetModel *assetModel) {
                [JZAlertHUD showTipTitle:@"保存成功"];
            } failure:^(NSString *error) {
                [JZAlertHUD showTipTitle:error];
            }];
        }else if(photo.photoURL){
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:photo.photoURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [photoLibraryManager savePhotoWithImage:image completion:^(ENAssetModel *assetModel) {
                    [JZAlertHUD showTipTitle:@"保存成功"];
                } failure:^(NSString *error) {
                    [JZAlertHUD showTipTitle:error];
                }];
            }];
        }
        
        
    });
}
- (void)_setupTransitioningController {
    __weak typeof(self) weak_self = self;
    self.transitioningController.willPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _willPresent];
    };
    self.transitioningController.onPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _onPresent];
    };
    self.transitioningController.didPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _didPresented];
    };
    self.transitioningController.willDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _willDismiss];
    };
    self.transitioningController.onDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _onDismiss];
    };
    self.transitioningController.didDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _didDismiss];
    };
}

- (void)_willPresent {
    PBImageScrollerViewController *currentScrollViewController = self.currentScrollViewController;
    currentScrollViewController.view.alpha = 0;
    self.blurBackgroundView.alpha = 0;
    [currentScrollViewController changeSelectViewAlpha:0.0];

    UIView *thumbView = self.currentThumbView;
    if (!thumbView) {
        return;
    }
    [self _hideThumbView];

    currentScrollViewController.view.alpha = 1;
    PBImageScrollView *imageScrollView = currentScrollViewController.imageScrollView;
    UIImageView *imageView = imageScrollView.imageView;
    imageView.image = self.currentThumbImage;
    UIImage *image = imageView.image;

    // 长图
    if (self.thumbClippedToTop) {
        CGRect fromFrame = [thumbView.superview convertRect:thumbView.frame toView:self.view];
        CGRect originFrame = [imageView.superview convertRect:imageView.frame toView:self.view];
        // 长微博长图只取屏幕高度
        if (CGRectGetHeight(originFrame) > CGRectGetHeight(imageScrollView.bounds)) {
            originFrame.size.height = CGRectGetHeight(imageScrollView.bounds);
            
            CGFloat scale = CGRectGetWidth(fromFrame) / CGRectGetWidth(imageScrollView.bounds);
            // centerX
            imageScrollView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMidY(imageScrollView.frame));
            // height
            CGRect newFrame = imageScrollView.frame;
            newFrame.size.height = CGRectGetHeight(fromFrame) / scale;
            imageScrollView.frame = newFrame;
            // layer animation
            [imageScrollView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
            // centerY
            imageScrollView.center = CGPointMake(CGRectGetMidX(imageScrollView.frame), CGRectGetMidY(fromFrame));
        }
        // 长图但是长度不超过屏幕
        else {
            imageView.frame = fromFrame;
            CGFloat heightRatio = (image.size.width / image.size.height) * (CGRectGetHeight(imageView.bounds) / CGRectGetWidth(imageView.bounds));
            imageView.layer.contentsRect = CGRectMake(0, 0, 1, heightRatio);
            imageView.contentMode = UIViewContentModeScaleToFill;
        }
        
        // record
        self.originFrame = originFrame;
    }
    // 宽图 or 等比例
    else {
        // record
        self.originFrame = imageView.frame;
        CGRect frame = [thumbView.superview convertRect:thumbView.frame toView:self.view];
        imageView.frame = frame;
        imageView.contentMode = thumbView.contentMode;
        imageView.clipsToBounds = thumbView.clipsToBounds;
        imageView.backgroundColor = thumbView.backgroundColor;
    }
}

- (void)_onPresent {
    PBImageScrollerViewController *currentScrollViewController = self.currentScrollViewController;
    self.blurBackgroundView.alpha = 1;
    [currentScrollViewController changeSelectViewAlpha:1.0f];

    [self _hideStatusBarIfNeeded];
    
    if (!self.currentThumbView) {
        currentScrollViewController.view.alpha = 1;
        return;
    }
    
    PBImageScrollView *imageScrollView = currentScrollViewController.imageScrollView;
    UIImageView *imageView = imageScrollView.imageView;
    CGRect originFrame = [imageView.superview convertRect:imageView.frame toView:self.view];
    
    if (CGRectEqualToRect(originFrame, CGRectZero)) {
        currentScrollViewController.view.alpha = 1;
        return;
    }

    // 长图
    if (self.thumbClippedToTop) {
        // 长微博长图
        if (CGRectGetHeight(self.originFrame) > CGRectGetHeight(imageScrollView.bounds)) {
            imageScrollView.frame = self.originFrame;
            [imageScrollView.layer setValue:@(1) forKeyPath:@"transform.scale"];
        }
        // 长图但是长度不超过屏幕
        else {
            imageView.frame = self.originFrame;
            imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
        }
    }
    // 宽图 or 等比例
    else {
        imageView.frame = self.originFrame;
    }
}

- (void)_didPresented {
    self.currentScrollViewController.view.alpha = 1;
    self.currentScrollViewController.imageScrollView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.currentScrollViewController reloadData];
    [self _hideIndicator];
}

/// pic  :    正方形 | 长方形(w>h) | 长方形(h>w)
/// view :    正方形 | 长方形(w>h) | 长方形(h>w)
/// 3 * 3 = 9 种情况
- (void)_willDismiss {
    PBImageScrollerViewController *currentScrollViewController = self.currentScrollViewController;
    PBImageScrollView *imageScrollView = currentScrollViewController.imageScrollView;
    // 还原 zoom.
    if (imageScrollView.zoomScale != 1) {
        [imageScrollView setZoomScale:1 animated:NO];
    }
    
    // 停止播放动画
    NSArray<UIImage *> *images = imageScrollView.imageView.image.images;

    if (images && images.count > 1) {
        UIImage *newImage = images.firstObject;
        imageScrollView.imageView.image = nil;
        imageScrollView.imageView.image = newImage;
    }
    
    // 有 thumbView
    if (self.currentThumbView) {
        // 裁剪过图片
        if (self.thumbClippedToTop) {
            // 记录 contentsRect
            UIImage *image = imageScrollView.imageView.image;
            CGFloat heightRatio = (image.size.width / image.size.height) * (CGRectGetHeight(self.currentThumbView.bounds) / CGRectGetWidth(self.currentThumbView.bounds));
            self.contentsRect = CGRectMake(0, 0, 1, heightRatio);
            
            // 图片长度超过屏幕(长微博形式)，为裁剪动画做准备
            if (imageScrollView.contentSize.height > CGRectGetHeight(imageScrollView.bounds)) {
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                CGRect frame = imageScrollView.imageView.frame;
                imageScrollView.imageView.layer.anchorPoint = CGPointMake(0.5, self.isPullup ? 1 : 0);
                imageScrollView.imageView.frame = frame;
                [CATransaction commit];
            }
        }
        // 点击推出，需要先回到顶部
        if (self.dismissByClick) {
            [imageScrollView _scrollToTopAnimated:NO];
        }
    }
    // 无 thumbView
    else {
        // 点击退出模式，截取当前屏幕并替换图片
        if (self.dismissByClick) {
            UIImage *image = [self.view pb_snapshotAfterScreenUpdates:NO];
            imageScrollView.imageView.image = image;
        }
    }
}

- (void)_onDismiss {
    [self _showStatusBarIfNeeded];
    self.blurBackgroundView.alpha = 0;
    
    PBImageScrollerViewController *currentScrollViewController = self.currentScrollViewController;
    [currentScrollViewController changeSelectViewAlpha:0.0];

    PBImageScrollView *imageScrollView = currentScrollViewController.imageScrollView;
    UIImageView *imageView = imageScrollView.imageView;
    UIImage *currentImage = imageView.image;
    // 图片未加载，默认 CrossDissolve 动画。
    if (!currentImage) {
        return;
    }
    
    // present 之前显示的图片视图。
    UIView *thumbView = self.currentThumbView;
    CGRect destFrame = CGRectZero;
    if (thumbView) {
        // 还原到起始位置然后 dismiss.
        destFrame = [thumbView.superview convertRect:thumbView.frame toView:currentScrollViewController.view];
        // 把 contentInset 考虑进来。
        CGFloat verticalInset = imageScrollView.contentInset.top + imageScrollView.contentInset.bottom;
        destFrame = CGRectMake(
           CGRectGetMinX(destFrame),
           CGRectGetMinY(destFrame) - verticalInset,
           CGRectGetWidth(destFrame),
           CGRectGetHeight(destFrame)
       );
        
        // 同步裁剪图片位置
        imageView.layer.contentsRect = self.contentsRect;
        
        // 裁剪过图片的长微博
        if (self.thumbClippedToTop && imageScrollView.contentSize.height > CGRectGetHeight(imageScrollView.bounds)) {
            CGFloat height = CGRectGetHeight(thumbView.bounds) / CGRectGetWidth(thumbView.bounds) * CGRectGetWidth(imageView.bounds);
            if (isnan(height)) {
                height = CGRectGetWidth(imageView.bounds);
            }
            
            CGRect newFrame = imageView.frame;
            newFrame.size.height = height;
            imageView.frame = newFrame;
            imageView.center = CGPointMake(CGRectGetMidX(destFrame), CGRectGetMinY(destFrame) + (self.isPullup ? CGRectGetHeight(thumbView.bounds) : 0));

            CGFloat scale = CGRectGetWidth(thumbView.bounds) / CGRectGetWidth(imageView.bounds) * imageScrollView.zoomScale;
            [imageView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        } else {
            imageView.frame = destFrame;
        }
    } else {
        if (self.dismissByClick) {
            // 非滑动退出，点击中间
            destFrame = CGRectMake(CGRectGetWidth(imageScrollView.bounds) / 2, CGRectGetHeight(imageScrollView.bounds) / 2, 0, 0);
            // 图片渐变
            imageScrollView.alpha = 0;
        } else {
            // 移动到屏幕外然后 dismiss.
            CGFloat width = CGRectGetWidth(imageScrollView.imageView.bounds);
            CGFloat height = CGRectGetHeight(imageScrollView.imageView.bounds);
            if (self.isPullup) {
                // 向上
                destFrame = CGRectMake(0, -height, width, height);
            } else {
                // 向下
                destFrame = CGRectMake(0, CGRectGetHeight(imageScrollView.bounds), width, height);
            }
        }
        imageView.frame = destFrame;
    }
}

- (void)_didDismiss {
    self.currentScrollViewController.imageScrollView.imageView.layer.anchorPoint = CGPointMake(0.5, 0);
    self.currentThumbView.hidden = NO;
    [JZContext shareInstance].currentViewController = self.presentingViewController;
}

- (void)_hideIndicator {
    if (!self.indicatorLabel || 0 == self.indicatorLabel.alpha) {
        return;
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.originalButton.alpha = 0;
//    });
    
    ENPhoto * photo = [self photoForPageAtIndex:self.currentPage];
    if (photo.isDownLoad) {
        self.originalButton.alpha = 0;
    }else{
        self.originalButton.alpha = 1;
    }
    [UIView animateWithDuration:0.25 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        self.indicatorLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_showIndicator {
    if (!self.indicatorLabel || 1 == self.indicatorLabel.alpha) {
        return;
    }

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        self.indicatorLabel.alpha = 1;
//        self.originalButton.alpha = 1;

    } completion:^(BOOL finished) {
    }];
}

- (void)_hideThumbView {
    if (!_hideThumb) {
        return;
    }
    NSLog(@"%s", __FUNCTION__);
    self.lastThumbView.hidden = NO;
    UIView *currentThumbView = self.currentThumbView;
    currentThumbView.hidden = YES;
    self.lastThumbView = currentThumbView;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(PBImageScrollerViewController *)viewController {
    return [self _imageScrollerViewControllerForPage:viewController.page - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(PBImageScrollerViewController *)viewController {
    return [self _imageScrollerViewControllerForPage:viewController.page + 1];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [self _showIndicator];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    PBImageScrollerViewController *imageScrollerViewController = pageViewController.viewControllers.firstObject;
    self.currentPage = imageScrollerViewController.page;
    [self _updateIndicator];
    [self _hideIndicator];
    [self _hideThumbView];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self.transitioningController prepareForPresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self.transitioningController prepareForDismiss];
}

#pragma mark - Accessor

- (NSArray<PBImageScrollerViewController *> *)reusableImageScrollerViewControllers {
    if (!_reusableImageScrollerViewControllers) {
        NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:reusable_page_count];
        for (NSInteger index = 0; index < reusable_page_count; index++) {
            PBImageScrollerViewController *imageScrollerViewController = [[PBImageScrollerViewController alloc] init];
            imageScrollerViewController.pb_select =  self.pb_select;
            imageScrollerViewController.page = index;
            __weak typeof(self) weak_self = self;
            __weak typeof(imageScrollerViewController) weak_imageScrollerViewController = imageScrollerViewController;
            imageScrollerViewController.imageScrollView.contentOffSetVerticalPercentHandler = ^(CGFloat percent) {
                __strong typeof(weak_self) strong_self = weak_self;
                __strong typeof(weak_imageScrollerViewController) strong_imageScrollerViewController = weak_imageScrollerViewController;
                CGFloat alpha = 1.0f - percent * 4;
                if (alpha < 0) {
                    alpha = 0;
                }
                [strong_imageScrollerViewController changeSelectViewAlpha:alpha];
                strong_self.blurBackgroundView.alpha = alpha;
            };
            imageScrollerViewController.imageScrollView.didEndDraggingInProperpositionHandler = ^(CGFloat velocity){
                __strong typeof(weak_self) strong_self = weak_self;
                strong_self.velocity = velocity;
                if (strong_self.exit) {
                    strong_self.exit(strong_self);
                } else {
                    [strong_self dismissViewControllerAnimated:YES completion:nil];
                }
            };
            
            [controllers addObject:imageScrollerViewController];
        }
        _reusableImageScrollerViewControllers = [[NSArray alloc] initWithArray:controllers];
    }
    return _reusableImageScrollerViewControllers;
}
- (void)downLoadOriginalImage:(UIButton *)sender {
    [JZAlertHUD showHUDTitle:@"" toView:self.view];
    
    ENPhoto * photo = [self photoForPageAtIndex:self.currentPage];
    photo.isDownLoad = YES;
    [photo _performLoadUnderlyingImageAndNotifyWithOriginalWebURL:photo.photoURL];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.originalButton.alpha = 0;
    });
}

- (ENPhoto *)photoForPageAtIndex:(NSInteger)index{
    
    NSNumber *numberKey = [NSNumber numberWithInteger:index];
    if ([self.photoDictionaryM.allKeys containsObject:numberKey]) {
        ENPhoto * photo = [self.photoDictionaryM objectForKey:numberKey];
        return photo;
    }else{
        ENPhoto * photo = [self.pb_dataSource viewController:self photoForPageAtIndex:index];
        [self.photoDictionaryM setObject:photo forKey:numberKey];
        return photo;
    }
    
}


- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    
    
    
    [JZAlertHUD hideHUD:self.view];
}
- (UILabel *)indicatorLabel {
    if (!_indicatorLabel) {
        _indicatorLabel = [UILabel new];
        _indicatorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.textColor = [UIColor whiteColor];
    }
    return _indicatorLabel;
}
- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_originalButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
        [_originalButton setTitle:@"查看原图" forState:UIControlStateNormal];
        _originalButton.layer.masksToBounds = YES;
        _originalButton.layer.cornerRadius = 4.0f;
        _originalButton.layer.borderWidth = 1.0f;
        _originalButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        [_originalButton addTarget:self action:@selector(downLoadOriginalImage:) forControlEvents:UIControlEventTouchUpInside];
        _originalButton.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    return _originalButton;
}
- (UIView *)blurBackgroundView {
//    if (self.blurBackground) {
//        if (!_blurBackgroundView) {
//            _blurBackgroundView = [[UIToolbar alloc] initWithFrame:self.view.bounds];
//            ((UIToolbar *)_blurBackgroundView).barStyle = UIBarStyleBlack;
//            ((UIToolbar *)_blurBackgroundView).translucent = YES;
//            _blurBackgroundView.clipsToBounds = YES;
//            _blurBackgroundView.multipleTouchEnabled = NO;
//            _blurBackgroundView.userInteractionEnabled = NO;
//        }
//    } else {
        if (!_blurBackgroundView) {
            _blurBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            _blurBackgroundView.backgroundColor = [UIColor blackColor];
            _blurBackgroundView.clipsToBounds = YES;
            _blurBackgroundView.multipleTouchEnabled = NO;
            _blurBackgroundView.userInteractionEnabled = NO;
        }
//    }
    return _blurBackgroundView;
}

- (PBImageScrollerViewController *)currentScrollViewController {
    return self.reusableImageScrollerViewControllers[self.currentPage % reusable_page_count];
}

- (UIView *)currentThumbView {
    if (!self.pb_dataSource) {
        return nil;
    }
    if (![self.pb_dataSource conformsToProtocol:@protocol(PBViewControllerDataSource)]) {
        return nil;
    }
    if (![self.pb_dataSource respondsToSelector:@selector(thumbViewForPageAtIndex:)]) {
        return  nil;
    }
    return [self.pb_dataSource thumbViewForPageAtIndex:self.currentPage];
}

- (UIImage *)currentThumbImage {
    UIView *currentThumbView = self.currentThumbView;
    if (!currentThumbView) {
        return nil;
    }
    if ([currentThumbView isKindOfClass:[UIImageView class]]) {
        return ((UIImageView *)self.currentThumbView).image;
    }
    if (currentThumbView.layer.contents) {
        return [[UIImage alloc] initWithCGImage:(__bridge CGImageRef _Nonnull)(currentThumbView.layer.contents)];
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    UIView *currentThumbView = self.currentThumbView;
    if (!currentThumbView) {
        return NO;
    }
    if ([currentThumbView isKindOfClass:[UIImageView class]]) {
        return currentThumbView.layer.contentsRect.size.height < 1;
    }
    for (UIView * subView in currentThumbView.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            if (subView.layer.contentsRect.size.height < 1) {
                return YES;
            }
        }else{
            for (UIView * subsubView in subView.subviews) {
                if ([subsubView isKindOfClass:[UIImageView class]]) {
                    if (subsubView.layer.contentsRect.size.height < 1) {
                        return YES;
                    }
                }
            }
        }
    }
    return currentThumbView.layer.contentsRect.size.height < 1;
}

- (BOOL)dismissByClick {
    if (0 != self.velocity) {
        return NO;
    }
    PBImageScrollView *imageScrollView = self.currentScrollViewController.imageScrollView;
    if (imageScrollView.contentOffset.y < 0) {
        return NO;
    }
    if (imageScrollView.contentInset.top < 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isPullup {
    return 0 < self.velocity;
}

- (PBPresentAnimatedTransitioningController *)transitioningController {
    if (!_transitioningController) {
        _transitioningController = [PBPresentAnimatedTransitioningController new];
    }
    return _transitioningController;
}

@end
