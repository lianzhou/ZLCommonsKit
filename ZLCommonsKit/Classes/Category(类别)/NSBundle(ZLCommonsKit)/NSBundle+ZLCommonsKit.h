//
//  NSBundle+ZLCommonsKit.h
//  ZLCommonsKit
//
//  Created by li_chang_en on 2017/11/13.
//

#import <Foundation/Foundation.h>

@interface NSBundle (ZLCommonsKit)

//默认图的Bundle
+ (UIImage *)bundlePlaceholderName:(NSString *)iconName;

//表情的Bundle
+ (NSBundle *)ZLEmojiBundle;

//选择照片的Bundle
+ (NSBundle *)ZLImagePickerExpression;



@end
