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
    fileModel.url = @"www.baidu.com2";
    fileModel.mediaType = 6;
    fileModel.name = @"test2.pag";
    MFFileDownloaderCommonResultModel *downloadResult = [MFFileDownloader addDownloadFile:fileModel];
    if (downloadResult.status < 0) {
        MFFileDownloaderLog.logError(downloadResult.msg);
    } else {
        MFFileDownloaderLog.logDebug(@"下载开始");
    }

    MFFileDownloaderCommonResultModel *reDownloadResult = [MFFileDownloader reDownloadFile:fileModel];
    if (reDownloadResult.status < 0) {
        MFFileDownloaderLog.logError(reDownloadResult.msg);
    } else {
        MFFileDownloaderLog.logDebug(@"下载开始");
    }



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
