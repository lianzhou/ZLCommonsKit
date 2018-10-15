//
//  PBImageScrollView.m
//  PhotoBrowser


#import "PBImageScrollView.h"
#import "PBImageScrollView+internal.h"

#define system_version ([UIDevice currentDevice].systemVersion.doubleValue)
#define observe_keypath_image @"image"

@interface PBImageScrollView ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, weak) id <NSObject> notification;
/// velocity: > 0 up, < 0 dwon, == 0 others(no swipe, e.g. tap).
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) BOOL dismissing;


/// Gestures
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation PBImageScrollView

- (void)dealloc {
    [self _removeObserver];
    [self _removeNotificationIfNeeded];
    NSLog(@"~~~~~~~~~~~%s~~~~~~~~~~~", __FUNCTION__);
}

#pragma mark - respondsToSelector

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    self.frame = [UIScreen mainScreen].bounds;
    self.multipleTouchEnabled = YES;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = YES;
    self.alwaysBounceVertical = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 2.5f;
    self.delegate = self;
    
    [self addSubview:self.imageView];
    [self _addObserver];
    [self _addNotificationIfNeeded];
    [self _addGestures];
    
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self _updateFrame];
    [self _recenterImage];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (!self.window) {
        [self _updateUserInterfaces];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:observe_keypath_image]) {
        return;
    }
    if (![object isEqual:self.imageView]) {
        return;
    }
    if (!self.imageView.image) {
        return;
    }

    [self _updateUserInterfaces];
}

#pragma mark - Internal Methods

- (void)_handleZoomForLocation:(CGPoint)location {
    CGPoint touchPoint = [self.superview convertPoint:location toView:self.imageView];
    if (self.zoomScale > 1) {
        [self setZoomScale:1 animated:YES];
    } else if (self.maximumZoomScale > 1) {
        CGFloat newZoomScale = self.maximumZoomScale;
        CGFloat horizontalSize = CGRectGetWidth(self.bounds) / newZoomScale;
        CGFloat verticalSize = CGRectGetHeight(self.bounds) / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - horizontalSize / 2.0f, touchPoint.y - verticalSize / 2.0f, horizontalSize, verticalSize) animated:YES];
    }
}

- (void)_scrollToTopAnimated:(BOOL)animated {
    CGPoint offset = self.contentOffset;
    offset.y = -self.contentInset.top;
    [self setContentOffset:offset animated:animated];
}

#pragma mark - Private methods

- (void)_addObserver {
    [self.imageView addObserver:self forKeyPath:observe_keypath_image options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_removeObserver {
    [self.imageView removeObserver:self forKeyPath:observe_keypath_image];
}

- (void)_addNotificationIfNeeded {
    if (system_version >= 8.0) {
        return;
    }
    
    __weak typeof(self) weak_self = self;
    self.notification = [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self _updateFrame];
        [strong_self _recenterImage];
    }];
}

- (void)_removeNotificationIfNeeded {
    if (system_version >= 8.0) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self.notification];
}
- (void)_addGestures {
    [self addGestureRecognizer:self.longPressGestureRecognizer];
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self addGestureRecognizer:self.singleTapGestureRecognizer];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
}
- (void)_updateUserInterfaces {
    [self setZoomScale:1.0f animated:YES];
    [self _updateFrame];
    [self _recenterImage];
    [self _setMaximumZoomScale];
    self.alwaysBounceVertical = YES;
}

- (void)_updateFrame {
    self.frame = [UIScreen mainScreen].bounds;
    
    UIImage *image = self.imageView.image;
    if (!image) {
        return;
    }
    
    CGSize properSize = [self _properPresentSizeForImage:image];
    self.imageView.frame = CGRectMake(0, 0, properSize.width, properSize.height);
    self.contentSize = properSize;
}

- (CGSize)_properPresentSizeForImage:(UIImage *)image {
    CGFloat ratio = CGRectGetWidth(self.bounds) / image.size.width;
    return CGSizeMake(CGRectGetWidth(self.bounds), ceil(ratio * image.size.height));
}

- (void)_recenterImage {
    CGFloat contentWidth = self.contentSize.width;
    CGFloat horizontalDiff = CGRectGetWidth(self.bounds) - contentWidth;
    CGFloat horizontalAddition = horizontalDiff > 0.f ? horizontalDiff : 0.f;
    
    CGFloat contentHeight = self.contentSize.height;
    CGFloat verticalDiff = CGRectGetHeight(self.bounds) - contentHeight;
    CGFloat verticalAdditon = verticalDiff > 0 ? verticalDiff : 0.f;

    self.imageView.center = CGPointMake((contentWidth + horizontalAddition) / 2.0f, (contentHeight + verticalAdditon) / 2.0f);
}

