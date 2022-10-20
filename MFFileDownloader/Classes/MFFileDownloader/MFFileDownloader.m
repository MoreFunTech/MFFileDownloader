//
//  MFFileDownloader.m
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import "MFFileDownloader.h"
#import <AFNetworking/AFNetworking.h>
#import "MFFileDownloaderManager.h"
#import "MFFileDownloaderTaskUnit.h"

@implementation MFFileDownloader

+ (void)addDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    [self addDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) { }];
}

+ (void)addDownloadFile:(MFFileDownloaderFileModel *)fileModel
            resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    MFFileDownloaderCommonResultModel *validResult = [self judgeValidDownloadFile:fileModel];
    if (validResult.status < 0) {
        resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:validResult.status userInfo:@{NSLocalizedDescriptionKey: validResult.msg}]]);
        return;
    }

    [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url resultBlock:^(MFFileDownloaderCommonResultModel *searchModel) {
        if (searchModel.status < 0) {
            resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:searchModel.status userInfo:@{NSLocalizedDescriptionKey: searchModel.msg}]]);
            return;
        }
        if ([searchModel.data isKindOfClass:[NSArray class]]) {
            NSArray *list = searchModel.data;
            if (list.count < 1) {
                [MFFileDownloader addDownloadInsertDataBaseFile:fileModel resultBlock:resultBlock];
                return;
            }
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadNot || fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
                [self preStartDownloadWithFileModel:fileModel1 resultBlock:resultBlock];
                return;
            }
            if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloading) {
                resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel1 downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"文件正在下载中"}]]);
                return;
            }
            if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadFinish) {
                if ([NSFileManager.defaultManager fileExistsAtPath:fileModel1.fullLocalPath]) {
                    resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel1 downloadStatus:(MFFileDownloaderDownloadStatusDownloadFinish) error:nil]);
                    return;
                } else {
                    [self preStartDownloadWithFileModel:fileModel1 resultBlock:resultBlock];
                    return;
                }
            } else {
                resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel1 downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"未知状态, 请更新版本"}]]);
                return;
            }
            return;
        }
        resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"未知状态, 请更新版本"}]]);
        return;
    }];
    
}

+ (void)addDownloadInsertDataBaseFile:(MFFileDownloaderFileModel *)fileModel
                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    [MFFileDownloaderFMDBManager insertDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *insertModel) {
        if (insertModel.status < 0) {
            resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:insertModel.status userInfo:@{NSLocalizedDescriptionKey: insertModel.msg}]]);
            return;
        }
        [self preStartDownloadWithFileModel:fileModel resultBlock:resultBlock];
    }];
}


+ (void)reDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    [self reDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) { }];
}

+ (void)reDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    MFFileDownloaderCommonResultModel *validResult = [self judgeValidDownloadFile:fileModel];
    if (validResult.status < 0) {
        resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:validResult.status userInfo:@{NSLocalizedDescriptionKey: validResult.msg}]]);
        return;
    }
    
    [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url resultBlock:^(MFFileDownloaderCommonResultModel *searchModel) {
        if (searchModel.status < 0) {
            resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:searchModel.status userInfo:@{NSLocalizedDescriptionKey: searchModel.msg}]]);
            return;
        }
        
        if ([searchModel.data isKindOfClass:[NSArray class]]) {
            NSArray *list = searchModel.data;
            if (list.count < 1) {
                [MFFileDownloader reDownloadInsertDataBaseFile:fileModel resultBlock:resultBlock];
                return;
            }
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            NSError *error;
            NSURL *pathUrl = [NSURL fileURLWithPath:fileModel1.fullLocalPath];
            BOOL removeSuccess = [NSFileManager.defaultManager removeItemAtURL:pathUrl error:&error];
            if ([NSFileManager.defaultManager fileExistsAtPath:fileModel1.fullLocalPath]) {
                if (!removeSuccess || error) {
                    resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"旧文件移除失败"}]]);
                    return;
                }
            }
            [self preStartDownloadWithFileModel:fileModel1 resultBlock:resultBlock];
            return;
        }
        resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"未知状态, 请更新版本"}]]);
        return;
    }];

}

+ (void)reDownloadInsertDataBaseFile:(MFFileDownloaderFileModel *)fileModel
                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    [MFFileDownloaderFMDBManager insertDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *insertModel) {
        if (insertModel.status < 0) {
            resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:insertModel.status userInfo:@{NSLocalizedDescriptionKey: insertModel.msg}]]);
            return;
        }
        [self preStartDownloadWithFileModel:fileModel resultBlock:resultBlock];
    }];
}

+ (void)getAllDataWithResultBlock:(void(^)(MFFileDownloaderCommonResultModel *))resultBlock {
    [MFFileDownloaderFMDBManager getAllDataWithResultBlock:resultBlock];
}

