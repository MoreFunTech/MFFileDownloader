//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MFFileDownloaderLogLevel) {
    MFFileDownloaderLogLevelNone = 0,
    MFFileDownloaderLogLevelNormal = 1,
    MFFileDownloaderLogLevelTips = 2,
    MFFileDownloaderLogLevelDebug = 3,
    MFFileDownloaderLogLevelWarning = 4,
    MFFileDownloaderLogLevelError = 5,
};

@interface MFFileDownloaderLog : NSObject

+ (void(^)(MFFileDownloaderLogLevel level, NSString *format))log;
+ (void(^)(MFFileDownloaderLogLevel level, NSString *format, ...))logFormat;
+ (void(^)(NSString *format))logNormal;
+ (void(^)(NSString *format))logTips;
+ (void(^)(NSString *format))logDebug;
+ (void(^)(NSString *format))logWarning;
+ (void(^)(NSString *format))logError;

+ (void(^)(MFFileDownloaderLogLevel level))setMinLogLevel;
+ (void(^)(NSString *moduleName))setModuleName;

@end