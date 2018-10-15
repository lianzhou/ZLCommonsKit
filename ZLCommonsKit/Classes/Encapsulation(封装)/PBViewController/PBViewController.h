//
//  PBViewController.h
//  PhotoBrowser
//

#import <UIKit/UIKit.h>
#import "ENPhoto.h"

@class PBViewController;

#pragma mark - PBViewControllerDataSource

@protocol PBViewControllerDataSource <NSObject>

- (NSInteger)numberOfPagesInViewController:(nonnull PBViewController *)viewController;

@optional

- (nonnull ENPhoto *)viewController:(nonnull PBViewController *)viewController photoForPageAtIndex:(NSInteger)index;

- (nullable UIView *)thumbViewForPageAtIndex:(NSInteger)index;


@end

#pragma mark - PBViewControllerDelegate

@protocol PBViewControllerDelegate <NSObject>

@optional

- (void)viewController:(nonnull PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(nullable UIImage *)presentedImage;

- (void)viewController:(nonnull PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(nullable UIImage *)presentedImage;

- (void)viewController:(nonnull PBViewController *)viewController didSelectPageAtIndex:(NSInteger)index didSelectPageAtPhoto:(nonnull ENPhoto *)photo success:(void (^_Nullable)(NSInteger index))success failure:(void (^_Nullable)(NSString * _Nullable error))failure;

- (void)viewControllerWillDisappear:(nonnull PBViewController *)viewController;


@end



@interface PBViewController : UIPageViewController

@property (nonatomic, weak, nullable) id<PBViewControllerDataSource> pb_dataSource;
@property (nonatomic, weak, nullable) id<PBViewControllerDelegate> pb_delegate;

@property (nonatomic, assign) NSInteger pb_startPage;
@property (nonatomic, assign) BOOL pb_select;

@property (nonatomic, assign, readonly) NSInteger numberOfPages;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) NSInteger startPage;

- (void)reload;

- (void)reloadWithCurrentPage:(NSInteger)index;
- (void)reloadWithCurrentPage:(NSInteger)index animated:(BOOL)animated;

@property (nonatomic, assign) BOOL blurBackground;

@property (nonatomic, assign) BOOL hideThumb;

@property (nonatomic, copy, nullable) void (^exit)(PBViewController * _Nonnull sender);

@end
