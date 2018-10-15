//
//  PBImageScrollView.h
//  PhotoBrowser


#import <UIKit/UIKit.h>

@interface PBImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
