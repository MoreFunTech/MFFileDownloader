//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownLoaderFileModel.h"
#import "MFFileDownLoaderTool.h"
#import "MFFileDownloaderCommonResultModel.h"


@implementation MFFileDownLoaderFileModel {
}

- (MFFileDownloaderCommonResultModel *)sqlInsertSyntaxWithTableName:(NSString *)tableName {
    if (![MFFileDownLoaderTool isStringNotNull:tableName]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"表名为空" data:@""];
    }
    MFFileDownloaderCommonResultModel *isModelValid = [self isModelValid];
    if (isModelValid.status < 0) {
        return isModelValid;
    }

    if (![MFFileDownLoaderTool isStringNotNull:self.furUrl]) {
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
    if (![MFFileDownLoaderTool isStringNotNull:tableName]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"表名为空" data:@""];
    }
    MFFileDownloaderCommonResultModel *isModelValid = [self isModelValid];
    if (isModelValid.status < 0) {
        return isModelValid;
    }

    if (![MFFileDownLoaderTool isStringNotNull:self.furUrl]) {
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

//    [sqlStr appendFormat:@"( %@ ) VALUES ( %@ );", MFFileDownLoaderFileModel.keyNames, MFFileDownLoaderFileModel.keyList];
    NSString *resultMsg = @"";
    NSString *resultData = @"Success";
    int resultStatus = 0;
    return [MFFileDownloaderCommonResultModel modelWithStatus:resultStatus
                                                          msg:resultMsg
                                                         data:resultData];
}

- (MFFileDownloaderCommonResultModel *)isModelValid {
    int status = 0;
    NSString *msg = @"";
    NSString *data = @"";
    if (![MFFileDownLoaderTool isStringNotNull:self.id]) {
        status = -1;
        msg = @"id为空";
    } else if (![MFFileDownLoaderTool isStringNotNull:self.name]) {
        status = -1;
        msg = @"name为空";
    } else if (![MFFileDownLoaderTool isStringNotNull:self.url]) {
        status = -1;
        msg = @"name为空";
    } else if (self.mediaType <= 0 || self.mediaType > 6) {
        status = -1;
        msg = [NSString stringWithFormat:@"mediaType需要为1~6, 当前为%d", self.mediaType];
    } else if (self.mediaType == 2 && ![MFFileDownLoaderTool isStringNotNull:self.furUrl]) {
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