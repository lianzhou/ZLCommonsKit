//
//  PBImageScrollerViewController.m
//  PhotoBrowser

#import "PBImageScrollerViewController.h"
#import "PBImageScrollView.h"
#import "PBImageScrollView+internal.h"
#import <Masonry/Masonry.h>
#import "UIImage+Picker.h"
#import "NSBundle+JZCommonsKit.h"
#import "UIImage+YYAdd.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PBImageScrollerViewController ()
@property (nonatomic, strong, readwrite) PBImageScrollView *imageScrollView;
@property (nonatomic, weak, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) CAShapeLayer *progressLayer;
@property (nonatomic, assign) BOOL dismissing;

@property(nonatomic,strong)UIButton *selectPhotoButton;
@property(nonatomic,strong)UIImageView * selectImageView;
@property(nonatomic,strong)UILabel * selectLabel;
@property(nonatomic,strong)UIImageView *videoIndicator;

@property(nonatomic,strong)UIButton *playButton;

@property(nonatomic,strong) MPMoviePlayerViewController *currentVideoPlayerViewController;


@end

@implementation PBImageScrollerViewController

- (void)dealloc {
    NSLog(@"PBImageScrollerViewController %s~~~~~~~~~~~", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ENPHOTO_LOADING_DID_END_NOTIFICATION" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageScrollView];
    [self.view.layer addSublayer:self.progressLayer];
    
    [self.view addSubview:self.videoIndicator];

    if (self.pb_select) {
        [self.view addSubview:self.selectImageView];
        [self.view addSubview:self.selectLabel];
        [self.view addSubview:self.selectPhotoButton];
        [self makeConstraints];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMWPhotoLoadingDidEndNotification:) name:@"ENPHOTO_LOADING_DID_END_NOTIFICATION" object:nil];

}
- (void)changeSelectViewAlpha:(CGFloat)alpha{
    if (!self.pb_select) {
        return;
    }
    self.selectLabel.alpha = alpha;
    self.selectImageView.alpha = alpha;
    
    self.playButton.alpha = alpha * 0.3;
    self.playButton.hidden = alpha < 0.8 ? YES : NO;
}
- (void)makeConstraints {
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectPhotoButton.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.selectPhotoButton.mas_top).mas_offset(20);        
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.selectImageView);    
    }];
    
    [self.selectPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {       
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);        
        make.top.mas_equalTo(self.view.mas_top).mas_offset(10);      
        make.size.mas_equalTo(CGSizeMake(44, 44));    
    }];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
    CGRect frame = self.progressLayer.frame;
    frame.origin.x = center.x - CGRectGetWidth(frame) / 2.0f;
    frame.origin.y = center.y - CGRectGetHeight(frame) / 2.0f;
    self.progressLayer.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
    if (self.pb_select) {
        [self changePhotoButtonSelect];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 干掉加载动画。
    self.progressLayer.hidden = YES;
    self.dismissing = YES;
}

- (void)reloadData {
    [self _prepareForReuse];
    [self _loadData];
}

#pragma mark - Private methods

- (void)_prepareForReuse {
    self.imageView.image = nil;
    self.progressLayer.hidden = YES;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.dismissing = NO;
}

- (void)_loadData {
    
    if (self.photo.isVideo && !self.playButton) {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.alpha = .3;
//        self.playButton.backgroundColor = [UIColor blackColor];
        [self.playButton setImage:[UIImage imageNamed:@"mjl_space_dynamic_bigplay"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];

        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
    }
    
    if ([self.photo isKindOfClass:[ENPhoto class]]) {
        if (self.photo.underlyingImage) {
            self.imageView.image = self.photo.underlyingImage;
        }else{
            self.imageView.image = [NSBundle bundlePlaceholderName:@"lce_banner_default_16_9"];
            [self.photo loadUnderlyingImageAndNotify];
        }
    }
}

- (void)playButtonTapped:(UIButton *)sender{
    
    [[ENPhotoLibraryManager manager] getVideoOutputPathWithAsset:self.photo.assetModel.asset completion:^(NSString *outputPath) {
        [self _playVideo:[NSURL fileURLWithPath:outputPath]];
    }];
}
- (void)_playVideo:(NSURL *)videoURL {
    
    // Setup player
    self.currentVideoPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self.currentVideoPlayerViewController.moviePlayer prepareToPlay];
    self.currentVideoPlayerViewController.moviePlayer.shouldAutoplay = YES;
    self.currentVideoPlayerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.currentVideoPlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    // Observe ourselves so we can get it to use the crossfade transition
    [[NSNotificationCenter defaultCenter] removeObserver:self.currentVideoPlayerViewController
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.currentVideoPlayerViewController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.currentVideoPlayerViewController.moviePlayer];
    
    // Show
    [self presentViewController:self.currentVideoPlayerViewController animated:YES completion:nil];
    
}
- (void)videoFinishedCallback:(NSNotification*)notification {
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_currentVideoPlayerViewController.moviePlayer];
    
    // Clear up
    [self clearCurrentVideo];
    
    // Dismiss
    BOOL error = [[[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMovieFinishReasonPlaybackError;
    if (error) {
        // Error occured so dismiss with a delay incase error was immediate and we need to wait to dismiss the VC
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)clearCurrentVideo {
    [self.currentVideoPlayerViewController.moviePlayer stop];
    self.currentVideoPlayerViewController = nil;
}
- (void)selectPhotoButtonClick:(UIButton *)sender{
    
    if (self.imageScrollerViewSelectImage) {
        self.imageScrollerViewSelectImage(self.photo, ^(NSInteger index) {
            self.photo.assetModel.isSelected = !self.photo.assetModel.isSelected;
            self.photo.assetModel.count = index;
            [self changePhotoButtonSelect];
        });
    }
    
}
- (void)changePhotoButtonSelect{
    if (self.photo.assetModel.isSelected) {
        self.selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_yes"];
        if (self.photo.assetModel.count >0) {
            self.selectLabel.text = [NSString stringWithFormat:@"%ld",(long)self.photo.assetModel.count];
        }
    }else{
        self.selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_no"];
        self.selectLabel.text = [NSString stringWithFormat:@""];
    }
}
#pragma mark- 通知 
- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    ENPhoto * photo = [notification object];
    if (photo == self.photo) {
        if ([photo underlyingImage]) {
            [self reloadData];
        } else {
//            [self showImageFailure];
        }
        self.progressLayer.hidden = YES;
        self.dismissing = YES;
        
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

- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.image = [UIImage imageNamedWithPickerName:@"lce_imagePicker_selece_no"];
    }
    return _selectImageView;
}

- (UIButton *)selectPhotoButton{
    if (!_selectPhotoButton) {
        _selectPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPhotoButton;
}
- (PBImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[PBImageScrollView alloc] init];
    }
    return _imageScrollView;
}

- (UIImageView *)imageView {
    return self.imageScrollView.imageView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, 40, 40);
        _progressLayer.cornerRadius = MIN(CGRectGetWidth(_progressLayer.bounds) / 2.0f, CGRectGetHeight(_progressLayer.bounds) / 2.0f);
        _progressLayer.lineWidth = 4;
        _progressLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:_progressLayer.cornerRadius - 7];
        _progressLayer.path = path.CGPath;
        _progressLayer.hidden = YES;
    }
    return _progressLayer;
}

@end

