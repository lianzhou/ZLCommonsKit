//
//  PBImageScrollerViewController.h
//  PhotoBrowser
//

#import <UIKit/UIKit.h>
#import "ENPhoto.h"

@class PBImageScrollView;

typedef void(^PBImageScrollerViewSelectImage)(ENPhoto *photo, void (^imageScrollerViewSelectImageCount)(NSInteger index));

@interface PBImageScrollerViewController : UIViewController

@property (nonatomic, assign) BOOL pb_select;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) ENPhoto * photo;


@property (nonatomic, strong, readonly) PBImageScrollView *imageScrollView;


@property (nonatomic, strong)  PBImageScrollerViewSelectImage imageScrollerViewSelectImage;

- (void)changeSelectViewAlpha:(CGFloat)alpha;
- (void)reloadData;

@end
