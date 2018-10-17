//
//  UITableViewCell+LineImageView.m
//  AFNetworking
//
//  Created by li_chang_en on 2017/12/11.
//

#import "UITableViewCell+LineImageView.h"
#import <objc/runtime.h>
#import "UIImage+ZLTintColor.h"
#import "ZLSystemMacrocDefine.h"

static const void *kTopLineViewObjectKey;
static const void *kBottomLineObjectKey;

@implementation UITableViewCell (LineImageView)

- (UIImageView *)topLineView
{
    UIImageView *topLineImageView=objc_getAssociatedObject(self, &kTopLineViewObjectKey);
    if (!topLineImageView) {
        topLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        topLineImageView.image = [UITableViewCell lineImage];
        [self addSubview:topLineImageView];
        objc_setAssociatedObject(self, 
                                 &kTopLineViewObjectKey, 
                                 topLineImageView, 
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return topLineImageView;
}
- (void)setTopLineView:(UIImageView *)topLineView
{
    objc_setAssociatedObject(self,  &kTopLineViewObjectKey, topLineView,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)bottomLineView
{
    UIImageView *bottomLineImageView=objc_getAssociatedObject(self, &kBottomLineObjectKey);
    
    if (!bottomLineImageView) {
        bottomLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bottomLineImageView.image = [UITableViewCell lineImage];
        [self addSubview:bottomLineImageView];
        objc_setAssociatedObject(self, 
                                 &kBottomLineObjectKey, 
                                 bottomLineImageView, 
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bottomLineImageView;
}
- (void)setBottomLineView:(UIImageView *)bottomLineView
{
    objc_setAssociatedObject(self,  &kBottomLineObjectKey, bottomLineView,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(UIImage *)lineImage{
    static UIImage *lineImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineImage =[UIImage imageWithColor:UIColorFromRGB(0xebebeb)];
    });
    return lineImage;
}
@end
