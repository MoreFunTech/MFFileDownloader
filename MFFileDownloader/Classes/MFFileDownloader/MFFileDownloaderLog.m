//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderLog.h"

#import "MFFileDownLoaderTool.h"


@interface MFFileDownloaderLog ()
@property(nonatomic) MFFileDownloaderLogLevel minLogLevel;
@property(nonatomic, copy) NSString *moduleName;
@end

@implementation MFFileDownloaderLog {
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)logWithLevel:(MFFileDownloaderLogLevel)level msg:(NSString *)msg {
    if (MFFileDownloaderLog.sharedInstance.minLogLevel == MFFileDownloaderLogLevelNone) {
        return;
    }
    if (level < MFFileDownloaderLog.sharedInstance.minLogLevel) {
        return;
    }
    NSLog(@"%@", [MFFileDownloaderLog formatLogWith:level msg:msg]);
}

+ (NSString *)formatLogWith:(MFFileDownloaderLogLevel)level msg:(NSString *)msg {
    NSString *top = [NSString stringWithFormat:@"\n┏━━━━━━━━━━━━━━━━━━━━━━━"];
    NSString *moduleName = @"MFFileDownloader";
    if ([MFFileDownloaderLog.sharedInstance.moduleName isKindOfClass:[NSString class]]) {
        if (MFFileDownloaderLog.sharedInstance.moduleName.length > 0) {
            moduleName = MFFileDownloaderLog.sharedInstance.moduleName;
        }
    }
    NSString *mark = [NSString stringWithFormat:@"\n  Level: %@  |  Module:%@", [self levelMarkWith:level], moduleName];
    NSString *content = [NSString stringWithFormat:@"\n  %@", msg];
    NSString *bottom = [NSString stringWithFormat:@"\n┗━━━━━━━━━━━━━━━━━━━━━━━"];
    return [NSString stringWithFormat:@"%@%@%@%@", top, mark, content, bottom];
}

+ (NSString *)levelMarkWith:(MFFileDownloaderLogLevel)level {
    switch (level) {
        case MFFileDownloaderLogLevelNone:
            return @"None";
        case MFFileDownloaderLogLevelNormal:
            return @"Normal";
        case MFFileDownloaderLogLevelTips:
            return @"Tips";
        case MFFileDownloaderLogLevelDebug:
            return @"Debug";
        case MFFileDownloaderLogLevelWarning:
            return @"Warning";
        case MFFileDownloaderLogLevelError:
            return @"Error";
        default:
            return @"Debug";
    }
}

+ (void (^)(MFFileDownloaderLogLevel level, NSString *format))log {
    return ^(MFFileDownloaderLogLevel level, NSString *format) {
        [MFFileDownloaderLog logWithLevel:level msg:format];
    };
}

+ (void (^)(MFFileDownloaderLogLevel level, NSString *format, ...))logFormat {
    return ^(MFFileDownloaderLogLevel level, NSString *format, ...) {
//        va_list args;
//        va_start(args, format);
//        va_end(args);
//        NSString *msg = [MFFileDownLoaderTool extractStringWithFormat:format, args];
//        [MFFileDownloaderLog logWithLevel:level msg:msg];
    };
}

+ (void (^)(NSString *format))logNormal {
    return ^(NSString *format) {
        [MFFileDownloaderLog logWithLevel:MFFileDownloaderLogLevelNormal msg:format];
    };
}

+ (void (^)(NSString *format))logTips {
    return ^(NSString *format) {
        [MFFileDownloaderLog logWithLevel:MFFileDownloaderLogLevelTips msg:format];
    };
}

+ (void (^)(NSString *format))logDebug {
    return ^(NSString *format) {
        [MFFileDownloaderLog logWithLevel:MFFileDownloaderLogLevelDebug msg:format];
    };
}

+ (void (^)(NSString *format))logWarning {
    return ^(NSString *format) {
        [MFFileDownloaderLog logWithLevel:MFFileDownloaderLogLevelWarning msg:format];
    };
}

+ (void (^)(NSString *format))logError {
    return ^(NSString *format) {
        [MFFileDownloaderLog logWithLevel:MFFileDownloaderLogLevelError msg:format];
    };
}

+ (void (^)(MFFileDownloaderLogLevel level))setMinLogLevel {
    return ^(MFFileDownloaderLogLevel level) {
        MFFileDownloaderLog.sharedInstance.minLogLevel = level;
    };
}

+ (void (^)(NSString *moduleName))setModuleName {
    return ^(NSString *moduleName) {
        MFFileDownloaderLog.sharedInstance.moduleName = moduleName;
    };
}

@end