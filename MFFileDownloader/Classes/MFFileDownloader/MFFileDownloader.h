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
 */
+ (void)addDownloadFile:(MFFileDownloaderFileModel *)fileModel;

/**
 * 添加重下任务
 * @param fileModel 下载文件模型
 */
+ (void)reDownloadFile:(MFFileDownloaderFileModel *)fileModel;

/**
 * 添加下载任务
 * @param fileModel 下载模型
 * @param resultBlock 下载状态回调
 */
+ (void)addDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                           resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock;

/**
 * 添加重下任务
 * @param fileModel 文件模型
 * @param resultBlock 重下状态回调
 */
+ (void)reDownloadFile:(MFFileDownloaderFileModel *)fileModel
                                          resultBlock:(void (^)(MFFileDownloaderDownloadResultModel *))resultBlock;

/**
 * 查询数据
 * @param resultBlock 结果回调
 */
+ (void)getAllDataWithResultBlock:(void (^)(MFFileDownloaderCommonResultModel *))resultBlock;;

/**
 * 查询数据
 * @param resultBlock 结果回调
 */
+ (void)getAllDownloadedDataWithResultBlock:(void (^)(MFFileDownloaderCommonResultModel *))resultBlock;;

/**
 * 查询数据
 * @param resultBlock 结果回调
 */
+ (void)getAllDownloadingDataWithResultBlock:(void (^)(MFFileDownloaderCommonResultModel *))resultBlock;;

/**
 * 清空所有下载的文件
 */
+ (void)clearAllDownloadFiles;


@end

NS_ASSUME_NONNULL_END
