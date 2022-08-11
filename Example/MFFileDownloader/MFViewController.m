//
//  MFViewController.m
//  MFFileDownloader
//
//  Created by NealWills on 08/10/2022.
//  Copyright (c) 2022 NealWills. All rights reserved.
//

#import <MFFileDownloader/MFFileDownloaderLog.h>
#import "MFViewController.h"
#import "MFFileDownloaderFileModel.h"
#import "MFFileDownloaderCommonResultModel.h"

#import "MFFileDownloader.h"

@interface MFViewController ()

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    MFFileDownloaderLog.setModuleName(@"MFKit");
    MFFileDownloaderLog.setMinLogLevel(MFFileDownloaderLogLevelNormal);

    MFFileDownloaderLog.logFormat(MFFileDownloaderLogLevelDebug, @"321%@%i", @"123", 444);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
