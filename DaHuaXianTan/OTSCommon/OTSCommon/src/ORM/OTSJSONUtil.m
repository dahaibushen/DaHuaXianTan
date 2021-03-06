//
//  OTSJSONUtil.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-8-7.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSJSONUtil.h"
#import "OTSCoreMacros.h"

@implementation OTSJSONUtil

+ (NSString *)stringFromDict:(NSDictionary *)aDict {
    return [self stringFromDict:aDict options:0];
}

+ (NSString *)stringFromDict:(NSDictionary *)aDict options:(NSJSONWritingOptions)option {
    return [self stringFromJSONObject:aDict options:option];
}

+ (NSString *)stringFromJSONObject:(id)aObj options:(NSJSONWritingOptions)option {
    NSString *json = nil;
    if ([NSJSONSerialization isValidJSONObject:aObj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aObj options:option error:&error];
        if (!error) {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            OTSLog(@"error convert to json,%@,%@", error, aObj);
        }
    }

    return json;
}

+ (NSDictionary *)dictFromString:(NSString *)aString {
    if (aString == nil) {
        return nil;
    }

    NSData *theData = [aString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;

    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];

    if (error) {
        OTSLog(@"error convert json string to dict,%@,%@", aString, error);
        NSArray *array = [aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *s = [array componentsJoinedByString:@""];
        theData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSError *err = nil;
        resultDict = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&err];
        if (err || !resultDict) {
            return nil;
        } else {
            return resultDict;
        }
    } else {
        return resultDict;
    }
}

+ (NSArray *)arrayFromString:(NSString *)aString {
    if (aString == nil) {
        return nil;
    }

    NSData *theData = [aString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;

    NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];

    if (error) {
        OTSLog(@"error convert json string to array,%@,%@", aString, error);
        return nil;
    } else {
        return resultArray;
    }
}

@end
