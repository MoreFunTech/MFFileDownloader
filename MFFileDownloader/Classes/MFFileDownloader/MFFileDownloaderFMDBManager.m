//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderFMDBManager.h"
#import "FMDatabase.h"
#import "MFFileDownloaderLog.h"


@interface MFFileDownloaderFMDBManagerSearchResult ()

@end

@implementation  MFFileDownloaderFMDBManagerSearchResult

@end

@interface MFFileDownloaderFMDBManager ()

@property(nonatomic, strong) FMDatabase *database;

@end

@implementation MFFileDownloaderFMDBManager {

}
+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

+ (NSString *)dataBaseDirection {
    NSString *rootDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"MFPodFiles"];
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"FileDownloader"];
    return rootDirectory;
}

+ (BOOL)isDirectionExit:(NSString *)direction {

    NSLog(@"[%@ Debug] %@", NSStringFromClass(self.class), direction);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isExist = [fileManager fileExistsAtPath:direction isDirectory:&isDirectory];
    if (isExist && !isDirectory) {
        NSError *error;
        BOOL isRemoveSuccess = [fileManager removeItemAtPath:direction error:&error];
        if (isRemoveSuccess && !error) {
            MFFileDownloaderLog.logDebug(@"文件删除成功");
        } else {
            MFFileDownloaderLog.logError([NSString stringWithFormat:@"文件删除失败： %@", error]);
        }
    }

    if (!isExist) {
        NSError *error;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFileAppendOnly] = @(0);
        attributes[NSFileCreationDate] = [[NSDate alloc] init];
        BOOL isCreateSuccess = [fileManager createDirectoryAtPath:direction withIntermediateDirectories:YES attributes:attributes error:&error];
        if (isCreateSuccess && !error) {
            MFFileDownloaderLog.logDebug(@"文件夹创建成功");
            return YES;
        } else {
            MFFileDownloaderLog.logError([NSString stringWithFormat:@"文件夹创建失败： %@", error]);
        }
    } else {
        MFFileDownloaderLog.logDebug([NSString stringWithFormat:@"检测到文件夹已存在： %@\n  MFFileDownloadFileManager功能正常", direction]);
        return YES;
    }
    return NO;
}

- (FMDatabase *)database {
    if (!_database) {
        NSString *path = [MFFileDownloaderFMDBManager dataBaseDirection];
        if ([MFFileDownloaderFMDBManager isDirectionExit:path]) {
            _database = [FMDatabase databaseWithPath:path];
        }
    }
    return _database;
}

@end