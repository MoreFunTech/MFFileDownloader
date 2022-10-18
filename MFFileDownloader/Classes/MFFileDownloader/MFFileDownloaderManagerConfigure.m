//
//  MFFileDownloaderManagerConfigure.m
//  MFFileDownloader
//
//  Created by Administer on 2022/10/18.
//

#import "MFFileDownloaderManagerConfigure.h"

@implementation MFFileDownloaderManagerConfigure



+ (instancetype)defaultConfigure {
    MFFileDownloaderManagerConfigure *configure = [[MFFileDownloaderManagerConfigure alloc] init];
    
    configure.maxDownloadintCount = 10;
    
    return configure;
}

@end
