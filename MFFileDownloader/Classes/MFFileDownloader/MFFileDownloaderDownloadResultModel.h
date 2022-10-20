//
// Created by Neal on 2022/8/15.
//

#import <Foundation/Foundation.h>

#import "MFFileDownloaderHeader.h"

@class MFFileDownloaderFileModel;

@interface MFFileDownloaderDownloadResultModel : NSObject

@property (nonatomic, strong) MFFileDownloaderFileModel *fileModel;
@property (nonatomic, assign) MFFileDownloaderDownloadStatus downloadStatus;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, strong) NSError *error;

+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus progress:(NSProgress *)progress error:(NSError *)error;

+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus;

+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus progress:(NSProgress *)progress;

+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus error:(NSError *)error;

@end
