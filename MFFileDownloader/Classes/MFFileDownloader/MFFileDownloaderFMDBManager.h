//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>

@class MFFileDownloaderCommonResultModel;
@class MFFileDownloaderFileModel;

@interface MFFileDownloaderFMDBManager : NSObject

/**
 * 单例
 * @return 返回单例模型
 */
+ (instancetype)sharedInstance;

/**
 * 触发默认配置
 */
+ (void)defaultConfigure;

/**
 * 文件管理根目录
 * @return 返回管理器根目录
 */
+ (NSString *)dataBaseDirection;

/**
 * 文件管理根目录
 * @return 基础根目录
 */
+ (NSString *)documentBaseDirection;

/**
 * 判断地址是否可用
 * @param direction 被判断的地址
 * @return 返回可用不可用
 */
+ (BOOL)isDirectionExit:(NSString *)direction;

/**
 * 创建表的SQL语句
 * @return sqlStr
 */
+ (NSString *)sqlStrCreateTableFile;

/**
 * 插入数据
 * @param fileModel 数据模型
 */
+ (MFFileDownloaderCommonResultModel *)insertDataWithModel:(MFFileDownloaderFileModel *)fileModel;

/**
 * 更新数据
 * @param fileModel 数据模型
 */
+ (MFFileDownloaderCommonResultModel *)updateDataWithModel:(MFFileDownloaderFileModel *)fileModel;

/**
 * 删除数据
 * @param fileModel 数据模型
 */
+ (MFFileDownloaderCommonResultModel *)deleteDataWithModel:(MFFileDownloaderFileModel *)fileModel;

/**
 * 查询数据
 * @param url 根据url进行查询
 */
+ (MFFileDownloaderCommonResultModel *)searchDataWithUrl:(NSString *)url;

/**
 * 查询数据
 * @param id 根据url进行查询
 */
+ (MFFileDownloaderCommonResultModel *)searchDataWithId:(NSString *)id;

/**
 * 查询数据
 */
+ (MFFileDownloaderCommonResultModel *)getAllData;



@end
