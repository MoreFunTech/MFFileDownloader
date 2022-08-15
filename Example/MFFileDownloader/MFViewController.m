//
//  MFViewController.m
//  MFFileDownloader
//
//  Created by NealWills on 08/10/2022.
//  Copyright (c) 2022 NealWills. All rights reserved.
//

//#import "MFFileDownloader.h"
#import "MFViewController.h"

@import MFFileDownloader;

@interface MFViewController ()

@end

@implementation MFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    MFFileDownloaderLog.setModuleName(@"MFKit");
    MFFileDownloaderLog.setMinLogLevel(MFFileDownloaderLogLevelNormal);
    [MFFileDownloaderFMDBManager defaultConfigure];

    MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
    fileModel.url = @"https://ruiqu-1304540262.sutanapp.com/386e3c4e5da14269554fa547a9302066.pag";
    fileModel.mediaType = 6;
    fileModel.name = @"test.pag";
    MFFileDownloaderCommonResultModel *downloadResult = [MFFileDownloader addDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) {
        switch (model.downloadStatus) {
            case MFFileDownloaderDownloadStatusDownloadNot:
                MFFileDownloaderLog.logDebug(@"未下载");
                break;
            case MFFileDownloaderDownloadStatusDownloading:
                MFFileDownloaderLog.logDebug([NSString stringWithFormat:@"下载中 [%@]: %lli - %lli", model.fileModel.fullLocalPath, model.progress.completedUnitCount, model.progress.totalUnitCount]);
                break;
            case MFFileDownloaderDownloadStatusDownloadFinish:
                MFFileDownloaderLog.logDebug([NSString stringWithFormat:@"下载完成 [%@]", model.fileModel.fullLocalPath]);
                break;
            case MFFileDownloaderDownloadStatusDownloadError:
                MFFileDownloaderLog.logDebug([NSString stringWithFormat:@"下载出错 [%@]: %@", model.fileModel.fullLocalPath, model.error.localizedDescription]);
                break;
        }
    }];
    if ([downloadResult.data isKindOfClass:[MFFileDownloaderFileModel class]]) {
        MFFileDownloaderFileModel *model = downloadResult.data;
        fileModel.localPath = model.localPath;
    }
    if (downloadResult.status < 0) {
        MFFileDownloaderLog.logError([NSString stringWithFormat:@"下载任务添加失败 [%@]: %@", fileModel.fullLocalPath, downloadResult.msg]);
    } else {
        MFFileDownloaderLog.logDebug(@"下载开始");
    }

//    MFFileDownloaderCommonResultModel *reDownloadResult = [MFFileDownloader reDownloadFile:fileModel];
//    if (reDownloadResult.status < 0) {
//        MFFileDownloaderLog.logError(reDownloadResult.msg);
//    } else {
//        MFFileDownloaderLog.logDebug(@"下载开始");
//    }
//


//    insertModel.url = @"www.baidu.com2";
//    insertModel.mediaType = 6;
//    insertModel.name = @"test2.pag";
//    MFFileDownloaderCommonResultModel *insertResult = [MFFileDownloaderFMDBManager insertDataWithModel:insertModel];
//    if (insertResult.status >= 0) {
//        MFFileDownloaderLog.logDebug(@"数据添加成功");
//    } else {
//        MFFileDownloaderLog.logDebug(insertResult.msg);
//    }
//
//    MFFileDownloaderCommonResultModel *searchModel = [MFFileDownloaderFMDBManager searchDataWithId:@"3"];
//
//    if ([searchModel.data isKindOfClass:[NSArray class]]) {
//        NSArray *list = searchModel.data;
//        if (list.count > 0) {
//            id obj = list.firstObject;
//            if ([obj isKindOfClass:MFFileDownloaderFileModel.class ]) {
//                MFFileDownloaderFileModel *fileModel = obj;
//                fileModel.downloadStatus = 1;
//                fileModel.version = 3;
//                fileModel.status = 2;
//                fileModel.furUrl = @"123123";
//                MFFileDownloaderCommonResultModel *editResult = [MFFileDownloaderFMDBManager updateDataWithModel:fileModel];
//                if (editResult.status >= 0) {
//                    MFFileDownloaderLog.logDebug(@"数据更新成功");
//                } else {
//                    MFFileDownloaderLog.logDebug(editResult.msg);
//                }
//            }
//        }
//    }
//
//    MFFileDownloaderCommonResultModel *search2Model = [MFFileDownloaderFMDBManager searchDataWithId:@"3"];
//    MFFileDownloaderLog.logDebug(search2Model.data);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
