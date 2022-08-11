//
//  MFFileDownloader.m
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import "MFFileDownloader.h"

@implementation MFFileDownloader

+ (MFFileDownloaderCommonResultModel *)addDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    MFFileDownloaderCommonResultModel *validResult = [self judgeValidDownloadFile:fileModel];
    if (validResult.status < 0) {
        return validResult;
    }
    MFFileDownloaderCommonResultModel *searchModel = [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url];
    if (searchModel.status < 0) {
        return searchModel;
    }
    if ([searchModel.data isKindOfClass:[NSArray class]]) {
        NSArray *list = searchModel.data;
        if (list.count < 1) {
            MFFileDownloaderCommonResultModel *insertModel = [MFFileDownloaderFMDBManager insertDataWithModel:fileModel];
            if (insertModel.status < 0) {
                return insertModel;
            } else {
                return [self preStartDownloadWithFileModel:fileModel];
            }
        } else {
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            if (fileModel1.downloadStatus == 0) {
                return [self preStartDownloadWithFileModel:fileModel1];
            } else if (fileModel1.downloadStatus == 1) {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-2 msg:@"文件正在下载中" data:fileModel1];
            } else if (fileModel1.downloadStatus == 2) {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-3 msg:@"文件已存在" data:fileModel1];
            } else {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知状态, 请更新版本" data:fileModel1];
            }
        }
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知错误, 请更新版本" data:@""];
}

+ (MFFileDownloaderCommonResultModel *)reDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    MFFileDownloaderCommonResultModel *validResult = [self judgeValidDownloadFile:fileModel];
    if (validResult.status < 0) {
        return validResult;
    }
    MFFileDownloaderCommonResultModel *searchModel = [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url];
    if (searchModel.status < 0) {
        return searchModel;
    }
    if ([searchModel.data isKindOfClass:[NSArray class]]) {
        NSArray *list = searchModel.data;
        if (list.count < 1) {
            MFFileDownloaderCommonResultModel *insertModel = [MFFileDownloaderFMDBManager insertDataWithModel:fileModel];
            if (insertModel.status < 0) {
                return insertModel;
            } else {
                return [self preStartDownloadWithFileModel:fileModel];
            }
        } else {
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            return [self preStartDownloadWithFileModel:fileModel1];
        }
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知错误, 请更新版本" data:@""];
}

+ (MFFileDownloaderCommonResultModel *)judgeValidDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    if ([MFFileDownloaderTool isStringNotNull:fileModel.url]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"url 不合法" data:@""];
    }
    NSString *fileName = fileModel.name;
    if (![MFFileDownloaderTool isStringNotNull:fileName]) {
        fileName = fileModel.url.lastPathComponent;
    }
    if (![MFFileDownloaderTool isStringNotNull:fileName]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"url 不合法" data:@""];
    }
    if (fileModel.mediaType < 1) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"mediaType 不合法" data:@""];
    }
    if (fileModel.mediaType == 2 && ![MFFileDownloaderTool isStringNotNull:fileModel.furUrl]) {
        return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"furUrl 不合法" data:@""];
    }
    [MFFileDownloaderFMDBManager defaultConfigure];
    fileModel.name = fileName;
    return [MFFileDownloaderCommonResultModel modelWithStatus:0 msg:@"" data:@"Success"];
}

+ (MFFileDownloaderCommonResultModel *)preStartDownloadWithFileModel:(MFFileDownloaderFileModel *)fileModel {

    fileModel.downloadStatus = 1;
    MFFileDownloaderCommonResultModel *updateResult = [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
    if (updateResult.status < 0) {
        return updateResult;
    }
    [self startDownloadWithUrl:fileModel.url filePath:fileModel.localPath];
    return [MFFileDownloaderCommonResultModel modelWithStatus:0 msg:@"" data:fileModel];

}

+ (void)startDownloadWithUrl:(NSString *)url filePath:(NSString *)filePath {

}

@end
