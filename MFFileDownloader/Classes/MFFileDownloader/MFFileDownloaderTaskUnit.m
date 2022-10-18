//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderTaskUnit.h"


@implementation MFFileDownloaderTaskUnit {

}

- (void)notice_downloadingNotification:(NSNotification *)notice {
    if (![notice.object isKindOfClass:[MFFileDownloaderTaskUnit class]]) {
        return;
    }
    MFFileDownloaderTaskUnit *unit = notice.object;
    if (![self.originUrl isEqualToString:unit.originUrl]) {
        return;
    }
    [self updateThisUnitWithUnit:unit];
}

- (void)notice_downloadErrorNotification:(NSNotification *)notice {
    if (![notice.object isKindOfClass:[MFFileDownloaderTaskUnit class]]) {
        return;
    }
    MFFileDownloaderTaskUnit *unit = notice.object;
    if (![self.originUrl isEqualToString:unit.originUrl]) {
        return;
    }
    [self updateThisUnitWithUnit:unit];
    [self clearUnUseUnit];
}

- (void)notice_downloadFinishNotification:(NSNotification *)notice {
    if (![notice.object isKindOfClass:[MFFileDownloaderTaskUnit class]]) {
        return;
    }
    MFFileDownloaderTaskUnit *unit = notice.object;
    if (![self.originUrl isEqualToString:unit.originUrl]) {
        return;
    }
    [self updateThisUnitWithUnit:unit];
    [self clearUnUseUnit];
}

- (void)updateThisUnitWithUnit:(MFFileDownloaderTaskUnit *)unit {

    self.downloadStatus = unit.downloadStatus;
    self.downloadFinishFilePath = unit.downloadFinishFilePath;
    self.downloadFinishFilePath = unit.downloadFinishFilePath;
    if (self.downloadStatusChangeBlock) {
        self.downloadStatusChangeBlock(self.downloadStatus, self.progress, self.error);
    }

}

- (void)clearUnUseUnit {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([MFFileDownloaderManager.sharedInstance.unitList containsObject:self]) {
            [MFFileDownloaderManager.sharedInstance.unitList removeObject:self];
        }
    });
}

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice_downloadingNotification:) name:@"MFFileDownloaderManagerDownloadingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice_downloadErrorNotification:) name:@"MFFileDownloaderManagerDownloadErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice_downloadFinishNotification:) name:@"MFFileDownloaderManagerDownloadFinishNotification" object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureNotification];
    }
    return self;
}

@end
