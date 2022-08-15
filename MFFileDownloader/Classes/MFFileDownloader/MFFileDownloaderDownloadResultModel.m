//
// Created by Neal on 2022/8/15.
//

#import "MFFileDownloaderDownloadResultModel.h"
#import "MFFileDownloaderFileModel.h"


@implementation MFFileDownloaderDownloadResultModel {

}

- (instancetype)initWithFileModel:(MFFileDownloaderFileModel *)fileModel
                   downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus
                         progress:(NSProgress *)progress error:(NSError *)error {
    self = [super init];
    if (self) {
        self.fileModel = fileModel;
        self.downloadStatus = downloadStatus;
        self.progress = progress;
        self.error = error;
    }

    return self;
}

+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel
                    downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus
                             error:(NSError *)error {
    return [self modelWithFileModel:fileModel
                     downloadStatus:downloadStatus
                           progress:nil
                              error:error];
}


+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel
                    downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus
                          progress:(NSProgress *)progress {
    return [self modelWithFileModel:fileModel
                     downloadStatus:downloadStatus
                           progress:progress
                              error:nil];
}


+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel
                    downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus {
    return [self modelWithFileModel:fileModel
                     downloadStatus:downloadStatus
                           progress:nil
                              error:nil];
}


+ (instancetype)modelWithFileModel:(MFFileDownloaderFileModel *)fileModel
                    downloadStatus:(MFFileDownloaderDownloadStatus)downloadStatus
                          progress:(NSProgress *)progress error:(NSError *)error {
    return [[self alloc] initWithFileModel:fileModel
                            downloadStatus:downloadStatus
                                  progress:progress
                                     error:error];
}

@end