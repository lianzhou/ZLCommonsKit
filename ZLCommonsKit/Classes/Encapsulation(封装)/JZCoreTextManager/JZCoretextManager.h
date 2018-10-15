//
//  JZCoretextManager.h
//  AFNetworking
//
//  Created by taobobo on 2018/3/5.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"

@interface JZCoretextObject : NSObject

/** set maxWidth, default is screenWidth */
@property(nonatomic, assign) CGFloat maxWidth;

/** attributedLabel can not be nil, require to set */
@property(nonatomic, strong) DTAttributedLabel *attributedLabel;

@end

@class JZCoretextManager;
@protocol JZCoretextManagerDelegate<NSObject>


/**
 refresh attributedLabel height

 @param coretextManager coretextManager
 @param coretextHeight reresh height
 */
- (void)coretextManager:(JZCoretextManager *)coretextManager refreshCoretextHeight:(CGFloat)coretextHeight;


- (void)coretextManager:(JZCoretextManager *)coretextManager clickedImage:(DTLazyImageView *)imageView;

@end

@interface JZCoretextManager : NSObject

/** get real text heigft after refresh */
@property(nonatomic, copy) void(^returnCoretextHeight)(CGFloat coretextHeight);

@property(nonatomic,weak) id<JZCoretextManagerDelegate>delegate;

+ (instancetype)shareManager;

- (CGFloat)obtainCoretextRealHeight:(NSAttributedString *)attributeString maxWidth:(CGFloat)maxWidth;

- (instancetype)initWithCoretextObject:(JZCoretextObject *)coretextObject;

@end
