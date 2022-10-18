//
//  MFFileDownloaderManagerConfigure.h
//  MFFileDownloader
//
//  Created by Administer on 2022/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFFileDownloaderManagerConfigure : NSObject

/**
 * 最大并行下载数量
 */
@property (nonatomic, assign) int maxDownloadintCount;


+ (instancetype)defaultConfigure;

@end

NS_ASSUME_NONNULL_END
