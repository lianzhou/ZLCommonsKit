//
//  UIImage+Picker.m
//  AFNetworking
//
//  Created by li_chang_en on 2017/11/14.
//

#import "UIImage+Picker.h"

@implementation UIImage (Picker)

+ (NSString *)bundlePickerName:(NSString *)iconName{
    NSString *imagePath = [@"ENImagePickerExpression.bundle" stringByAppendingPathComponent:iconName];
    return imagePath;
}
+ (UIImage *)imageNamedWithPickerName:(NSString *)name {
    NSString *  imageName = [self bundlePickerName:name];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
}

@end
