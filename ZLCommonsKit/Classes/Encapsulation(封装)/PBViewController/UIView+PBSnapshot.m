//
//  UIView+PBSnapshot.m
//  PhotoBrowser
//


#import "UIView+PBSnapshot.h"

@implementation UIView (PBSnapshot)

- (UIImage *)pb_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outpu = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outpu;
}

- (UIImage *)pb_snapshotAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self pb_snapshot];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *outpu = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outpu;
}

@end
