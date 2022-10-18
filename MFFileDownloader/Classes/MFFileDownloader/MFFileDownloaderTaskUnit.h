//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>
#import "MFFileDownloaderHeader.h"


@interface MFFileDownloaderTaskUnit : NSObject

@property (nonatomic, copy) NSString * _Nonnull originUrl;
@property (nonatomic, copy) NSString * _Nullable decodeUrl;

@property (nonatomic, copy) NSString * _Nonnull localPath;
/**
 * 不出意外的话， 与上面的localPath一致
 */
@property (nonatomic, copy) NSString * _Nullable downloadFinishFilePath;
@property (nonatomic) NSUInteger taskIdentifier;
@property (nonatomic, assign) MFFileDownloaderDownloadStatus downloadStatus;
@property (nonatomic, strong) NSProgress * _Nullable progress;
@property (nonatomic, strong) NSError * _Nullable error;

@property (nonatomic, copy) void(^ _Nullable downloadStatusChangeBlock)(MFFileDownloaderDownloadStatus status, NSProgress * _Nullable progress, NSError * _Nullable error);

@end
