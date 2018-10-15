//
//  JZUploadFileModel.m
//  JZCommonsKit
//
//  Created by li_chang_en on 2017/11/18.
//

#import "JZUploadFileModel.h"
#import "JZStringMacrocDefine.h"
#import <YYKit.h>
#import "JZDataHandler.h"


@interface JZUploadFileModel()

@property(nonatomic, copy,readwrite) NSString     *fileName;
@property(nonatomic, copy,readwrite) NSString     *fileType;


@end

@implementation JZUploadFileModel
+ (JZUploadFileModel *)fileWithImage:(UIImage *)image {
    return [[JZUploadFileModel alloc] initWithImage:image];

}
+ (JZUploadFileModel *)fileWithImageData:(NSData *)imageData {
    return [[JZUploadFileModel alloc] initWithImageData:imageData];

}
+ (JZUploadFileModel *)fileWithFileFullPath:(NSString *)filePath {
    return [[JZUploadFileModel alloc] initWithFileFullPath:filePath];
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
        self.fileName = [NSString stringWithFormat:@"%@%@.%@",[JZDataHandler currentTimeString],[self randomNameString],self.fileType];
        return;
    }
    YYImageType imageType =  YYImageDetectType((__bridge CFDataRef)fileData);
    NSString * fileType = YYImageTypeGetExtension(imageType);
    if (!JZStringIsNull(fileType)) {
        self.fileType = fileType;
    }else{
        self.fileType = @"png";
    }
    self.fileName = [NSString stringWithFormat:@"%@%@.%@",[JZDataHandler currentTimeString],[self randomNameString],self.fileType];

}

- (void)setFileFullPath:(NSString *)fileFullPath {
    _fileFullPath = fileFullPath;
    if (JZStringIsNull(fileFullPath)) {
        self.fileType = @"mp4";
        self.fileName = [NSString stringWithFormat:@"%@%@.%@",[JZDataHandler currentTimeString],[self randomNameString],self.fileType];
        return;
    }
    NSString *extension = [fileFullPath pathExtension];
    if (!JZStringIsNull(extension)) {
        self.fileType = extension;
    }
    NSString *lastPathComponent = [fileFullPath lastPathComponent];
    if (!JZStringIsNull(lastPathComponent)) {
        self.fileName = lastPathComponent;
    }
}

//随机值
- (NSString *)randomNameString {
    
    NSInteger num = (arc4random() % 100000);
    return  [NSString stringWithFormat:@"%.5ld",num];
}

@end

@interface JZFileContentModel()

@property(nonatomic, copy,readwrite) NSString     *fileType;

@end
@implementation JZFileContentModel

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    if (JZStringIsNull(fileName)) {
        self.fileType = @"png";
        return;
    }
    NSString *fileType = [fileName pathExtension];
    if (JZStringIsNull(fileName)) {
        self.fileType = @"png";
    }else{
        self.fileType = fileType;
    }
}

@end
