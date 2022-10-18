//
//  MFFileDownloaderManager.m
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import "MFFileDownloaderManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MFFileDownloaderTaskUnit.h"
#import "MFFileDownloaderTool.h"

@implementation MFFileDownloaderPluginFirstDownloadFailureUnit



@end


@interface MFFileDownloaderManager ()


@end

@implementation MFFileDownloaderManager


- (MFFileDownloaderTaskUnit *)addNewDownTaskWithUrl:(NSString *)url localPath:(NSString *)localPath {
    
    MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
    unit.originUrl = url;
    unit.localPath = localPath;
    
    __block NSURLSessionDownloadTask *task;
    
    [AFHTTPSessionManager.manager.downloadTasks enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.currentRequest.URL.absoluteString isEqualToString:url]) {
            task = obj;
        }
    }];
    
    if (task) {
        unit.taskIdentifier = task.taskIdentifier;
        if (task.state == NSURLSessionTaskStateRunning) {
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
        } else if (task.state == NSURLSessionTaskStateCanceling) {
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadNot;
        } else if (task.state == NSURLSessionTaskStateSuspended) {
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadPause;
        } else if (task.state == NSURLSessionTaskStateCompleted) {
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
        }
    }
    
    if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloading) {
        if (unit.downloadStatusChangeBlock) {
            if (@available(iOS 11.0, *)) {
                unit.downloadStatusChangeBlock(unit.downloadStatus, task.progress, task.error);
            } else {
                NSProgress *progress = [[NSProgress alloc] init];
                progress.totalUnitCount = task.countOfBytesExpectedToReceive;
                progress.completedUnitCount = task.countOfBytesReceived;
                unit.downloadStatusChangeBlock(unit.downloadStatus, progress, task.error);
            }
        }
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    } else if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloadWaiting) {
        if (unit.downloadStatusChangeBlock) {
            if (@available(iOS 11.0, *)) {
                unit.downloadStatusChangeBlock(unit.downloadStatus, task.progress, task.error);
            } else {
                NSProgress *progress = [[NSProgress alloc] init];
                progress.totalUnitCount = task.countOfBytesExpectedToReceive;
                progress.completedUnitCount = task.countOfBytesReceived;
                unit.downloadStatusChangeBlock(unit.downloadStatus, progress, task.error);
            }
        }
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    } else if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloadPause) {
        [task resume];
        unit.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
        if (unit.downloadStatusChangeBlock) {
            if (@available(iOS 11.0, *)) {
                unit.downloadStatusChangeBlock(unit.downloadStatus, task.progress, task.error);
            } else {
                NSProgress *progress = [[NSProgress alloc] init];
                progress.totalUnitCount = task.countOfBytesExpectedToReceive;
                progress.completedUnitCount = task.countOfBytesReceived;
                unit.downloadStatusChangeBlock(unit.downloadStatus, progress, task.error);
            }
        }
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    } else if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloadFinish) {
        [self createNewOriginTaskWithUrl:unit.originUrl localPath:unit.localPath];
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    } else if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
        [self createNewOriginTaskWithUrl:unit.originUrl localPath:unit.localPath];
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    } else if (unit.downloadStatus == MFFileDownloaderDownloadStatusDownloadNot) {
        [self createNewOriginTaskWithUrl:unit.originUrl localPath:unit.localPath];
        [MFFileDownloaderManager.sharedInstance.unitList addObject:unit];
    }

    return unit;
}

- (void)createNewOriginTaskWithUrl:(NSString *)url localPath:(NSString *)localPath {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDownloadTask *task = [AFHTTPSessionManager.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
        unit.originUrl = url;
        unit.progress = downloadProgress;
        unit.localPath = localPath;
        unit.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
        [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadingNotification" object:unit];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
       return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if ([MFFileDownloaderManager.sharedInstance.pluginDelegate respondsToSelector:@selector(firstDownloadFailWithUrl:)]) {
                [weakSelf firstDownloadFailedProcessWithUrl:url localPath:localPath];
            } else {
                MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
                unit.originUrl = url;
                unit.localPath = localPath;
                unit.error = error;
                unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadError;
                [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadErrorNotification" object:unit];
            }
        } else {
            MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
            unit.originUrl = url;
            unit.localPath = localPath;
            unit.error = error;
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
            unit.downloadFinishFilePath = filePath.absoluteString;
            [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadFinishNotification" object:unit];
        }
    }];
    [task resume];
}

- (void)firstDownloadFailedProcessWithUrl:(NSString *)originUrl localPath:(NSString *)localPath {
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:originUrl];
    MFFileDownloaderPluginFirstDownloadFailureUnit *decodeUnit = [MFFileDownloaderManager.sharedInstance.pluginDelegate firstDownloadFailWithUrl:url];
    decodeUnit.redownloadReadyBlock = ^(NSString * _Nonnull decodeUrl) {
        [weakSelf redownloadTaskWithOriginUrl:originUrl decodeUrl:decodeUrl localPath:localPath];
    };
}

- (void)redownloadTaskWithOriginUrl:(NSString *)originUrl decodeUrl:(NSString *)decodeUrl localPath:(NSString *)localPath {
    
    if (![MFFileDownloaderTool isStringNotNull:decodeUrl]) {
        MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
        unit.originUrl = originUrl;
        unit.localPath = localPath;
        unit.error = [NSError errorWithDomain:@"MFFileDownloaderManagerError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"下载地址解析失败"}];
        unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadError;
        [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadErrorNotification" object:unit];
        return;
    }
    
    if ([originUrl isEqualToString:decodeUrl]) {
        MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
        unit.originUrl = originUrl;
        unit.localPath = localPath;
        unit.error = [NSError errorWithDomain:@"MFFileDownloaderManagerError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"下载地址解析失败"}];
        unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadError;
        [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadErrorNotification" object:unit];
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:decodeUrl]];
    
    NSURLSessionDownloadTask *task = [AFHTTPSessionManager.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
        unit.originUrl = originUrl;
        unit.decodeUrl = decodeUrl;
        unit.progress = downloadProgress;
        unit.localPath = localPath;
        unit.downloadStatus = MFFileDownloaderDownloadStatusDownloading;
        [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadingNotification" object:unit];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
       return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
            unit.originUrl = originUrl;
            unit.decodeUrl = decodeUrl;
            unit.localPath = localPath;
            unit.error = error;
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadError;
            [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadErrorNotification" object:unit];
        } else {
            MFFileDownloaderTaskUnit *unit = [[MFFileDownloaderTaskUnit alloc] init];
            unit.originUrl = originUrl;
            unit.decodeUrl = decodeUrl;
            unit.localPath = localPath;
            unit.error = error;
            unit.downloadStatus = MFFileDownloaderDownloadStatusDownloadFinish;
            unit.downloadFinishFilePath = filePath.absoluteString;
            [NSNotificationCenter.defaultCenter postNotificationName:@"MFFileDownloaderManagerDownloadFinishNotification" object:unit];
        }
    }];
    [task resume];
}

- (NSMutableArray *)unitList {
    if (!_unitList) {
        _unitList = [NSMutableArray array];
    }
    return _unitList;
}

- (MFFileDownloaderManagerConfigure *)configure {
    if (!_configure) {
        _configure = [MFFileDownloaderManagerConfigure defaultConfigure];
    }
    return _configure;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

@end
