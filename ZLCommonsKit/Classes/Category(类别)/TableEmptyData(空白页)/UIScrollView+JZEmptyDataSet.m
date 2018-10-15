//
//  UIScrollView+JZEmptyDataSet.m
//  eStudy
//
//  Created by zhoulian on 17/6/13.
//

#import "UIScrollView+JZEmptyDataSet.h"
#import <objc/runtime.h>
#import "JZStringMacrocDefine.h"
#import "JZSystemMacrocDefine.h"
#import "YYKit.h"
#import "NSBundle+JZCommonsKit.h"

static const void *kJZEmptyDataSetButtonClickBlock = "kJZEmptyDataSetButtonClickBlock";
static const void *kJZEmptyDataSetViewClickBlock = "kJZEmptyDataSetViewClickBlock";
static const void *kJZEmptyDataSetEmptyText        = "kJZEmptyDataSetEmptyText";
static const void *kJZEmptyDataSetEmptyButtonText  = "kJZEmptyDataSetEmptyButtonText";
static const void *kJZEmptyDataSetEmptyButtonTitleColor  = "kJZEmptyDataSetEmptyButtonTitleColor";

static const void *kJZEmptyDataSetEmptySubText     = "kJZEmptyDataSetEmptySubText";
static const void *kJZEmptyDataSetEmptyOffset      = "kJZEmptyDataSetEmptyOffset";
static const void *kJZEmptyDataSetEmptyImage       = "kJZEmptyDataSetEmptyImage";
static const void *kJZEmptyDataSetEmptyButtonImage = "kJZEmptyDataSetEmptyButtonImage";


@implementation UIScrollView (JZEmptyDataSet)

#pragma mark - Button

- (dispatch_block_t)emptyButtonClickBlock{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetButtonClickBlock);
}

- (void)setEmptyButtonClickBlock:(dispatch_block_t)emptyButtonClickBlock{
    
    objc_setAssociatedObject(self, &kJZEmptyDataSetButtonClickBlock, emptyButtonClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)emptyViewClickBlock{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetViewClickBlock);
}

- (void)setEmptyViewClickBlock:(dispatch_block_t)emptyViewClickBlock{
    
    objc_setAssociatedObject(self, &kJZEmptyDataSetViewClickBlock, emptyViewClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyButtonText{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyButtonText);
}
- (UIColor *)emptyButtonTitleColor{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyButtonTitleColor);
}



- (void)setEmptyButtonTitleColor:(UIColor *)emptyButtonTitleColor{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyButtonTitleColor, emptyButtonTitleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEmptyButtonText:(NSString *)emptyButtonText{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyButtonText, emptyButtonText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIImage *)emptyButtonImage{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyButtonImage);
}

- (void)setEmptyButtonImage:(UIImage *)emptyButtonImage{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyButtonImage, emptyButtonImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - Text
- (NSString *)emptyText{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyText);
}

- (void)setEmptyText:(NSString *)emptyText{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyText, emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)emptySubText{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptySubText);
}

- (void)setEmptySubText:(NSString *)emptySubText{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptySubText, emptySubText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)emptyOffset{
    NSNumber *number = objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyOffset);
    return number.floatValue;
}

