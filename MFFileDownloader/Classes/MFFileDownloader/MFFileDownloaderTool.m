//
// Created by Neal on 2022/8/10.
//

#import "MFFileDownloaderTool.h"


@implementation MFFileDownloaderTool { }

+ (BOOL)isStringNotNull:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (string.length <= 0) {
        return NO;
    }
    return YES;
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    if (![self isStringNotNull:format]) {
        return [[NSDate alloc] init];
    }
    if (![self isStringNotNull:dateString]) {
        return [[NSDate alloc] init];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date {
    if (!date) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:date];
}

+ (NSString *)extractStringWithFormat:(NSString *)format, ... {
    va_list args;
    NSString *specialKey = @"[MF=>|specialKey|<=MF]";
    va_start(args, format);
    NSMutableString *toString = [NSMutableString stringWithCapacity:[format length]];
    NSMutableArray *arguments = [NSMutableArray array];
    [MFFileDownloaderTool extractFormat:format argumentsList:args intoString:toString arguments:arguments specialKey:specialKey];
    va_end(args);
    NSString *resultString = [NSString stringWithFormat:@"%@", toString];
    while ([resultString containsString:specialKey]) {
        NSRange range = [resultString rangeOfString:specialKey];
        if (arguments.count > 0) {
            NSString *value = [NSString stringWithFormat:@"%@", arguments.firstObject];
            [arguments removeObjectAtIndex:0];
            resultString = [resultString stringByReplacingCharactersInRange:range withString:value];
        } else {
            resultString = [resultString stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    return resultString;
}

+ (void)extractFormat:(NSString *)format argumentsList:(va_list)args intoString:(NSMutableString *)cleanedString arguments:(NSMutableArray *)arguments specialKey:(NSString *)specialKey {

    NSUInteger length = [format length];
    unichar last = '\0';
    for (NSUInteger i = 0; i < length; ++i) {
        id arg = nil;
        unichar current = [format characterAtIndex:i];
        unichar add = current;
        if (last == '%') {
            switch (current) {
                case '@':
                    arg = va_arg(args, id);
                    break;
                case 'c':
                    // warning: second argument to 'va_arg' is of promotable type 'char'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                    arg = [NSString stringWithFormat:@"%c", va_arg(args, int)];
                    break;
                case 's':
                    arg = [NSString stringWithUTF8String:va_arg(args, char*)];
                    break;
                case 'd':
                case 'D':
                case 'i':
                    arg = @(va_arg(args, int));
                    break;
                case 'u':
                case 'U':
                    arg = @(va_arg(args, unsigned int));
                    break;
                case 'h':
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        //  warning: second argument to 'va_arg' is of promotable type 'short'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                        arg = @((short) (va_arg(args, int)));
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        // warning: second argument to 'va_arg' is of promotable type 'unsigned short'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                        arg = @((unsigned short) (va_arg(args, uint)));
                    }
                    else {
                        i--;
                    }
                    break;
                case 'q':
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        arg = @(va_arg(args, long long));
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        arg = @(va_arg(args, unsigned long long));
                    }
                    else {
                        i--;
                    }
                    break;
                case 'f':
                    arg = @(va_arg(args, double));
                    break;
                case 'g':
                    // warning: second argument to 'va_arg' is of promotable type 'float'; this va_arg has undefined behavior because arguments will be promoted to 'double'
                    arg = @((float) (va_arg(args, double)));
                    break;
                case 'l':
                    i++;
                    if (i < length) {
                        unichar next = [format characterAtIndex:i];
                        if (next == 'l') {
                            i++;
                            if (i < length && [format characterAtIndex:i] == 'd') {
                                //%lld
                                arg = @(va_arg(args, long long));
                            }
                            else if (i < length && [format characterAtIndex:i] == 'u') {
                                //%llu
                                arg = @(va_arg(args, unsigned long long));
                            }
                            else {
                                i--;
                            }
                        }
                        else if (next == 'd') {
                            //%ld
                            arg = @(va_arg(args, long));
                        }
                        else if (next == 'u') {
                            //%lu
                            arg = @(va_arg(args, unsigned long));
                        }
                        else {
                            i--;
                        }
                    }
                    else {
                        i--;
                    }
                    break;
                default:
                    // something else that we can't interpret. just pass it on through like normal
                    break;
            }
        }
        else if (current == '%') {
            // percent sign; skip this character
            add = '\0';
        }

        if (arg != nil) {
            [cleanedString appendString:specialKey];
            [arguments addObject:arg];
        }
        else if (add == (unichar)'@' && last == (unichar) '%') {
            [cleanedString appendFormat:@"NULL"];
        }
        else if (add != '\0') {
            [cleanedString appendFormat:@"%C", add];
        }
        last = current;
    }
}


@end