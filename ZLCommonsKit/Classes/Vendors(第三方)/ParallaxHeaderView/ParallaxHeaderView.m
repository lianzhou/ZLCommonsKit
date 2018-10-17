//
//  ParallaxHeaderView.m
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <QuartzCore/QuartzCore.h>
#import "FXBlurView.h"
#import "ParallaxHeaderView.h"
#import "ZLSystemMacrocDefine.h"

@interface ParallaxHeaderView ()

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)  UIView *subView;

@property (strong, nonatomic) FXBlurView * blurView;
//@property (nonatomic) IBOutlet UIImageView *bluredImageView;
@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;
static CGFloat kLabelPaddingDist = 8.0f;

@implementation ParallaxHeaderView

+ (id)parallaxHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.headerImage = image;
    [headerView initialSetupForDefaultHeader];
    return headerView;
    
}
+ (id)parallaxHeaderViewWithImageView:(UIImageView *)imageview forSize:(CGSize)headerSize;
{
    return [self parallaxHeaderViewWithImageView:imageview forSize:headerSize isOrange:YES];
    
}
+ (id)parallaxHeaderViewWithImageView:(UIImageView *)imageview forSize:(CGSize)headerSize isOrange:(BOOL)isOrange;
{
    
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.isOrange =isOrange;
    headerView.headerImageView = imageview;
    
    [headerView initialSetupForDefaultHeaderIsOrange:isOrange];
    return headerView;
    
}

+ (id)parallaxHeaderViewWithSubView:(UIView *)subView with_isBlur:(BOOL)isBlur
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
    [headerView initialSetupForCustomSubView:subView with_isBlur:isBlur];
    return headerView;
}
+ (id)parallaxHeaderViewWithImageViewWithBlurView:(UIImageView *)imageview forSize:(CGSize)headerSize with_BlurView:(BOOL)isBlur
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.imageView = imageview;
    headerView.isBlur = isBlur;
    [headerView initialSetupForDefaultHeaderWithBlurView:isBlur];
    return headerView;
}

- (void)awakeFromNib
{
     [super awakeFromNib];
    _isOrange = YES;
    if (self.subView)
        [self initialSetupForCustomSubView:self.subView with_isBlur:_isBlur];
    else
        
        [self initialSetupForDefaultHeader];
    
//    [self refreshBlurViewForNewImage];
}
- (void)setHeight:(float)height {
    _height = height;
}
- (void)setIsOrange:(BOOL)isOrange {
    _isOrange = isOrange;
}
- (void)setIsBlur:(BOOL)isBlur
{
    _isBlur = isBlur;
}
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect frame = self.imageScrollView.frame;
    
    
    if (offset.y >= 0)
    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        self.imageScrollView.frame = frame;
//        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.imageScrollView.frame)/2);
        self.clipsToBounds = YES;
        if (!_isOrange) {
            self.blurView.blurRadius = -0.1*(_height-offset.y)+27;
        }
        
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = kDefaultHeaderFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
//        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.imageScrollView.frame)/2);
        self.clipsToBounds = NO;
        self.headerTitleLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
    }
}

- (void)refreshBlurViewForNewImage
{
//    UIImage *screenShot = [self screenShotOfView:self];
//    screenShot = [screenShot applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
//    self.bluredImageView.image = screenShot;
}

#pragma mark -
#pragma mark Private
- (void)initialSetupForDefaultHeader;
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.clipsToBounds = YES;
    self.imageScrollView = scrollView;
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    self.imageView.frame = scrollView.bounds;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //    self.imageView.image = self.headerImage;
    [self.imageScrollView addSubview:self.imageView];
    
    self.blurView = [[FXBlurView alloc]initWithFrame:self.imageView.frame];
    self.blurView.blurRadius = 10;
    self.blurView.alpha = 0.2;
    //    bgView.alpha = 0.8;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.imageScrollView addSubview:self.blurView];
    
    
    
    CGRect labelRect = self.imageScrollView.bounds;
    labelRect.origin.x = labelRect.origin.y = kLabelPaddingDist;
    labelRect.size.width = labelRect.size.width - 2 * kLabelPaddingDist;
    labelRect.size.height = labelRect.size.height - 2 * kLabelPaddingDist;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.autoresizingMask = self.imageView .autoresizingMask;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:23];
    self.headerTitleLabel = headerLabel;
    [self.imageScrollView addSubview:self.headerTitleLabel];
    //
    //    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    //    self.bluredImageView.autoresizingMask = self.imageView.autoresizingMask;
    //    self.bluredImageView.alpha = 0.0f;
    //    [self.imageScrollView addSubview:self.bluredImageView];
    
    [self addSubview:self.imageScrollView];
    
    if (_isOrange) {
        UIImageView * orangeView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
        orangeView.alpha = 1;
        orangeView.image = [UIImage imageNamed:@"my_header_image"];
        orangeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.imageScrollView addSubview:orangeView];
    }
    
    //    [self refreshBlurViewForNewImage];
}

