//
//  NSDate+Format.m
//  MessageCenter
//
//  Created by xiaxiongzhi on 14-9-16.
//
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

static NSDateFormatter *__FORMATER_yyyyMMdd = nil;
static NSDateFormatter *__FORMATER_yyyyMMdd1 = nil;
static NSDateFormatter *__FORMATER_yyyyMMddHHmm = nil;
static NSDateFormatter *__FORMATER_yyyyMMddHHmmss = nil;
static NSDateFormatter *__FORMATER_yyyyMMddHHmmSSS = nil;

NS_INLINE NSString *__otsDateToString(NSDate *date, NSDateFormatter *formatter) {
    if (![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    return [formatter stringFromDate:date];
}

- (NSString *)dateToString_yyyyMMdd {
    if (!__FORMATER_yyyyMMdd) {
        __FORMATER_yyyyMMdd = [[NSDateFormatter alloc] init];
        __FORMATER_yyyyMMdd.timeZone = [NSTimeZone localTimeZone];
        [__FORMATER_yyyyMMdd setDateFormat:@"yyyy/MM/dd"];
    }
    return __otsDateToString(self, __FORMATER_yyyyMMdd);
}

- (NSString *)dateToString_yyyyMMdd1 {
    if (!__FORMATER_yyyyMMdd1) {
        __FORMATER_yyyyMMdd1 = [[NSDateFormatter alloc] init];
        __FORMATER_yyyyMMdd1.timeZone = [NSTimeZone localTimeZone];
        [__FORMATER_yyyyMMdd1 setDateFormat:@"yyyy-MM-dd"];
    }
    return __otsDateToString(self, __FORMATER_yyyyMMdd1);
}

- (NSString *)dateToString_yyyyMMddHHmm {
    if (!__FORMATER_yyyyMMddHHmm) {
        __FORMATER_yyyyMMddHHmm = [[NSDateFormatter alloc] init];
        __FORMATER_yyyyMMddHHmm.timeZone = [NSTimeZone localTimeZone];
        [__FORMATER_yyyyMMddHHmm setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return __otsDateToString(self, __FORMATER_yyyyMMddHHmm);
}

- (NSString *)dateToString_yyyyMMddHHmmss {
    if (!__FORMATER_yyyyMMddHHmmss) {
        __FORMATER_yyyyMMddHHmmss = [[NSDateFormatter alloc] init];
        __FORMATER_yyyyMMddHHmmss.timeZone = [NSTimeZone localTimeZone];
        [__FORMATER_yyyyMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return __otsDateToString(self, __FORMATER_yyyyMMddHHmmss);
}

- (NSString *)dateToString_yyyyMMddHHmmSSS {
    if (!__FORMATER_yyyyMMddHHmmSSS) {
        __FORMATER_yyyyMMddHHmmSSS = [[NSDateFormatter alloc] init];
        __FORMATER_yyyyMMddHHmmSSS.timeZone = [NSTimeZone localTimeZone];
        [__FORMATER_yyyyMMddHHmmSSS setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    }
    return __otsDateToString(self, __FORMATER_yyyyMMddHHmmSSS);
}

@end