+ (void)getAllDownloadedDataWithResultBlock:(void(^)(MFFileDownloaderCommonResultModel *))resultBlock {
    [MFFileDownloaderFMDBManager getAllDownloadedDataWithResultBlock:resultBlock];
}

+ (void)getAllDownloadingDataWithResultBlock:(void(^)(MFFileDownloaderCommonResultModel *))resultBlock {
    [MFFileDownloaderFMDBManager getAllDownloadingDataWithResultBlock:resultBlock];;
}

+ (void)clearAllDownloadFiles {
    [MFFileDownloaderFMDBManager clearAllDownloadFiles];
}

+ (MFFileDownloaderCommonResultModel *)judgeValidDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    if (![MFFileDownloaderTool isStringNotNull:fileModel.url]) {
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
    [MFFileDownloaderFMDBManager defaultConfigure];
    fileModel.name = fileName;
    return [MFFileDownloaderCommonResultModel modelWithStatus:0 msg:@"" data:@"Success"];
}

+ (void)preStartDownloadWithFileModel:(MFFileDownloaderFileModel *)fileModel
                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
    if (![MFFileDownloaderTool isStringNotNull:fileModel.id]) {
//        MFFileDownloaderCommonResultModel *searchResult =
        [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url resultBlock:^(MFFileDownloaderCommonResultModel *searchResult) {
            MFFileDownloaderLog.logDebug(@"preStartDownloadWithFileModel");
            if ([searchResult.data isKindOfClass:[NSArray class]]) {
                NSArray *list = searchResult.data;
                if (list.count > 0) {
                    MFFileDownloaderFileModel *fileModel1 = list.firstObject;
                    fileModel.id = fileModel1.id;
                    fileModel.status = fileModel1.status;
                    fileModel.version = fileModel1.version;
                    fileModel.localPath = fileModel1.localPath;
                }
            }
            [MFFileDownloader preStartDownloadUpdateDataBaseWithFileModel:fileModel resultBlock:resultBlock];
        }];
        
    } else {
        [MFFileDownloader preStartDownloadUpdateDataBaseWithFileModel:fileModel resultBlock:resultBlock];
    }
}

+ (void)preStartDownloadUpdateDataBaseWithFileModel:(MFFileDownloaderFileModel *)fileModel
                                        resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    
    [MFFileDownloaderFMDBManager updateDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *updateResult) {
        if (updateResult.status < 0) {
            resultBlock([MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel downloadStatus:(MFFileDownloaderDownloadStatusDownloadError) error:[NSError errorWithDomain:@"com.mfFileDownloader.error" code:updateResult.status userInfo:@{NSLocalizedDescriptionKey: updateResult.msg}]]);
            return;
        }
        [MFFileDownloader startDownloadWithFileModel:fileModel resultBlock:resultBlock];
        return;
    }];
    
}

+ (void)startDownloadWithFileModel:(MFFileDownloaderFileModel *)fileModel
                       resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {

    MFFileDownloaderTaskUnit *unit = [MFFileDownloaderManager.sharedInstance addNewDownTaskWithUrl:fileModel.url localPath:fileModel.fullLocalPath];
    unit.downloadStatusChangeBlock = ^(MFFileDownloaderDownloadStatus status, NSProgress * _Nullable progress, NSError * _Nullable error) {
        switch (status) {
            case MFFileDownloaderDownloadStatusDownloading:
                [MFFileDownloader downloadingWithFileModel:fileModel progress:progress resultBlock:resultBlock];
                break;
            case MFFileDownloaderDownloadStatusDownloadFinish:
                [MFFileDownloader downloadfinishWithFileModel:fileModel resultBlock:resultBlock];
                break;
            default:
                [MFFileDownloader downloadErrorWithFileModel:fileModel error:error resultBlock:resultBlock];
                break;
        }
    };

}

+ (void)downloadingWithFileModel:(MFFileDownloaderFileModel *)fileModel
                        progress:(NSProgress * _Nullable)progress
                     resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
    [MFFileDownloaderFMDBManager updateDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *commonResultModel) {
        resultBlock(
                    [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                             downloadStatus:MFFileDownloaderDownloadStatusDownloading
                                                                   progress:progress]
        );
    }];
    
}

+ (void)downloadfinishWithFileModel:(MFFileDownloaderFileModel *)fileModel resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
    [MFFileDownloaderFMDBManager updateDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *commonResultModel) {
        resultBlock(
                    [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                             downloadStatus:MFFileDownloaderDownloadStatusDownloadFinish]
        );
    }];
}

+ (void)downloadErrorWithFileModel:(MFFileDownloaderFileModel *)fileModel error:(NSError * _Nullable)error resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
    [MFFileDownloaderFMDBManager updateDataWithModel:fileModel resultBlock:^(MFFileDownloaderCommonResultModel *commonResultModel) {
        resultBlock(
                    [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                             downloadStatus:MFFileDownloaderDownloadStatusDownloadError
                                                                      error:error]
        );
    }];
}



@end
