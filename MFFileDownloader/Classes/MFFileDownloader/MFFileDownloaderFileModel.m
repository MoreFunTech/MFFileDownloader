//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderFileModel.h"
#import "MFFileDownloaderTool.h"
#import "MFFileDownloaderCommonResultModel.h"


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


- (MFFileDownloaderCommonResultModel *)sqlInsertSyntaxWithTableName:(NSString *)tableName {
    if (![MFFileDownloaderTool isStringNotNull:tableName]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"表名为空" data:@""];
    }
    MFFileDownloaderCommonResultModel *isModelValid = [self isModelValid];
    if (isModelValid.status < 0) {
        return isModelValid;
    }

    if (![MFFileDownloaderTool isStringNotNull:self.furUrl]) {
        self.furUrl = @"";
    }
    if (self.imageWidth <= 0) {
        self.imageWidth = 1;
    }
    if (self.imageHeight <= 0) {
        self.imageHeight = 1;
    }
    if (!self.createDate) {
        self.createDate = [[NSDate alloc] init];
    }
    if (!self.updateDate) {
        self.updateDate = [[NSDate alloc] init];
    }

    NSString *keyNames = @"id , name , url , furUrl , mediaType , during , imageWidth , imageHeight , status , version , createDate , updateDate";
    NSString *keyPlaces = @"? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ? ,  ?";
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", tableName];
    [sqlStr appendFormat:@"( %@ ) VALUES ( %@ );", keyNames, keyPlaces];
    NSString *resultMsg = @"";
    NSString *resultData = [NSString stringWithFormat:@"%@", sqlStr];
    int resultStatus = 0;
    return [MFFileDownloaderCommonResultModel modelWithStatus:resultStatus
                                                          msg:resultMsg
                                                         data:resultData];
}

- (MFFileDownloaderCommonResultModel *)sqlUpdateSyntaxWithTableName:(NSString *)tableName {
    if (![MFFileDownloaderTool isStringNotNull:tableName]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"表名为空" data:@""];
    }
    MFFileDownloaderCommonResultModel *isModelValid = [self isModelValid];
    if (isModelValid.status < 0) {
        return isModelValid;
    }

    if (![MFFileDownloaderTool isStringNotNull:self.furUrl]) {
        self.furUrl = @"";
    }
    if (self.imageWidth <= 0) {
        self.imageWidth = 1;
    }
    if (self.imageHeight <= 0) {
        self.imageHeight = 1;
    }
    if (!self.createDate) {
        self.createDate = [[NSDate alloc] init];
    }
    if (!self.updateDate) {
        self.updateDate = [[NSDate alloc] init];
    }

    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", tableName];
    [sqlStr appendString:@" name = '%@' , "];
    [sqlStr appendString:@" url = '%@' , "];
    [sqlStr appendString:@" furUrl = '%@' , "];
    [sqlStr appendString:@" mediaType = '%i' , "];
    [sqlStr appendString:@" during = '%f' , "];
    [sqlStr appendString:@" imageWidth = '%f' , "];
    [sqlStr appendString:@" imageHeight = '%f' , "];
    [sqlStr appendString:@" status = '%d' , "];
    [sqlStr appendString:@" version = '%d' , "];
    [sqlStr appendString:@" createDate = '%@' , "];
    [sqlStr appendString:@" updateDate = '%@' ;"];
    NSString *resultMsg = @"";
    NSString *resultData = [NSString stringWithFormat:@"%@", sqlStr];
    int resultStatus = 0;
    return [MFFileDownloaderCommonResultModel modelWithStatus:resultStatus
                                                          msg:resultMsg
                                                         data:resultData];
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
    } else if (self.mediaType <= 0 || self.mediaType > 6) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为1~6, 当前为%d", self.mediaType];
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


@end