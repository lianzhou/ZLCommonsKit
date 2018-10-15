//
//  NSBundle+JZCommonsKit.m
//  JZCommonsKit
//
//  Created by li_chang_en on 2017/11/13.
//

#import "NSBundle+JZCommonsKit.h"

@implementation NSBundle (JZCommonsKit)


+ (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"JZPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}

+ (NSBundle *)JZEmojiBundle {

    static NSBundle * emojiMainBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * emojiExpression = [[NSBundle mainBundle] pathForResource:@"JZEmojiExpression" ofType:@"bundle"];
        emojiMainBundle = [NSBundle bundleWithPath:emojiExpression];    
    });
    return emojiMainBundle;
}
+ (NSBundle *)JZImagePickerExpression {
    
    static NSBundle * imagePickerExpression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * JZEmojiExpression = [[NSBundle mainBundle] pathForResource:@"ENImagePickerExpression" ofType:@"bundle"];
        imagePickerExpression = [NSBundle bundleWithPath:JZEmojiExpression];    
    });
    return imagePickerExpression;
}
@end

