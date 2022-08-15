//
//  MFFileDownloader.h
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import <Foundation/Foundation.h>
#import "MFFileDownloaderHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFFileDownloader : NSObject

/**
 * 添加下载任务
 * @param fileModel 下载文件模型
 * @return 添加任务结果
 */
+ (MFFileDownloaderCommonResultModel *)addDownloadFile:(MFFileDownloaderFileModel *)fileModel;

/**
 * 添加重下任务
 * @param fileModel 下载文件模型
 * @return 添加任务结果
 */
+ (MFFileDownloaderCommonResultModel *)reDownloadFile:(MFFileDownloaderFileModel *)fileModel;

/**
 * 添加下载任务
 * @param fileModel 下载模型
 * @param resultBlock 下载状态回调
 * @return 添加任务结果
 */
+ (MFFileDownloaderCommonResultModel *)addDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                           resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock;

/**
 * 添加重下任务
 * @param fileModel 文件模型
 * @param resultBlock 重下状态回调
 * @return 添加任务结果
 */
+ (MFFileDownloaderCommonResultModel *)reDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock;


@end

NS_ASSUME_NONNULL_END
