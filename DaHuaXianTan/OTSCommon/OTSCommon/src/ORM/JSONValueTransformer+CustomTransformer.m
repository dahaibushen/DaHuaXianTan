//
//  JSONValueTransformer+CustomTransformer.m
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//category
#import <objc/runtime.h>
#import <OTSCore/OTSCore.h>

@implementation JSONValueTransformer (CustomTransformer)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(NSDateFromNSNumber:)), class_getInstanceMethod(self, @selector(NSDateFromNSNumberDivide1000:)));
}

#pragma mark - number <-> date

- (NSDate *)NSDateFromNSNumberDivide1000:(NSNumber *)number; {
    return [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000];
}

#pragma mark- date->number

- (NSNumber *)JSONObjectFromNSDate:(NSDate *)date {
    return @((date.timeIntervalSince1970 * 1000));
}

#pragma mark - string <-> date

- (NSDate *)NSDateFromNSString:(NSString *)string {
    NSDate *dateValue = nil;
    NSString *formatStr = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = (NSString *) string;
    NSInteger length = [formatStr length];
    if (dateStr.length >= length) {
        if ([dateStr safeRangeOfString:@"UTC"].location != NSNotFound || [dateStr safeRangeOfString:@"GMT"].location != NSNotFound) {
            NSString *subStr = [dateStr safeSubstringWithRange:NSMakeRange(0, length)];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:formatStr];
            dateValue = [dateFormatter dateFromString:subStr];
        } else {
            NSString *subStr = [dateStr safeSubstringWithRange:NSMakeRange(0, length)];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateFormat:formatStr];
            dateValue = [dateFormatter dateFromString:subStr];
        }
    }
    if (dateValue == nil) {
        dateValue = [NSDate date];
    }
    return dateValue;
}


@end
