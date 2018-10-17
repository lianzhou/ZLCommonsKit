//
//  NSBundle+ZLCommonsKit.m
//  ZLCommonsKit
//
//  Created by li_chang_en on 2017/11/13.
//

#import "NSBundle+ZLCommonsKit.h"

@implementation NSBundle (ZLCommonsKit)


+ (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"ZLPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}

+ (NSBundle *)ZLEmojiBundle {

    static NSBundle * emojiMainBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * emojiExpression = [[NSBundle mainBundle] pathForResource:@"ZLEmojiExpression" ofType:@"bundle"];
        emojiMainBundle = [NSBundle bundleWithPath:emojiExpression];    
    });
    return emojiMainBundle;
}
+ (NSBundle *)ZLImagePickerExpression {
    
    static NSBundle * imagePickerExpression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * ZLEmojiExpression = [[NSBundle mainBundle] pathForResource:@"ENImagePickerExpression" ofType:@"bundle"];
        imagePickerExpression = [NSBundle bundleWithPath:ZLEmojiExpression];    
    });
    return imagePickerExpression;
}
@end

