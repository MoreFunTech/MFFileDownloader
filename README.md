# MFFileDownloader

![Logo](https://github.com/MoreFunTech/MFFileDownloader/blob/main/icons/logo.png?raw=true)

[![CI Status](https://img.shields.io/travis/NealWills/MFFileDownloader.svg?style=flat)](https://travis-ci.org/NealWills/MFFileDownloader)
[![Version](https://img.shields.io/cocoapods/v/MFFileDownloader.svg?style=flat)](https://cocoapods.org/pods/MFFileDownloader)
[![License](https://img.shields.io/cocoapods/l/MFFileDownloader.svg?style=flat)](https://cocoapods.org/pods/MFFileDownloader)
[![Platform](https://img.shields.io/cocoapods/p/MFFileDownloader.svg?style=flat)](https://cocoapods.org/pods/MFFileDownloader)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

```objectivec
    pod 'AFNetworking', '~> 4.0'
    pod 'FMDB', '~> 2.7'
```

## Installation

MFFileDownloader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MFFileDownloader'
```

## Using


```objectivec

// 公共模块基础配置
MFFileDownloaderLog.setModuleName(@"MFKit");
MFFileDownloaderLog.setMinLogLevel(MFFileDownloaderLogLevelNormal);
[MFFileDownloaderFMDBManager defaultConfigure];

// 创建下载文件模型
MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
fileModel.url = @"https://ruiqu-1304540262.sutanapp.com/386e3c4e5da14269554fa547a9302066.pag";
fileModel.mediaType = 6;
fileModel.name = @"test.pag";

// 创建下载任务
MFFileDownloaderCommonResultModel *downloadResult = [MFFileDownloader addDownloadFile:fileModel resultBlock:^(MFFileDownloaderDownloadResultModel *model) {
    // 判断文件下载状态
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

// 获取文件的下载路径
if ([downloadResult.data isKindOfClass:[MFFileDownloaderFileModel class]]) {
    MFFileDownloaderFileModel *model = downloadResult.data;
    fileModel.localPath = model.localPath;
}

// 判断下载任务的创建结果
if (downloadResult.status < 0) {
    MFFileDownloaderLog.logError([NSString stringWithFormat:@"下载任务添加失败 [%@]: %@", fileModel.fullLocalPath, downloadResult.msg]);
} else {
    MFFileDownloaderLog.logDebug(@"下载开始");
}
```

## Author

NealWills, NealWills93@gmail.com

## License

MFFileDownloader is available under the MIT license. See the LICENSE file for more info.