- (void)setEmptyOffset:(CGFloat)emptyOffset{
    NSNumber *number = [NSNumber numberWithDouble:emptyOffset];
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyOffset, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (UIImage *)emptyImage{
    return objc_getAssociatedObject(self, &kJZEmptyDataSetEmptyImage);
}

- (void)setEmptyImage:(UIImage *)emptyImage{
    objc_setAssociatedObject(self, &kJZEmptyDataSetEmptyImage, emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/**
 * 设置空白图
 
 @param image 图片
 */
- (void)setupEmptyImage:(UIImage *)image{
    [self setupEmptyDataText:nil subText:nil verticalOffset:0 emptyImage:image];
}
- (void)setupEmptyDataText:(NSString *)text subText:(NSString *)subText emptyImage:(UIImage *)image {
    [self setupEmptyDataText:text subText:subText verticalOffset:0 emptyImage:image];

}

- (void)setupEmptyDataText:(NSString *)text  emptyImage:(UIImage *)image{
    [self setupEmptyDataText:text subText:nil verticalOffset:0 emptyImage:image ];

}

- (void)setupEmptyDatasubText:(NSString *)subText  emptyImage:(UIImage *)image{
    [self setupEmptyDataText:nil subText:subText verticalOffset:0 emptyImage:image];
}

- (void)setupEmptyDataText:(NSString *)text{
    [self setupEmptyDataText:text subText:nil verticalOffset:0 emptyImage:nil];

}

- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset{
    [self setupEmptyDataText:text subText:nil verticalOffset:offset emptyImage:nil];

}

- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image{
    [self setupEmptyDataText:text subText:nil verticalOffset:offset emptyImage:image];

}

- (void)setupEmptyDataText:(NSString *)text subText:(NSString *)subText verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image{
    
    if (!JZStringIsNull(text)) {
        self.emptyText = text;
    }
    if (!JZStringIsNull(subText)) {
        self.emptySubText = subText;
    }
    if (image) {
        self.emptyImage = image;
    }
    self.emptyOffset = offset;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
}
- (void)setupEmptyButtonText:(NSString *)buttonText emptyButtonImage:(UIImage *)buttonimage emptyButtonTitleColor:(UIColor *)titleColor tapBlock:(dispatch_block_t)buttonClickBlock {
    if (titleColor) {
        self.emptyButtonTitleColor = titleColor;
    }
    [self setupEmptyButtonText:buttonText emptyButtonImage:buttonimage tapBlock:buttonClickBlock];

}
- (void)setupEmptyButtonText:(NSString *)buttonText emptyButtonImage:(UIImage *)buttonimage tapBlock:(dispatch_block_t)buttonClickBlock{
    if (!JZStringIsNull(buttonText)) {
        self.emptyButtonText = buttonText;
    }    
    if (buttonimage) {
        self.emptyButtonImage = buttonimage;
    }
    if (buttonClickBlock) {
        self.emptyButtonClickBlock = buttonClickBlock;
    }
    [self reloadJZEmptyDataSet];
}
- (void)reloadJZEmptyDataSet{
    [self reloadEmptyDataSet];
}
#pragma mark - DZNEmptyDataSetSource

// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:UIColorFromHex(0xcccccc),
                                 NSParagraphStyleAttributeName: paragraph};
    

//    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
//    YYReachabilityStatus internetStatus = reachability.status;
//    if (internetStatus == YYReachabilityStatusNone) {
//        return [[NSAttributedString alloc] initWithString:@"轻触屏幕,重新加载\n一定要轻轻的..." attributes:attributes];
//    }
    NSString *text = JZStringIsNull(self.emptyText)?@"":self.emptyText;
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f ],
                                 NSForegroundColorAttributeName: UIColorFromHex(0xcccccc),
                                 NSParagraphStyleAttributeName: paragraph};
    
//    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
//    YYReachabilityStatus internetStatus = reachability.status;
//    if (internetStatus == YYReachabilityStatusNone) {
//        return [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
//    }
    NSString *text = JZStringIsNull(self.emptySubText)?@"":self.emptySubText;
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];

}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    
    NSString *text = JZStringIsNull(self.emptyButtonText)?@"":self.emptyButtonText;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:(!self.emptyButtonTitleColor)?[UIColor blackColor]:self.emptyButtonTitleColor};
    
//    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
//    YYReachabilityStatus internetStatus = reachability.status;
//    if (internetStatus == YYReachabilityStatusNone) {
//        return [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
//    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return self.emptyButtonImage?:nil;
}
/// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
//    YYReachability *reachability   = [YYReachability reachabilityWithHostname:@"www.baidu.com"];
//    YYReachabilityStatus internetStatus = reachability.status;
//    if (internetStatus == YYReachabilityStatusNone) {
//        return [NSBundle bundlePlaceholderName:@"lce_noti_person_90_90"];
//    }
    return self.emptyImage?:nil;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jz_backgroundColorForEmptyDataSet:)]) {
        id <JZScrollViewEmptyDelegate> delegate  = (id<JZScrollViewEmptyDelegate>)self.delegate;
        UIColor * color = [delegate jz_backgroundColorForEmptyDataSet:self];
        return color;
    }else{
        return [UIColor whiteColor];
    }
}
/// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyOffset;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.contentOffset = CGPointZero;
}

//是否允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.emptyViewClickBlock) {
        self.emptyViewClickBlock();
    }
    
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.emptyButtonClickBlock) {
        self.emptyButtonClickBlock();
    }
}

- (int)dzn_reloadItemsCount{

    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewEmptyCount:)]) {
        id <JZScrollViewEmptyDelegate> delegate  = (id<JZScrollViewEmptyDelegate>)self.delegate;
        int count = [delegate scrollViewEmptyCount:self];
        return count;
    }else{
        return 0;
    }
    
}


@end
