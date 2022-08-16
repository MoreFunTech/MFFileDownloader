//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>

#import "MFFileDownloaderDownloadResultModel.h"

@class MFFileDownloaderCommonResultModel;


@interface MFFileDownloaderFileModel : NSObject

/**
 * 文件id
 */
@property (nonatomic, copy) NSString *id;

/**
 * 文件名
 */
@property (nonatomic, copy) NSString *name;

/**
 * 文件地址
 */
@property (nonatomic, copy) NSString *url;

/**
 * 拓展字段 （暂时无用）
 */
@property (nonatomic, copy) NSString *furUrl;

/**
 * 文件类型
 * 1 jpg、png 图片文件
 * 2 MP4 视屏文件
 * 3 gif 动图文件
 * 4 avi 语音文件
 * 5 svga 文件
 * 6 pag 文件
 */
@property (nonatomic, assign) int mediaType;

/**
 * 动画持续时间
 */
@property (nonatomic, assign) CGFloat during;

/**
 * 图片、视屏、动图尺寸 - 宽度
 */
@property (nonatomic, assign) CGFloat imageWidth;

/**
 * 图片、视屏、动图尺寸 - 高度
 */
@property (nonatomic, assign) CGFloat imageHeight;

/**
 * 文件启用状态 1 启用 2 不启用
 */
@property (nonatomic, assign) int status;

/**
 * 文件版本 防止更换了文件未更换地址的情况
 */
@property (nonatomic, assign) int version;

/**
 * 下载状态 0 未下载  1 下载中  2 已下载
 */
@property (nonatomic, assign) MFFileDownloaderDownloadStatus downloadStatus;

/**
 * 记录创建时间
 */
@property (nonatomic, strong) NSDate *createDate;

/**
 * 记录更新时间
 */
@property (nonatomic, strong) NSDate *updateDate;

/**
 * 本地文件保存地址
 */
@property (nonatomic, copy) NSString *localPath;

/**
 * 本地文件保存地址
 */
@property (nonatomic, copy) NSString *fullLocalPath;



+ (instancetype)modelWithId:(NSString *)id name:(NSString *)name url:(NSString *)url furUrl:(NSString *)furUrl mediaType:(int)mediaType during:(CGFloat)during imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight status:(int)status version:(int)version createDate:(NSDate *)createDate updateDate:(NSDate *)updateDate localPath:(NSString *)localPath;

- (MFFileDownloaderCommonResultModel *)isModelValid;

- (MFFileDownloaderCommonResultModel *)isModelCanInsert;
- (MFFileDownloaderCommonResultModel *)isModelCanUpdate;

- (NSString *)description;


@end