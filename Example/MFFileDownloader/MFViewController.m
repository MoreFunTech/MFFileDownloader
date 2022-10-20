//
//  MFViewController.m
//  MFFileDownloader
//
//  Created by NealWills on 08/10/2022.
//  Copyright (c) 2022 NealWills. All rights reserved.
//

//#import "MFFileDownloader.h"
#import "MFViewController.h"

#import "MFFileDownloaderManager.h"

@import MFFileDownloader;

@interface MFViewController () <MFFileDownloaderManagerProtocol>

@end

@implementation MFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    MFFileDownloaderLog.setModuleName(@"MFKit");
    MFFileDownloaderLog.setMinLogLevel(MFFileDownloaderLogLevelNormal);
    [MFFileDownloaderFMDBManager defaultConfigure];
    
    MFFileDownloaderManager.sharedInstance.pluginDelegate = self;


    NSArray *downloadList = @[
//            @"https://xidi-1251320985.sutanapp.com/7e9536cbcfbd150a5637e9f7929fe7ed1",
//            @"https://xidi-1251320985.sutanapp.com/3ac75690e01ada4094f298e97ed5901a",
//            @"https://xidi-1251320985.sutanapp.com/d26c8fbe6429482d7e56d2e98ab7772b",
//            @"https://ruiqu-1304540262.sutanapp.com/3364b369f42fc96e6fc539aef0e65c0b.svga",
//            @"https://xidi-1251320985.sutanapp.com/05d13b00aca20d9dbbf2ed4ed974d843",
//            @"https://xidi-1251320985.sutanapp.com/ba7fd9c2a33caf879d75d8dd7089cf28",
//            @"https://xidi-1251320985.sutanapp.com/3cd4e853c9b7c83e45de273c946c6e41",
//            @"https://xidi-1251320985.sutanapp.com/eca91c4504d46486cdff415aca8ffdae",
//            @"https://ruiqu-1304540262.picgz.myqcloud.com/7a290b3f42442c13a23c74af3f8715a5",
//            @"https://xidi-1251320985.sutanapp.com/46f08dd28908acd4b58dbd3373ce6b1c",
//            @"https://xidi-1251320985.sutanapp.com/617636546ee7337d19c6caf3772955d3",
//            @"https://xidi-1251320985.sutanapp.com/521c181cca506bcde5327bc59a897f8a",
//            @"https://xidi-1251320985.sutanapp.com/86ecf6d791f4bce6beb1baa62d7f3dff",
//            @"https://ruiqu-1304540262.sutanapp.com/cb8b4ad7755390853249455ec1ea4a02.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/e2b60115272c2ba199315d92bb7cb330.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/cc2585370db795fa0e464c157157e4b4.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/4b2b0a0f054f73292d98d8ab5ea19676.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/91a0943c02f2cf7b201e16c706001f77.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/76133556b6aeca3088fdb705be9fbb14.svga",
//            @"https://ruiqu-1304540262.sutanapp.com/ec999da559be82327047f5d37549be2f.svga",
        
        @"https://yuquan-1304540262.cos.ap-guangzhou.myqcloud.com/pid001.zip"
    ];

    int totalCount = 0;
    for (int i = 0; i < downloadList.count; ++i) {
        MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
        fileModel.url = downloadList[i];
        fileModel.mediaType = 5;
//        fileModel.name = @"test.pag";
        MFFileDownloaderCommonResultModel *downloadResult = [MFFileDownloader reDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) {
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




- (MFFileDownloaderPluginFirstDownloadFailureUnit *)firstDownloadFailWithUrl:(NSURL *)url {
//
    NSString *newUrl = @"http://yuquan-1304540262.cos.ap-guangzhou.myqcloud.com/pid001.zip?q-sign-algorithm=sha1&q-ak=AKIDgfa2lxhzSZuNYkVrxtat0pRLduf4RaQL&q-sign-time=1666246008;1666249608&q-key-time=1666246008;1666249608&q-header-list=host;x-cos-security-token&q-url-param-list=&q-signature=043e905b14ad9b5f597ff85809b9b5fcd13bdc9b&x-cos-security-token=24a0bccda3e432cdc02712ccb263505691bc9f4430001";
    MFFileDownloaderLog.logDebug([NSString stringWithFormat:@"重解析地址 [origin: %@ | new: %@]", url, newUrl]);
    MFFileDownloaderPluginFirstDownloadFailureUnit *unit = [[MFFileDownloaderPluginFirstDownloadFailureUnit alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (unit.redownloadReadyBlock) {
            unit.redownloadReadyBlock(newUrl);
        }
    });
    
    return unit;
}

- (void)reDownloadFailWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl {
    
}

- (void)downloadSuccessWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl data:(NSData *)data {
    
}

@end
