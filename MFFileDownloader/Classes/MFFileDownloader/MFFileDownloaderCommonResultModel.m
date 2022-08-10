//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderCommonResultModel.h"


@implementation MFFileDownloaderCommonResultModel {

}

- (instancetype)initWithStatus:(int)status msg:(NSString *)msg data:(id)data {
    self = [super init];
    if (self) {
        self.status = status;
        self.msg = msg;
        self.data = data;
    }

    return self;
}

+ (instancetype)modelWithStatus:(int)status msg:(NSString *)msg data:(id)data {
    return [[self alloc] initWithStatus:status msg:msg data:data];
}

@end