- (void)_setMaximumZoomScale {
    CGSize imageSize = self.imageView.image.size;
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    self.maximumZoomScale = MAX(MIN(imageSize.width / selfWidth, imageSize.height / selfHeight), 3.0f);
//    if (imageSize.width <= selfWidth && imageSize.height <= selfHeight) {
//        self.maximumZoomScale = 1.0f;
//    } else {
//        self.maximumZoomScale = MAX(MIN(imageSize.width / selfWidth, imageSize.height / selfHeight), 3.0f);
//    }
}

/// Only + percent.
- (CGFloat)_contentOffSetVerticalPercent {
    return fabs([self _rawContentOffSetVerticalPercent]);
}

/// +/- percent.
- (CGFloat)_rawContentOffSetVerticalPercent {
    CGFloat percent = 0;
    
    CGFloat contentHeight = self.contentSize.height;
    CGFloat scrollViewHeight = CGRectGetHeight(self.bounds);
    CGFloat offsetY = self.contentOffset.y;
    CGFloat factor = 1.3;

    if (offsetY < 0) {
        percent = MIN(offsetY / (scrollViewHeight * factor), 1.0f);
    } else {
        if (contentHeight < scrollViewHeight) {
            percent = MIN(offsetY / (scrollViewHeight * factor), 1.0f);
        } else {
            offsetY += scrollViewHeight;
            CGFloat contentHeight = self.contentSize.height;
            if (offsetY > contentHeight) {
                percent = MIN((offsetY - contentHeight) / (scrollViewHeight * factor), 1.0f);
            }
        }
    }

    return percent;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dismissing) {
        return;
    }
    if (!self.contentOffSetVerticalPercentHandler) {
        return;
    }
    self.contentOffSetVerticalPercentHandler([self _contentOffSetVerticalPercent]);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self _recenterImage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        return;
    }
    
    // 停止时有加速度不够取消操作
    // 如果距离够，不取消
    CGFloat rawPercent = [self _rawContentOffSetVerticalPercent];
    CGFloat velocity = self.velocity;
    if (fabs(rawPercent) <= 0) {
        return;
    }
    NSLog(@"rawPercent: %@", @(rawPercent));
    NSLog(@"velocity: %@", @(velocity));
    if (fabs(rawPercent) < 0.15f && fabs(velocity) < 1) {
        return;
    }
    // 停止时有相反方向滑动操作时取消退出操作
    if (rawPercent * velocity < 0) {
        return;
    }
    // 如果是长图，并且是向上滑动，需要滑到底部以下才能结束
    if (self.contentSize.height > CGRectGetHeight(self.bounds)) {
        if (velocity > 0) {
            // 向上滑动
            // 速度过快且滑过区域较小，防止误操作，取消
            if (velocity > 2.8 && rawPercent < 0.1) {
                return;
            }
            if (self.contentOffset.y + CGRectGetHeight(self.bounds) <= self.contentSize.height) {
                return;
            }
        } else {
            // 向下滑动
            // 速度过快，防止误操作，取消
            if (fabs(velocity) > 2.8) {
                return;
            }
            if (self.contentOffset.y > 0) {
                return;
            }
        }
    }
    if (self.didEndDraggingInProperpositionHandler) {
        // 取消回弹效果，所以计算 imageView 的 frame 的时候需要注意 contentInset.
        scrollView.bounces = NO;
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        self.didEndDraggingInProperpositionHandler(self.velocity);
        self.dismissing = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.velocity = velocity.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.dismissing) {
        return;
    }
    if (scrollView.zoomScale < 1) {
        [scrollView setZoomScale:1.0f animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    [self refreshScrollViewContentSize];
//}
#pragma mark - Actions

- (void)_handleSingleTapAction:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (!self.handleSingleTapActionInImageScrollView) {
        return;
    }
    self.handleSingleTapActionInImageScrollView();
}

- (void)_handleDoubleTapAction:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint location = [sender locationInView:self];
    [self _handleZoomForLocation:location];
}

- (void)_handleLongPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (!self.handleLongPressActionInImageScrollView) {
            return;
        }
        self.handleLongPressActionInImageScrollView();
    }
 
}

#pragma mark - 懒加载
- (UITapGestureRecognizer *)singleTapGestureRecognizer {
    if (!_singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSingleTapAction:)];
    }
    return _singleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTapAction:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPressAction:)];
        _longPressGestureRecognizer.minimumPressDuration = 1;
    }
    return _longPressGestureRecognizer;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
