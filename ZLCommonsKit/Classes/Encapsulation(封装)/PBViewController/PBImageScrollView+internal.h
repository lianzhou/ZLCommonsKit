//
//  PBImageScrollView+internal.h
//  PhotoBrowser


#ifndef PBImageScrollView_internal_h
#define PBImageScrollView_internal_h

#import "PBImageScrollView.h"

@interface PBImageScrollView()

- (void)_handleZoomForLocation:(CGPoint)location;
- (void)_scrollToTopAnimated:(BOOL)animated;

@property (nonatomic, copy) void(^contentOffSetVerticalPercentHandler)(CGFloat);

@property (nonatomic, copy) void(^didEndDraggingInProperpositionHandler)(CGFloat velocity);

@property (nonatomic, copy) void(^handleSingleTapActionInImageScrollView)(void);
@property (nonatomic, copy) void(^handleLongPressActionInImageScrollView)(void);

@end


#endif /* PBImageScrollView_internal_h */
