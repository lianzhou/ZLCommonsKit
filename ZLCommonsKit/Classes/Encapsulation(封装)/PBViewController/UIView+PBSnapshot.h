//
//  UIView+PBSnapshot.h
//  PhotoBrowser


#import <UIKit/UIKit.h>

@interface UIView (PBSnapshot)
- (UIImage *)pb_snapshot;
- (UIImage *)pb_snapshotAfterScreenUpdates:(BOOL)afterUpdates;
@end
