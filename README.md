# MFFileDownloader

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
```

## Author

NealWills, NealWills93@gmail.com

## License

MFFileDownloader is available under the MIT license. See the LICENSE file for more info.