- (void)initialSetupForDefaultHeaderIsOrange:(BOOL)isOrange;
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.clipsToBounds = YES;
    self.imageScrollView = scrollView;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    self.imageView.frame = scrollView.bounds;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageView.image = self.headerImage;
    [self.imageScrollView addSubview:self.imageView];

//     self.blurView = [[FXBlurView alloc]initWithFrame:self.imageView.frame];
//     self.blurView.dynamic = NO;
    if (!isOrange) {
        self.blurView = [[FXBlurView alloc]initWithFrame:self.imageView.frame];
        self.blurView.dynamic = NO;
        self.blurView.tintColor = [UIColor clearColor];
        self.blurView.blurRadius = 0;
        self.blurView.alpha = 1;
    } else {
//        self.blurView.blurRadius = 10;
//        self.blurView.alpha = 0.2;

    }
    //    bgView.alpha = 0.8;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.imageScrollView addSubview:self.blurView];
    
 

    CGRect labelRect = self.imageScrollView.bounds;
    labelRect.origin.x = labelRect.origin.y = kLabelPaddingDist;
    labelRect.size.width = labelRect.size.width - 2 * kLabelPaddingDist;
    labelRect.size.height = labelRect.size.height - 2 * kLabelPaddingDist;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.autoresizingMask = self.imageView .autoresizingMask;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:23];
    self.headerTitleLabel = headerLabel;
    [self.imageScrollView addSubview:self.headerTitleLabel];
//    
//    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
//    self.bluredImageView.autoresizingMask = self.imageView.autoresizingMask;
//    self.bluredImageView.alpha = 0.0f;
//    [self.imageScrollView addSubview:self.bluredImageView];
    
    [self addSubview:self.imageScrollView];
    
    if (_isOrange) {
        UIImageView * orangeView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
        orangeView.alpha = 1;
        orangeView.image = [UIImage imageNamed:@"my_header_image"];
        orangeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.imageScrollView addSubview:orangeView];
    }

//    [self refreshBlurViewForNewImage];
}

- (void)initialSetupForCustomSubView:(UIView *)subView with_isBlur:(BOOL)isBlur
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageScrollView = scrollView;
    self.subView = subView;
    
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
//    self.subView.backgroundColor = [UIColor clearColor];
//    self.imageView.image = [UIImage imageNamed:@"mjl_dddd"];
//    [self.imageScrollView addSubview:self.imageView];
    subView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.imageScrollView addSubview:subView];
    
    if (isBlur) {
        if (ZL_IOS7) {
            UIBlurEffect *blure = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blure];
            effectView.frame = self.frame;
            effectView.alpha = 1.0;
            [self.imageScrollView addSubview:effectView];
        }else{
            self.blurView = [[FXBlurView alloc]initWithFrame:self.imageScrollView.frame];
            self.blurView.blurRadius = 20;
            self.blurView.tintColor = [UIColor clearColor];
            self.blurView.alpha = 1.0;
            self.blurView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.imageScrollView addSubview:self.blurView];
        }
    }
   
    
    [self addSubview:self.imageScrollView];
}

#pragma mark -添加带毛玻璃的View
- (void)initialSetupForDefaultHeaderWithBlurView:(BOOL)isBlur
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.clipsToBounds = YES;
    self.imageScrollView = scrollView;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageScrollView addSubview:self.imageView];
    if (isBlur) {
        self.blurView = [[FXBlurView alloc]initWithFrame:self.imageScrollView.frame];
        self.blurView.blurRadius = 20;
        self.blurView.tintColor = [UIColor clearColor];
        self.blurView.alpha = 1.0;
        self.blurView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.imageScrollView addSubview:self.blurView];
    }
    

    [self addSubview:self.imageScrollView];
}
- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
//    [self refreshBlurViewForNewImage];
}
- (void)setHeaderImageView:(UIImageView *)headerImageView
{
    self.imageView = headerImageView;
//    [self refreshBlurViewForNewImage];
}
- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(kDefaultHeaderFrame.size, YES, 0.0);
    [self drawViewHierarchyInRect:kDefaultHeaderFrame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
