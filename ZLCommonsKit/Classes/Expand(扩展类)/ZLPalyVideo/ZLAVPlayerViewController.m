//
//  avplayerVC.m
//  TBPlayer
//
//  Created by qianjianeng on 16/2/27.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "ZLAVPlayerViewController.h"
#import "ZLLocalVideoPlayer.h"
#import "YYReachability.h"
#import "ZLVideoTransition.h"
#import "Masonry.h"
#import "ZLBaseNavigationController.h"
#import "ZLSystemMacrocDefine.h"
#import "ZLStringMacrocDefine.h"
#import "UIImageView+ZLSDWebImage.h"
#import "ZLAlertHUD.h"
#import <NSString+YYAdd.h>
#import "PBPresentAnimatedTransitioningController.h"
#import <YYKit/YYKit.h>
#import "ZLUtilsTools.h"
#import "UIView+MJExtension.h"
#import "ZLContext.h"

@interface ZLAVPlayerViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ZLLocalVideoPlayer *player;

@property (nonatomic, strong) UIImageView *playerView;


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *deleteButtonView;

@property (nonatomic,strong) PBPresentAnimatedTransitioningController *transitioningController;

@end

@implementation ZLAVPlayerViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT, SCREEN_HEIGHT)];
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    self.backView.alpha = 0.0;
    
    //背景图片
    self.playerView = [[UIImageView alloc] init];
    self.playerView.tag = 952;
    self.playerView.contentMode = UIViewContentModeScaleAspectFill;
    if (!ZLStringIsNull(_imageName)) {
        if([_urlString hasPrefix:@"http"] || [_urlString hasPrefix:@"https"]){
            [self.playerView zl_setImageWithURL:[NSURL URLWithString:_imageName] placeholderType:ZLPlaceholderImageTypeNone];
        } else {
            self.playerView.image = [[UIImage alloc] initWithContentsOfFile:_imageName];
        }
    } else {
        if (self.firstIamge) {
            self.playerView.image = self.firstIamge;
        }else{
            self.playerView.image = [UIImage imageNamed:@"eStudy110 110"];
        }
    }
    
    
    self.playerView.userInteractionEnabled = YES;
    self.playerView.clipsToBounds = YES;
    [self.view addSubview:self.playerView];

    
    CGRect startRect = [self.startView.superview convertRect:self.startView.frame toView:self.view];
    self.playerView.frame = startRect;

    //单击返回手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(palyendGesture:)];
    [self.view addGestureRecognizer:tap];
    
    //播放按钮
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"ljm_video_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"ljm_video_play"] forState:UIControlStateHighlighted];
    [self.playerView addSubview:_playButton];
    _playButton.userInteractionEnabled = NO;
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.playerView.center);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self _setupTransitioningController];
}
- (void)play{
    WEAKSELF
    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
    YYReachabilityStatus internetStatus = reachability.status;
    switch (internetStatus) {
        case YYReachabilityStatusWiFi:
            [weakSelf startToPlay:weakSelf.playButton];
            break;
        case YYReachabilityStatusWWAN:
        {
            if([_urlString hasPrefix:@"http"] || [_urlString hasPrefix:@"https"]){
                //缓存保存数据的路径
                NSString *movePath =  [[ZLFilePath mainVideoCacheRemoteDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[self.urlString md5String]]];

                if (![[NSFileManager defaultManager] fileExistsAtPath:movePath]) {
                    [ZLAlertHUD alertShowTitle:nil message:@"当前网络为手机流量,是否继续" otherButtonTitle:@"继续" continueBlock:^{
                        [weakSelf startToPlay:weakSelf.playButton];
                    }];

                } else {
                    [weakSelf startToPlay:weakSelf.playButton];
                }
            } else {
                [weakSelf startToPlay:weakSelf.playButton];
            }
        }
            break;
            
        case YYReachabilityStatusNone:
            [weakSelf startToPlay:weakSelf.playButton];
        default:
            break;
    }
    
    if(![_urlString hasPrefix:@"http"] && ![_urlString hasPrefix:@"https"]){
         //删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-70, 15, 55, 30);
        _deleteButton.layer.borderWidth = 0.5;
        _deleteButton.layer.cornerRadius = 2;
        _deleteButton.layer.borderColor =UIColorRGBA(102, 102, 102, 0.5).CGColor;
        _deleteButton.backgroundColor = UIColorRGBA(0, 0, 0, 0.30);
        _deleteButton.tag = 953;
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [self.view addSubview:_deleteButton];
        [self.view.layer addSublayer:_deleteButton.layer];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}
- (void)palyendGesture:(UITapGestureRecognizer *)tap {
    [self goToBack];
}
- (void)startToPlay:(UIButton *)btn {
    
    NSURL *url = nil;
    if([_urlString hasPrefix:@"http"] || [_urlString hasPrefix:@"https"]){
        //缓存保存数据的路径
        
        NSString *movePath =  [[ZLFilePath mainVideoCacheRemoteDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[self.urlString md5String]]];

        if ([[NSFileManager defaultManager] fileExistsAtPath:movePath]) {
            _playButton.hidden = YES;
            NSURL *movieURL = [NSURL fileURLWithPath:movePath];

            url = movieURL;
        } else {
            url = [NSURL URLWithString:self.urlString];
        }
    }else {
        _playButton.hidden = YES;
        url = [NSURL fileURLWithPath:self.urlString];
        
    }
    
    
    //注意url不能为空
    if (!ZLStringIsNull(url.absoluteString)) {
        [[ZLLocalVideoPlayer sharedInstance] playWithUrl:url showView:self.playerView backView:self.view size:_videoSize];
        WEAKSELF
        [ZLLocalVideoPlayer sharedInstance].downloadSuccessBlock = ^(){
            weakSelf.playButton.hidden = YES;
        };
    }
}

- (void)deleteButtonClick:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    [self goToBack];
    if (self.deleteVideoBlock) {
        self.deleteVideoBlock();
    }
}

