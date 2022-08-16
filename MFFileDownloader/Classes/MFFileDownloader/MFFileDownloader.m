//
//  MFFileDownloader.m
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import "MFFileDownloader.h"
#import <AFNetworking/AFNetworking.h>

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
            BOOL removeSuccess = [NSFileManager.defaultManager removeItemAtPath:fileModel1.localPath error:&error];
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

    /**
     * TODO:- 这里后面会换成UNIT文件进行管理， 可以设计最大任务数量以及断点续传的功能
     * 目前赶时间, 后面再说, 先完成基本功能
     */

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileModel.url]];

    NSURLSessionDownloadTask *task = [AFHTTPSessionManager.manager downloadTaskWithRequest:request
                                                                                  progress:^(NSProgress *downloadProgress) {
                                                                                      if (fileModel.downloadStatus != MFFileDownloaderDownloadStatusDownloading) {
                                                                                          fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
                                                                                          [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
                                                                                      }
                                                                                      if (!resultBlock) {
                                                                                          return;
                                                                                      }
                                                                                      resultBlock(
                                                                                              [MFFileDownloaderDownloadResultModel           modelWithFileModel:fileModel
                                                                                                                                       downloadStatus:MFFileDownloaderDownloadStatusDownloading
                                                                                                                                             progress:downloadProgress]
                                                                                      );
                                                                                  }
                                                                               destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                                   NSString *documentPath = MFFileDownloaderFMDBManager.documentBaseDirection;
                                                                                   NSString *localPath = [NSString stringWithFormat:@"%@/%@", documentPath, fileModel.localPath];
                                                                                   return [NSURL fileURLWithPath:localPath];
                                                                               }
                                                                         completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

                                                                             if (error) {
                                                                                 fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
                                                                                 [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
                                                                             } else {
                                                                                 fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
                                                                                 [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
                                                                             }
                                                                             if (!resultBlock) {
                                                                                 return;
                                                                             }
                                                                             if (error) {
                                                                                 resultBlock(
                                                                                         [MFFileDownloaderDownloadResultModel              modelWithFileModel:fileModel
                                                                                                                                  downloadStatus:MFFileDownloaderDownloadStatusDownloadError
                                                                                                                                           error:error]
                                                                                 );
                                                                                 return;
                                                                             }
                                                                             fileModel.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
                                                                             [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
                                                                             resultBlock(
                                                                                     [MFFileDownloaderDownloadResultModel     modelWithFileModel:fileModel
                                                                                                                              downloadStatus:MFFileDownloaderDownloadStatusDownloadFinish]
                                                                             );
                                                                         }];
    [task resume];
//    AFNet

}

@end
