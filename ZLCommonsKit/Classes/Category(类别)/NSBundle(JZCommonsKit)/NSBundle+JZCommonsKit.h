//
//  NSBundle+JZCommonsKit.h
//  JZCommonsKit
//
//  Created by li_chang_en on 2017/11/13.
//

#import <Foundation/Foundation.h>

@interface NSBundle (JZCommonsKit)

//默认图的Bundle
+ (UIImage *)bundlePlaceholderName:(NSString *)iconName;

//表情的Bundle
+ (NSBundle *)JZEmojiBundle;

//选择照片的Bundle
+ (NSBundle *)JZImagePickerExpression;



@end