- (void)goToBack {
    _deleteButton.hidden = YES;
    _playButton.hidden = YES;
    
    [[ZLLocalVideoPlayer sharedInstance] stop];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)_setupTransitioningController {
    @weakify(self);
    self.transitioningController.willPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _willPresent];
    };
    self.transitioningController.onPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _onPresent];
    };
    self.transitioningController.didPresentActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _didPresented];
    };
    self.transitioningController.willDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _willDismiss];
    };
    self.transitioningController.onDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _onDismiss];
    };
    self.transitioningController.didDismissActionHandler = ^(UIView *fromView, UIView *toView) {
        @strongify(self);
        [self _didDismiss];
    };
}
- (void)_willPresent {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.backView.alpha = 0.2;
//    }];

}
- (void)_onPresent {
    
    CGSize backViewSize =  [ZLUtilsTools imageSizeWithMaxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) minSize:CGSizeMake(40, 40) originalSize:self.videoSize];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 1;
        self.playerView.mj_size =backViewSize;
        self.playerView.center = self.view.center;
        
    } completion:^(BOOL finished) {

        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        [self play];
    }];
}
- (void)_didPresented {
    
    
}
- (void)_willDismiss {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
 
    [[ZLLocalVideoPlayer sharedInstance] stop];

    CGSize backViewSize =  [ZLUtilsTools imageSizeWithMaxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) minSize:CGSizeMake(40, 40) originalSize:self.videoSize];
    self.playerView.mj_size =backViewSize;
    self.playerView.center = self.view.center;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.0;
    }];


}
- (void)_onDismiss {
    
    CGRect startRect = [self.startView.superview convertRect:self.startView.frame toView:self.view];
    
    
//    [UIView animateWithDuration:0.25 animations:^{
    
        self.playerView.frame =startRect;
        
//    } completion:^(BOOL finished) {
//
//    }];

}
- (void)_didDismiss {
    [ZLContext shareInstance].currentViewController = self.presentingViewController;
}
- (PBPresentAnimatedTransitioningController *)transitioningController {
    if (!_transitioningController) {
        _transitioningController = [PBPresentAnimatedTransitioningController new];
    }
    return _transitioningController;
}
#pragma mark - UIViewControllerAnimatedTransitioning
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self.transitioningController prepareForPresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self.transitioningController prepareForDismiss];
}

@end
