//
//  NSString+MD5.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-7-23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)md5String {
    if (self == nil || self.length == 0) {
        return nil;
    }

    const char *value = [self UTF8String];

    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG) strlen(value), outputBuffer);

    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }

    return outputString;
}

@end
