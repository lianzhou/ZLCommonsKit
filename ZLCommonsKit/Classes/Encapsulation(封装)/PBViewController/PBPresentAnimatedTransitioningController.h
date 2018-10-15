//
//  PBPresentAnimatedTransitioningController.h
//  PhotoBrowser


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PBContextBlock)(UIView * __nonnull fromView, UIView * __nonnull toView);

@interface PBPresentAnimatedTransitioningController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, copy, nullable) PBContextBlock willPresentActionHandler;
@property (nonatomic, copy, nullable) PBContextBlock onPresentActionHandler;
@property (nonatomic, copy, nullable) PBContextBlock didPresentActionHandler;
@property (nonatomic, copy, nullable) PBContextBlock willDismissActionHandler;
@property (nonatomic, copy, nullable) PBContextBlock onDismissActionHandler;
@property (nonatomic, copy, nullable) PBContextBlock didDismissActionHandler;


/// Default cover is a dim view, you could override this property to your preferred style view.
//@property (nonatomic, strong, nonnull) UIView *coverView;

- (nonnull PBPresentAnimatedTransitioningController *)prepareForPresent;
- (nonnull PBPresentAnimatedTransitioningController *)prepareForDismiss;

@end
