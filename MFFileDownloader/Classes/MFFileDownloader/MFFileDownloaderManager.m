//
//  MFFileDownloaderManager.m
//  MFFileDownloader
//
//  Created by Administer on 2022/8/10.
//

#import "MFFileDownloaderManager.h"

@implementation MFFileDownloaderManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

@end
