//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderFMDBManager.h"
#import "FMDatabase.h"
#import "MFFileDownloaderHeader.h"

@interface MFFileDownloaderFMDBManager ()

@property(nonatomic, strong) FMDatabase *database;
@property (nonatomic, assign) BOOL hasFinishConfig;

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

+ (void)defaultConfigure {
    if (MFFileDownloaderFMDBManager.sharedInstance.hasFinishConfig) {
        return;
    }
    MFFileDownloaderFMDBManager.sharedInstance.hasFinishConfig = YES;
    NSString *createSqlStr = self.sqlStrCreateTableFile;
    if (self.database.open) {
        BOOL isCreateSuccess = [self.database executeUpdate:createSqlStr];
        if (isCreateSuccess) {
            MFFileDownloaderLog.logDebug(@"表打开成功");
        } else {
            MFFileDownloaderLog.logDebug(@"表打开失败");
        }
    }
}

+ (NSString *)dataBaseDirection {
    NSString *rootDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"MFPodFiles"];
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"FileDownloader"];
    return rootDirectory;
}

+ (BOOL)isDirectionExit:(NSString *)direction {

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


+ (NSString *)tableName {
    return @"app_files_t";
}

+ (NSString *)dataBaseName {
    return @"MFMediaFiles.sqlite";
}

+ (NSString *)sqlStrCreateTableFile {
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    NSMutableString *createSqlStr = [NSMutableString string];
    [createSqlStr appendString:@"CREATE TABLE IF NOT EXISTS [tableName] ("];
    [createSqlStr appendString:@" id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,"];
    [createSqlStr appendString:@" name TEXT NOT NULL  ,"];
    [createSqlStr appendString:@" url TEXT NOT NULL  ,"];
    [createSqlStr appendString:@" fur_url TEXT NOT NULL  ,"];
    [createSqlStr appendString:@" local_path TEXT NOT NULL  ,"];
    [createSqlStr appendString:@" download_status INTEGER NOT NULL  ,"];
    [createSqlStr appendString:@" media_type INTEGER NOT NULL  ,"];
    [createSqlStr appendString:@" during FLOAT NOT NULL  ,"];
    [createSqlStr appendString:@" image_width FLOAT NOT NULL  ,"];
    [createSqlStr appendString:@" image_height FLOAT NOT NULL  ,"];
    [createSqlStr appendString:@" status INTEGER NOT NULL  ,"];
    [createSqlStr appendString:@" version INTEGER NOT NULL  ,"];
    [createSqlStr appendString:@" create_date TEXT NOT NULL  ,"];
    [createSqlStr appendString:@" update_date TEXT NOT NULL"];
    [createSqlStr appendString:@" );"];
    return [createSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];
}

+ (MFFileDownloaderCommonResultModel *)insertDataWithModel:(MFFileDownloaderFileModel *)fileModel {
    MFFileDownloaderCommonResultModel *result = fileModel.isModelCanInsert;
    if (result.status < 0) {
        return result;
    }
    result = [self searchDataWithUrl:fileModel.url];
    if (result.status >= 0) {
        if ([result.data isKindOfClass:[NSArray class]]) {
            NSArray *list = result.data;
            if (list.count > 0) {
                int resStatus = -1;
                NSString *resData = @"Failure";
                NSString *resMsg = [NSString stringWithFormat:@"数据插入失败: %@", @"数据已存在"];
                return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
            }
        }
    }
    NSString *name = fileModel.name;
    NSString *url = fileModel.url;
    NSString *fur_url = [MFFileDownloaderTool isStringNotNull:fileModel.furUrl] ? fileModel.furUrl : @"";
    NSString *local_path = fileModel.localPath;
    if (![MFFileDownloaderTool isStringNotNull:local_path]) {
        NSString *basePath = [MFFileDownloaderFMDBManager dataBaseDirection];
        if ([MFFileDownloaderFMDBManager isDirectionExit:basePath]) {
            local_path = [NSString stringWithFormat:@"%@/%@", basePath, fileModel.name];
        }
    }
    NSNumber *download_status = @(fileModel.downloadStatus);
    NSNumber *media_type = @(fileModel.mediaType);
    NSNumber *during = @(fileModel.during);
    NSNumber *image_width = fileModel.imageWidth <= 0 ? @(1) : @(fileModel.imageWidth);
    NSNumber *image_height = fileModel.imageHeight <= 0 ? @(1) : @(fileModel.imageHeight);
    NSNumber *status = @(1);
    NSNumber *version = @(1);
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    NSString *create_date = [MFFileDownloaderTool dateToStringWithFormat:@"YYYY-MM-dd HH:mm:ss.S" date:[[NSDate alloc] init]];
    NSString *update_date = [MFFileDownloaderTool dateToStringWithFormat:@"YYYY-MM-dd HH:mm:ss.S" date:[[NSDate alloc] init]];
    NSMutableString *tempSqlStr = [NSMutableString string];
    [tempSqlStr appendString:@"INSERT INTO [tableName] ("];
    [tempSqlStr appendString:@" name , url , fur_url , local_path , download_status ,"];
    [tempSqlStr appendString:@" media_type , during , image_width , image_height , status ,"];
    [tempSqlStr appendString:@" version , create_date , update_date "];
    [tempSqlStr appendString:@")"];
    [tempSqlStr appendString:@" VALUES ("];
    [tempSqlStr appendString:@" ? , ? , ? , ? , ? ,"];
    [tempSqlStr appendString:@" ? , ? , ? , ? , ? ,"];
    [tempSqlStr appendString:@" ? , ? , ? "];
    [tempSqlStr appendString:@");"];
    NSString *insertSqlStr = [tempSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];

    NSError *insertError;
    BOOL isInsertSuccess = [self.database executeUpdate:insertSqlStr
                                                 values:@[
                                                         name, url, fur_url, local_path, download_status,
                                                         media_type, during, image_width, image_height, status,
                                                         version, create_date, update_date
                                                 ] error:&insertError];
    if (!isInsertSuccess) {
        int resStatus = -1;
        NSString *resData = @"Failure";
        NSString *resMsg = [NSString stringWithFormat:@"数据插入失败: %@", insertError.localizedDescription];
        return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
    }
    int resStatus = 0;
    NSString *resData = @"Success";
    NSString *resMsg = @"";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (MFFileDownloaderCommonResultModel *)updateDataWithModel:(MFFileDownloaderFileModel *)fileModel {
    MFFileDownloaderCommonResultModel *result = fileModel.isModelCanUpdate;
    if (result.status < 0) {
        return result;
    }
    NSNumber *id = @(fileModel.id.intValue);
    NSString *name = fileModel.name;
    NSString *url = fileModel.url;
    NSString *fur_url = [MFFileDownloaderTool isStringNotNull:fileModel.furUrl] ? fileModel.furUrl : @"";
    NSString *local_path = fileModel.localPath;
    if (![MFFileDownloaderTool isStringNotNull:local_path]) {
        NSString *basePath = [MFFileDownloaderFMDBManager dataBaseDirection];
        if ([MFFileDownloaderFMDBManager isDirectionExit:basePath]) {
            local_path = [NSString stringWithFormat:@"%@/%@", basePath, fileModel.name];
        }
    }
    NSNumber *download_status = @(fileModel.downloadStatus);
    NSNumber *media_type = @(fileModel.mediaType);
    NSNumber *during = @(fileModel.during);
    NSNumber *image_width = fileModel.imageWidth <= 0 ? @(1) : @(fileModel.imageWidth);
    NSNumber *image_height = fileModel.imageHeight <= 0 ? @(1) : @(fileModel.imageHeight);
    NSNumber *status = @(fileModel.status);
    NSNumber *version = @(fileModel.version);
    NSString *create_date = [MFFileDownloaderTool dateToStringWithFormat:@"YYYY-MM-dd HH:mm:ss.S" date:fileModel.createDate];
    NSString *update_date = [MFFileDownloaderTool dateToStringWithFormat:@"YYYY-MM-dd HH:mm:ss.S" date:[[NSDate alloc] init]];
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    NSMutableString *tempSqlStr = [NSMutableString string];
    [tempSqlStr appendString:@"UPDATE [tableName] SET"];
    [tempSqlStr appendFormat:@" name = '%@' ,", name];
    [tempSqlStr appendFormat:@" url = '%@' ,", url];
    [tempSqlStr appendFormat:@" fur_url = '%@' ,", fur_url];
    [tempSqlStr appendFormat:@" local_path = '%@' ,", local_path];
    [tempSqlStr appendFormat:@" download_status = '%@' ,", download_status];
    [tempSqlStr appendFormat:@" media_type = '%@' ,", media_type];
    [tempSqlStr appendFormat:@" during = '%@' ,", during];
    [tempSqlStr appendFormat:@" image_width = '%@' ,", image_width];
    [tempSqlStr appendFormat:@" image_height = '%@' ,", image_height];
    [tempSqlStr appendFormat:@" status = '%@' ,", status];
    [tempSqlStr appendFormat:@" version = '%@' ,", version];
    [tempSqlStr appendFormat:@" create_date = '%@' ,", create_date];
    [tempSqlStr appendFormat:@" update_date = '%@'", update_date];
    [tempSqlStr appendFormat:@" WHERE id = '%@' ;", id];
    NSString *updateSqlStr = [tempSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];

    NSError *updateError;

    BOOL isUpdateSuccess = [self.database executeUpdate:updateSqlStr
                                                 values:@[] error:&updateError];
    if (!isUpdateSuccess) {
        int resStatus = -1;
        NSString *resData = @"Failure";
        NSString *resMsg = [NSString stringWithFormat:@"数据更新失败: %@", updateError.localizedDescription];
        return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
    }
    int resStatus = 0;
    NSString *resData = @"Success";
    NSString *resMsg = @"";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (MFFileDownloaderCommonResultModel *)deleteDataWithModel:(MFFileDownloaderFileModel *)fileModel {
    int resStatus = -1;
    NSString *resData = @"Failure";
    NSString *resMsg = @"当前版本无删除功能";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (MFFileDownloaderCommonResultModel *)searchDataWithUrl:(NSString *)url {
    NSMutableArray *list = [NSMutableArray array];
    NSMutableString *tempSqlStr = [NSMutableString string];
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    [tempSqlStr appendString:@"SELECT * FROM [tableName] WHERE"];
    [tempSqlStr appendFormat:@" url = '%@' ", url];
    NSString *selectSqlStr = [tempSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];
    FMResultSet *set = [self.database executeQuery:selectSqlStr];
    if (set) {
        while (set.next) {
            MFFileDownloaderFileModel *model = [[MFFileDownloaderFileModel alloc] init];
            model.id = [NSString stringWithFormat:@"%d", [set intForColumn:@"id"]];
            model.name = [NSString stringWithFormat:@"%@", [set stringForColumn:@"name"]];
            model.url = [NSString stringWithFormat:@"%@", [set stringForColumn:@"url"]];
            model.furUrl = [NSString stringWithFormat:@"%@", [set stringForColumn:@"fur_url"]];
            model.localPath = [NSString stringWithFormat:@"%@", [set stringForColumn:@"local_path"]];
            model.downloadStatus = [set intForColumn:@"download_status"];
            model.mediaType = [set intForColumn:@"media_type"];
            model.during = [set doubleForColumn:@"during"];
            model.imageWidth = [set doubleForColumn:@"image_width"];
            model.imageHeight = [set doubleForColumn:@"image_height"];
            model.status = [set intForColumn:@"status"];
            model.version = [set intForColumn:@"version"];
            model.createDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"create_date"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            model.updateDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"updateDate"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            [list addObject:model];
        }
    }
    int resStatus = 0;
    NSArray *resData = list;
    NSString *resMsg = @"";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (MFFileDownloaderCommonResultModel *)searchDataWithId:(NSString *)id {
    NSMutableArray *list = [NSMutableArray array];
    NSMutableString *tempSqlStr = [NSMutableString string];
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    [tempSqlStr appendString:@"SELECT * FROM [tableName] WHERE"];
    [tempSqlStr appendFormat:@" id = '%@' ", id];
    NSString *selectSqlStr = [tempSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];
    FMResultSet *set = [self.database executeQuery:selectSqlStr];
    if (set) {
        while (set.next) {
            MFFileDownloaderFileModel *model = [[MFFileDownloaderFileModel alloc] init];
            model.id = [NSString stringWithFormat:@"%d", [set intForColumn:@"id"]];
            model.name = [NSString stringWithFormat:@"%@", [set stringForColumn:@"name"]];
            model.url = [NSString stringWithFormat:@"%@", [set stringForColumn:@"url"]];
            model.furUrl = [NSString stringWithFormat:@"%@", [set stringForColumn:@"fur_url"]];
            model.localPath = [NSString stringWithFormat:@"%@", [set stringForColumn:@"local_path"]];
            model.downloadStatus = [set intForColumn:@"download_status"];
            model.mediaType = [set intForColumn:@"media_type"];
            model.during = [set doubleForColumn:@"during"];
            model.imageWidth = [set doubleForColumn:@"image_width"];
            model.imageHeight = [set doubleForColumn:@"image_height"];
            model.status = [set intForColumn:@"status"];
            model.version = [set intForColumn:@"version"];
            model.createDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"create_date"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            model.updateDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"updateDate"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            [list addObject:model];
        }
    }
    int resStatus = 0;
    NSArray *resData = list;
    NSString *resMsg = @"";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (MFFileDownloaderCommonResultModel *)getAllData {
    NSMutableArray *list = [NSMutableArray array];
    NSMutableString *tempSqlStr = [NSMutableString string];
    NSString *tableName = MFFileDownloaderFMDBManager.tableName;
    [tempSqlStr appendString:@"SELECT * FROM [tableName]"];
    NSString *selectSqlStr = [tempSqlStr stringByReplacingOccurrencesOfString:@"[tableName]" withString:tableName];
    FMResultSet *set = [self.database executeQuery:selectSqlStr];
    if (set) {
        while (set.next) {
            MFFileDownloaderFileModel *model = [[MFFileDownloaderFileModel alloc] init];
            model.id = [NSString stringWithFormat:@"%d", [set intForColumn:@"id"]];
            model.name = [NSString stringWithFormat:@"%@", [set stringForColumn:@"name"]];
            model.url = [NSString stringWithFormat:@"%@", [set stringForColumn:@"url"]];
            model.furUrl = [NSString stringWithFormat:@"%@", [set stringForColumn:@"fur_url"]];
            model.localPath = [NSString stringWithFormat:@"%@", [set stringForColumn:@"local_path"]];
            model.downloadStatus = [set intForColumn:@"download_status"];
            model.mediaType = [set intForColumn:@"media_type"];
            model.during = [set doubleForColumn:@"during"];
            model.imageWidth = [set doubleForColumn:@"image_width"];
            model.imageHeight = [set doubleForColumn:@"image_height"];
            model.status = [set intForColumn:@"status"];
            model.version = [set intForColumn:@"version"];
            model.createDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"create_date"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            model.updateDate = [MFFileDownloaderTool dateWithString:[set stringForColumn:@"updateDate"] format:@"YYYY-MM-DD HH:mm:ss.S"] ;
            [list addObject:model];
        }
    }
    int resStatus = 0;
    NSArray *resData = list;
    NSString *resMsg = @"";
    return [MFFileDownloaderCommonResultModel modelWithStatus:resStatus msg:resMsg data:resData];
}

+ (FMDatabase *)database {
    return MFFileDownloaderFMDBManager.sharedInstance.database;
}

- (FMDatabase *)database {
    if (!_database) {
        NSString *path = [MFFileDownloaderFMDBManager dataBaseDirection];
        if ([MFFileDownloaderFMDBManager isDirectionExit:path]) {
            NSString *dataBasePath = [NSString stringWithFormat:@"%@/%@", path, MFFileDownloaderFMDBManager.dataBaseName];
            MFFileDownloaderLog.logDebug(dataBasePath);
            _database = [FMDatabase databaseWithPath:dataBasePath];
        }
    }
    return _database;
}

@end