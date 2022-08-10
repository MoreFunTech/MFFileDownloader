//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>


@interface MFFileDownloaderCommonResultModel : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic) id data;

- (instancetype)initWithStatus:(int)status msg:(NSString *)msg data:(id)data;

+ (instancetype)modelWithStatus:(int)status msg:(NSString *)msg data:(id)data;


@end