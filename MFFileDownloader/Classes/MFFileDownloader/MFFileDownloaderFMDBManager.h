//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MFFileDownloaderFMDBManagerSearchResultStyle) {
    MFFileDownloaderFMDBManagerSearchResultStyleNone = 0,
    MFFileDownloaderFMDBManagerSearchResultStyleDownloading = 1,
    MFFileDownloaderFMDBManagerSearchResultStyleDownFailed = 2,
    MFFileDownloaderFMDBManagerSearchResultStyleDownExist = 3,
};

@interface MFFileDownloaderFMDBManagerSearchResult: NSObject

@end

@interface MFFileDownloaderFMDBManager : NSObject

+ (instancetype)sharedInstance;

@end