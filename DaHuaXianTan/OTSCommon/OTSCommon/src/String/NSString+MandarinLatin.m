//
//  NSString+MandarinLatin.m
//  OTSKit
//
//  Created by Jerry on 2017/7/19.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "NSString+MandarinLatin.h"

@implementation NSString (MandarinLatin)

- (NSString *)mandarinLatinString {
    NSMutableString *pinYinStr = [NSMutableString stringWithString:self];
    BOOL ret = CFStringTransform((__bridge CFMutableStringRef) pinYinStr, NULL, kCFStringTransformMandarinLatin, NO);
    if (ret) {
        CFStringTransform((__bridge CFMutableStringRef) pinYinStr, NULL, kCFStringTransformStripDiacritics, NO);
    }
    NSString *resultString = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)initialCharacterString {
    if (!self.length) {
        return nil;
    }
    NSString *initialString = [self substringToIndex:1];
    if ([initialString canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return initialString;
    } else {
        NSString *mandarinLatin = self.mandarinLatinString;
        if ([mandarinLatin isEqualToString:self]) {
            return initialString;
        } else {
            return mandarinLatin.initialCharacterString;
        }
    }
}

- (BOOL)containsChineseCharacter {
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
