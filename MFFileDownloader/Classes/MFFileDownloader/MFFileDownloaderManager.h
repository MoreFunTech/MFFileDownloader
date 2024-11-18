//
//  MFFileDownloaderManager.h
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import <Foundation/Foundation.h>

#import "MFFileDownloaderManagerConfigure.h"

@class MFFileDownloaderTaskUnit;


NS_ASSUME_NONNULL_BEGIN

@protocol MFFileDownloaderManagerProtocol <NSObject>

- (void)firstDownloadFailWithUrl:(NSURL *)url redownloadReadyBlock:(void(^)(NSString *decodeUrl))redownloadReadyBlock;
- (void)reDownloadFailWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl;
- (void)downloadSuccessWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl data:(NSData *)data;

@end


@interface MFFileDownloaderManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray *unitList;
@property (nonatomic, strong) MFFileDownloaderManagerConfigure *configure;
@property (nonatomic, weak) id<MFFileDownloaderManagerProtocol> pluginDelegate;

- (MFFileDownloaderTaskUnit *)addNewDownTaskWithUrl:(NSString *)url localPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
