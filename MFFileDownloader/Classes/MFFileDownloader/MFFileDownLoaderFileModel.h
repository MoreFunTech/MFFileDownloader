//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>

@class MFFileDownloaderCommonResultModel;


@interface MFFileDownLoaderFileModel : NSObject

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
 * 文件完整地址（主要针对视频）
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
 * 记录创建时间
 */
@property (nonatomic, copy) NSDate *createDate;

/**
 * 记录更新时间
 */
@property (nonatomic, copy) NSDate *updateDate;

/**
 * 本地文件保存地址
 */
@property (nonatomic, copy) NSString *localPath;

- (MFFileDownloaderCommonResultModel *)sqlInsertSyntaxWithTableName:(NSString *)tableName;
- (MFFileDownloaderCommonResultModel *)sqlUpdateSyntaxWithTableName:(NSString *)tableName;

@end