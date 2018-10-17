//
//  ZLUploadFileModel.m
//  ZLCommonsKit
//
//  Created by li_chang_en on 2017/11/18.
//

#import "ZLUploadFileModel.h"
#import "ZLStringMacrocDefine.h"
#import <YYKit.h>
#import "ZLDataHandler.h"


@interface ZLUploadFileModel()

@property(nonatomic, copy,readwrite) NSString     *fileName;
@property(nonatomic, copy,readwrite) NSString     *fileType;


@end

@implementation ZLUploadFileModel
+ (ZLUploadFileModel *)fileWithImage:(UIImage *)image {
    return [[ZLUploadFileModel alloc] initWithImage:image];

}
+ (ZLUploadFileModel *)fileWithImageData:(NSData *)imageData {
    return [[ZLUploadFileModel alloc] initWithImageData:imageData];

}
+ (ZLUploadFileModel *)fileWithFileFullPath:(NSString *)filePath {
    return [[ZLUploadFileModel alloc] initWithFileFullPath:filePath];
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}
- (instancetype)initWithImageData:(NSData *)imageData
{
    self = [super init];
    if (self) {
        self.fileData = imageData;
    }
    return self;
}

- (instancetype)initWithFileFullPath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.fileFullPath = filePath;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.fileData = UIImagePNGRepresentation(image);
    
//     self.fileData = UIImageJPEGRepresentation(image, 0.6);
}

- (void)setFileData:(NSData *)fileData {
    _fileData = fileData;
    if (!fileData) {
        self.fileType = @"png";
        self.fileName = [NSString stringWithFormat:@"%@%@.%@",[ZLDataHandler currentTimeString],[self randomNameString],self.fileType];
        return;
    }
    YYImageType imageType =  YYImageDetectType((__bridge CFDataRef)fileData);
    NSString * fileType = YYImageTypeGetExtension(imageType);
    if (!ZLStringIsNull(fileType)) {
        self.fileType = fileType;
    }else{
        self.fileType = @"png";
    }
    self.fileName = [NSString stringWithFormat:@"%@%@.%@",[ZLDataHandler currentTimeString],[self randomNameString],self.fileType];

}

- (void)setFileFullPath:(NSString *)fileFullPath {
    _fileFullPath = fileFullPath;
    if (ZLStringIsNull(fileFullPath)) {
        self.fileType = @"mp4";
        self.fileName = [NSString stringWithFormat:@"%@%@.%@",[ZLDataHandler currentTimeString],[self randomNameString],self.fileType];
        return;
    }
    NSString *extension = [fileFullPath pathExtension];
    if (!ZLStringIsNull(extension)) {
        self.fileType = extension;
    }
    NSString *lastPathComponent = [fileFullPath lastPathComponent];
    if (!ZLStringIsNull(lastPathComponent)) {
        self.fileName = lastPathComponent;
    }
}

//随机值
- (NSString *)randomNameString {
    
    NSInteger num = (arc4random() % 100000);
    return  [NSString stringWithFormat:@"%.5ld",num];
}

@end

@interface ZLFileContentModel()

@property(nonatomic, copy,readwrite) NSString     *fileType;

@end
@implementation ZLFileContentModel

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    if (ZLStringIsNull(fileName)) {
        self.fileType = @"png";
        return;
    }
    NSString *fileType = [fileName pathExtension];
    if (ZLStringIsNull(fileName)) {
        self.fileType = @"png";
    }else{
        self.fileType = fileType;
    }
}

@end
