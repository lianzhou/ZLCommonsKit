//
//  ZLCoretextManager.m
//  AFNetworking
//
//  Created by taobobo on 2018/3/5.
//

#import "ZLCoretextManager.h"

@implementation ZLCoretextObject

@end

@interface ZLCoretextManager ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate
>

@property(nonatomic, strong) ZLCoretextObject *coretextObject;

@end

static DTAttributedLabel *_tlbAttributedLabel;

static ZLCoretextManager *__manager;

@implementation ZLCoretextManager

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _tlbAttributedLabel = [[DTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 320 - 30, 100)];
        _tlbAttributedLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tlbAttributedLabel.numberOfLines = 0;
        __manager = [[ZLCoretextManager alloc] init];
    });
    
    return __manager;
}


- (CGFloat)obtainCoretextRealHeight:(NSAttributedString *)attributeString maxWidth:(CGFloat)maxWidth {
    
    _tlbAttributedLabel.attributedString = attributeString;
    return [_tlbAttributedLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth].height;
}

- (instancetype)initWithCoretextObject:(ZLCoretextObject *)coretextObject {

    self = [super init];
    if (self) {
        self.coretextObject = coretextObject;
        coretextObject.attributedLabel.delegate = self;
    }
    return self;
}

- (void)imgTaped:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(coretextManager:clickedImage:)]) {
        [self.delegate coretextManager:self clickedImage:(DTLazyImageView *)tap.view];
    }
}


#pragma mark - DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame {
    return nil;
}

// 实现图片下载
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.url = attachment.contentURL;
        imageView.shouldShowProgressiveDownload = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTaped:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        if (@available(iOS 8.0, *)) {
            if ([attachment.contentURL.absoluteString containsString:@"file://"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 2, frame.size.width, frame.size.height);
                });
            }
        }
        
        return (UIView *)imageView;
    }
    return nil;
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    CGFloat width = self.coretextObject.maxWidth;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [self.coretextObject.attributedLabel.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero) || oneAttachment.originalSize.width == 0 || oneAttachment.originalSize.height == 0 || oneAttachment.originalSize.width > width)
        {
            oneAttachment.originalSize = imageSize;
            oneAttachment.displaySize = imageSize;
            if (imageSize.width > width) {
                oneAttachment.displaySize = CGSizeMake(width, width * imageSize.height/imageSize.width);
                oneAttachment.originalSize = CGSizeMake(width, width * imageSize.height/imageSize.width);
            }
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coretextObject.attributedLabel.layouter = nil;
            [self.coretextObject.attributedLabel relayoutText];
            [self.coretextObject.attributedLabel setNeedsLayout];
            CGFloat height = [self.coretextObject.attributedLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:self.coretextObject.maxWidth].height;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(coretextManager:refreshCoretextHeight:)]) {
                [self.delegate coretextManager:self refreshCoretextHeight:height];
            }
            else {
                if (self.returnCoretextHeight) {
                    self.returnCoretextHeight(height);
                }
            }
        });
    }

}


- (void)dealloc {
    
    self.delegate = nil;
    self.coretextObject.attributedLabel.delegate = nil;
    self.coretextObject.attributedLabel = nil;
    self.coretextObject = nil;
}

@end
