//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderFileModel.h"
#import "MFFileDownloaderTool.h"
#import "MFFileDownloaderCommonResultModel.h"
#import "MFFileDownloaderFMDBManager.h"


@implementation MFFileDownloaderFileModel {
}

- (instancetype)initWithId:(NSString *)id name:(NSString *)name url:(NSString *)url furUrl:(NSString *)furUrl mediaType:(int)mediaType during:(CGFloat)during imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight status:(int)status version:(int)version createDate:(NSDate *)createDate updateDate:(NSDate *)updateDate localPath:(NSString *)localPath {
    self = [super init];
    if (self) {
        self.id = id;
        self.name = name;
        self.url = url;
        self.furUrl = furUrl;
        self.mediaType = mediaType;
        self.during = during;
        self.imageWidth = imageWidth;
        self.imageHeight = imageHeight;
        self.status = status;
        self.version = version;
        self.createDate = createDate;
        self.updateDate = updateDate;
        self.localPath = localPath;
    }

    return self;
}

+ (instancetype)modelWithId:(NSString *)id name:(NSString *)name url:(NSString *)url furUrl:(NSString *)furUrl mediaType:(int)mediaType during:(CGFloat)during imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight status:(int)status version:(int)version createDate:(NSDate *)createDate updateDate:(NSDate *)updateDate localPath:(NSString *)localPath {
    return [[self alloc] initWithId:id name:name url:url furUrl:furUrl mediaType:mediaType during:during imageWidth:imageWidth imageHeight:imageHeight status:status version:version createDate:createDate updateDate:updateDate localPath:localPath];
}

- (MFFileDownloaderCommonResultModel *)isModelValid {
    int status = 0;
    NSString *msg = @"";
    NSString *data = @"";
    if (![MFFileDownloaderTool isStringNotNull:self.id]) {
        status = -1;
        msg = @"id为空";
    } else if (![MFFileDownloaderTool isStringNotNull:self.name]) {
        status = -1;
        msg = @"name为空";
    } else if (![MFFileDownloaderTool isStringNotNull:self.url]) {
        status = -1;
        msg = @"url为空";
    } else if (self.mediaType <= 0) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为>0, 当前为%d", self.mediaType];
    } else if (self.status < 1) {
        status = -1;
        msg = [NSString stringWithFormat:@"未设置status 1 启用 2 未启用"];
    } else if (self.version < 1) {
        status = -1;
        msg = [NSString stringWithFormat:@"未设置version"];
    } else {
        status = 0;
        data = @"success";
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:status
                                                          msg:msg
                                                         data:data];
}

- (MFFileDownloaderCommonResultModel *)isModelCanInsert {
    int status = 0;
    NSString *msg = @"";
    NSString *data = @"";
    if (![MFFileDownloaderTool isStringNotNull:self.name]) {
        status = -1;
        msg = @"name为空";
    } else if (![MFFileDownloaderTool isStringNotNull:self.url]) {
        status = -1;
        msg = @"url为空";
    } else if (self.mediaType <= 0) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为>0, 当前为%d", self.mediaType];
    } else {
        status = 0;
        data = @"success";
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:status
                                                          msg:msg
                                                         data:data];
}

- (MFFileDownloaderCommonResultModel *)isModelCanUpdate {
    int status = 0;
    NSString *msg = @"";
    NSString *data = @"";
    if (![MFFileDownloaderTool isStringNotNull:self.id]) {
        status = -1;
        msg = @"id为空";
    } else if (![MFFileDownloaderTool isStringNotNull:self.name]) {
        status = -1;
        msg = @"name为空";
    } else if (![MFFileDownloaderTool isStringNotNull:self.url]) {
        status = -1;
        msg = @"url为空";
    } else if (self.mediaType <= 0) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为>0, 当前为%d", self.mediaType];
    } else if (self.mediaType == 2 && ![MFFileDownloaderTool isStringNotNull:self.furUrl]) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为2时furUrl不可为空"];
    } else if (self.status < 1) {
        status = -1;
        msg = [NSString stringWithFormat:@"未设置status 1 启用 2 未启用"];
    } else if (self.version < 1) {
        status = -1;
        msg = [NSString stringWithFormat:@"未设置version"];
    } else {
        status = 0;
        data = @"success";
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:status
                                                          msg:msg
                                                         data:data];
}

- (NSString *)fullLocalPath {
    return [NSString stringWithFormat:@"%@/%@", MFFileDownloaderFMDBManager.documentBaseDirection, self.localPath];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"  self.id=%@ \r", self.id];
    [description appendFormat:@"  self.name=%@ \r", self.name];
    [description appendFormat:@"  self.url=%@ \r", self.url];
    [description appendFormat:@"  self.furUrl=%@ \r", self.furUrl];
    [description appendFormat:@"  self.mediaType=%i \r", self.mediaType];
    [description appendFormat:@"  self.during=%lf \r", self.during];
    [description appendFormat:@"  self.imageWidth=%lf \r", self.imageWidth];
    [description appendFormat:@"  self.imageHeight=%lf \r", self.imageHeight];
    [description appendFormat:@"  self.status=%i \r", self.status];
    [description appendFormat:@"  self.version=%i \r", self.version];
    [description appendFormat:@"  self.downloadStatus=%ld \r", (long) self.downloadStatus];
    [description appendFormat:@"  self.createDate=%@ \r", self.createDate];
    [description appendFormat:@"  self.updateDate=%@ \r", self.updateDate];
    [description appendFormat:@"  self.localPath=%@ \r", self.localPath];
    [description appendString:@">"];
    return description;
}


@end