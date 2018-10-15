//
//  ParallaxHeaderView.h
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <UIKit/UIKit.h>

@interface ParallaxHeaderView : UIView
@property (nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (nonatomic) UIImage *headerImage;
@property (nonatomic) UIImageView *headerImageView;
@property (nonatomic,assign) BOOL isOrange;
@property (nonatomic,assign)float  height;
@property (nonatomic,assign)BOOL isBlur;

+ (id)parallaxHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
+ (id)parallaxHeaderViewWithImageView:(UIImageView *)imageview forSize:(CGSize)headerSize;
+ (id)parallaxHeaderViewWithImageView:(UIImageView *)imageview forSize:(CGSize)headerSize isOrange:(BOOL)isOrange;
+ (id)parallaxHeaderViewWithSubView:(UIView *)subView with_isBlur:(BOOL)isBlur;

+ (id)parallaxHeaderViewWithImageViewWithBlurView:(UIImageView *)imageview forSize:(CGSize)headerSize with_BlurView:(BOOL)isBlur;

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;
- (void)refreshBlurViewForNewImage;
@end
