//
// Created by Neal on 2022/8/10.
//

#import <Foundation/Foundation.h>


@interface MFFileDownLoaderTool : NSObject

/**
 * 判断字符串是否不为空
 * @param string 被判断的字符串
 * @return 是否不为空
 */
+ (BOOL)isStringNotNull:(NSString *)string;

/**
 Returns a date parsed from given string interpreted using the format.

 @param dateString The string to parse.
 @param format     The string's date format.

 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;


/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.

 @param date     A date representation of string interpreted using the format.
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"

 @return NSString representing the formatted date string.
 */
+ (NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date;

/**
 * 字符串拼接方法
 * @param format 拼接字符串
 * @return 拼接完成的字符串
 */
+ (NSString *)extractStringWithFormat:(NSString *)format, ... ;

@end