//
// Created by Neal on 2022/8/15.
//



typedef NS_ENUM(NSInteger, MFFileDownloaderDownloadStatus) {
    MFFileDownloaderDownloadStatusDownloadNot = 0,
    MFFileDownloaderDownloadStatusDownloading = 1,
    MFFileDownloaderDownloadStatusDownloadFinish = 2,
    MFFileDownloaderDownloadStatusDownloadError = 3,
    MFFileDownloaderDownloadStatusDownloadPause = 4,
    MFFileDownloaderDownloadStatusDownloadWaiting = 5,
};
