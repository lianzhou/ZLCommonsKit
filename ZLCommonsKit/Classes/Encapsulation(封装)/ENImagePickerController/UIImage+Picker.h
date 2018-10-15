//
//  UIImage+Picker.h
//  AFNetworking
//
//  Created by li_chang_en on 2017/11/14.
//

#import <UIKit/UIKit.h>

@interface UIImage (Picker)

+ (NSString *)bundlePickerName:(NSString *)iconName;

+ (UIImage *)imageNamedWithPickerName:(NSString *)name;

@end
