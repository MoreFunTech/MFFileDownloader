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

+ (MFFileDownloaderCommonResultModel *)addDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    return [self addDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) {

    }];
}

+ (MFFileDownloaderCommonResultModel *)addDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                           resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
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
                return [self preStartDownloadWithFileModel:fileModel resultBlock:resultBlock];
            }
        } else {
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadNot || fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
                return [self preStartDownloadWithFileModel:fileModel1 resultBlock:resultBlock];
            } else if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloading) {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-2 msg:@"文件正在下载中" data:fileModel1];
            } else if (fileModel1.downloadStatus == MFFileDownloaderDownloadStatusDownloadFinish) {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-3 msg:@"文件已存在" data:fileModel1];
            } else {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知状态, 请更新版本" data:fileModel1];
            }
        }
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知错误, 请更新版本" data:@""];
}

+ (MFFileDownloaderCommonResultModel *)reDownloadFile:(MFFileDownloaderFileModel *)fileModel {
    return [self reDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) {

    }];
}

+ (MFFileDownloaderCommonResultModel *)reDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
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
                return [self preStartDownloadWithFileModel:fileModel resultBlock:resultBlock];
            }
        } else {
            MFFileDownloaderFileModel *fileModel1 = list.firstObject;
            NSError *error;
            NSURL *pathUrl = [NSURL fileURLWithPath:fileModel1.fullLocalPath];
            BOOL removeSuccess = [NSFileManager.defaultManager removeItemAtURL:pathUrl error:&error];
            if (!removeSuccess || error) {
                return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"旧文件移除失败" data:@""];
            }
            return [self preStartDownloadWithFileModel:fileModel1 resultBlock:resultBlock];
        }
    }
    return [MFFileDownloaderCommonResultModel modelWithStatus:-1 msg:@"未知错误, 请更新版本" data:@""];
}

+ (MFFileDownloaderCommonResultModel *)getAllData {
    return [MFFileDownloaderFMDBManager getAllData];
}

+ (MFFileDownloaderCommonResultModel *)getAllDownloadedData {
    return [MFFileDownloaderFMDBManager getAllDownloadedData];;
}

+ (MFFileDownloaderCommonResultModel *)getAllDownloadingData {
    return [MFFileDownloaderFMDBManager getAllDownloadingData];;
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

+ (MFFileDownloaderCommonResultModel *)preStartDownloadWithFileModel:(MFFileDownloaderFileModel *)fileModel
                                                         resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
    if (![MFFileDownloaderTool isStringNotNull:fileModel.id]) {
        MFFileDownloaderCommonResultModel *searchResult = [MFFileDownloaderFMDBManager searchDataWithUrl:fileModel.url];
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
    }
    MFFileDownloaderCommonResultModel *updateResult = [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
    if (updateResult.status < 0) {
        return updateResult;
    }
    [self startDownloadWithFileModel:fileModel resultBlock:resultBlock];
    return [MFFileDownloaderCommonResultModel modelWithStatus:0 msg:@"" data:fileModel];

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

+ (void)downloadingWithFileModel:(MFFileDownloaderFileModel *)fileModel progress:(NSProgress * _Nullable)progress resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
    });
    if (!resultBlock) {
      return;
    }
    resultBlock(
                [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                         downloadStatus:MFFileDownloaderDownloadStatusDownloading
                                                               progress:progress]
    );
}

+ (void)downloadfinishWithFileModel:(MFFileDownloaderFileModel *)fileModel resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
    });
    if (!resultBlock) {
      return;
    }
    resultBlock(
                [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                         downloadStatus:MFFileDownloaderDownloadStatusDownloadFinish]
    );
}

+ (void)downloadErrorWithFileModel:(MFFileDownloaderFileModel *)fileModel error:(NSError * _Nullable)error resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock {
    
    fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
    });
    if (!resultBlock) {
      return;
    }
    resultBlock(
                [MFFileDownloaderDownloadResultModel modelWithFileModel:fileModel
                                                         downloadStatus:MFFileDownloaderDownloadStatusDownloadError
                                                                  error:error]
    );
    
}



@end
