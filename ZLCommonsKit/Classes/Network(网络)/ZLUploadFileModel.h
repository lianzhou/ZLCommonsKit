//
//  ZLUploadFileModel.h
//  ZLCommonsKit
//
//  Created by li_chang_en on 2017/11/18.
//

#import "ZLBaseObject.h"

//文件上传只支持本地路径上传,图片上传支持图片和data

@interface ZLUploadFileModel : ZLBaseObject

//本地路径
@property(nonatomic, copy) NSString     *fileFullPath;

//图片data
@property(nonatomic, strong) NSData       *fileData;

@property(nonatomic, strong) UIImage    *image;

//自动获取文件名和类型
@property(nonatomic, copy,readonly) NSString     *fileName;
@property(nonatomic, copy,readonly) NSString     *fileType;

+ (ZLUploadFileModel *)fileWithImage:(UIImage *)image;
+ (ZLUploadFileModel *)fileWithImageData:(NSData *)imageData;
+ (ZLUploadFileModel *)fileWithFileFullPath:(NSString *)filePath;


- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageData:(NSData *)imageData;
- (instancetype)initWithFileFullPath:(NSString *)filePath;


@end

@interface ZLFileContentModel : ZLBaseObject

@property(nonatomic, copy) NSString     *accessUrl;
@property(nonatomic, copy) NSString     *fileName;
@property(nonatomic, assign) NSInteger  fileSize;

@property(nonatomic, copy,readonly) NSString     *fileType;

@end
