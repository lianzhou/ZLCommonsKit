//
//  ZLCoretextManager.h
//  AFNetworking
//
//  Created by taobobo on 2018/3/5.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"

@interface ZLCoretextObject : NSObject

/** set maxWidth, default is screenWidth */
@property(nonatomic, assign) CGFloat maxWidth;

/** attributedLabel can not be nil, require to set */
@property(nonatomic, strong) DTAttributedLabel *attributedLabel;

@end

@class ZLCoretextManager;
@protocol ZLCoretextManagerDelegate<NSObject>


/**
 refresh attributedLabel height

 @param coretextManager coretextManager
 @param coretextHeight reresh height
 */
- (void)coretextManager:(ZLCoretextManager *)coretextManager refreshCoretextHeight:(CGFloat)coretextHeight;


- (void)coretextManager:(ZLCoretextManager *)coretextManager clickedImage:(DTLazyImageView *)imageView;

@end

@interface ZLCoretextManager : NSObject

/** get real text heigft after refresh */
@property(nonatomic, copy) void(^returnCoretextHeight)(CGFloat coretextHeight);

@property(nonatomic,weak) id<ZLCoretextManagerDelegate>delegate;

+ (instancetype)shareManager;

- (CGFloat)obtainCoretextRealHeight:(NSAttributedString *)attributeString maxWidth:(CGFloat)maxWidth;

- (instancetype)initWithCoretextObject:(ZLCoretextObject *)coretextObject;

@end
