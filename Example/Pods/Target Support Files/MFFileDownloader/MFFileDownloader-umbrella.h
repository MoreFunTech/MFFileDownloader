#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MFFileDownloader.h"
#import "MFFileDownloaderCommonResultModel.h"
#import "MFFileDownloaderDownloadResultModel.h"
#import "MFFileDownloaderEnum.h"
#import "MFFileDownloaderFileModel.h"
#import "MFFileDownloaderFMDBManager.h"
#import "MFFileDownloaderHeader.h"
#import "MFFileDownloaderLog.h"
#import "MFFileDownloaderManager.h"
#import "MFFileDownloaderManagerConfigure.h"
#import "MFFileDownloaderTaskUnit.h"
#import "MFFileDownloaderTool.h"

FOUNDATION_EXPORT double MFFileDownloaderVersionNumber;
FOUNDATION_EXPORT const unsigned char MFFileDownloaderVersionString[];

