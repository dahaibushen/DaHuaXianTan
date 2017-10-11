//
//  NSString+plus.m
//  OneStoreFramework
//
//  Created by Aimy on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "NSString+plus.h"

@implementation NSString (plus)

- (NSNumber *)toNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:self];
    return number;
}

- (NSString *)urlEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)urlEncodingAllCharacter {
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return outputStr;
}

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange tailRange = NSMakeRange(aLength, self.length - aLength);

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];

    return attributedString;
}

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, self.length - aLength);
    NSRange tailRange = NSMakeRange(self.length - aLength, aLength);

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];

    return attributedString;
}

//计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp {
    int strlength = 0;
    char *p = (char *) [strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

//是否是纯int
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor symbolFont:(UIFont *)aSymbolFont integerFont:(UIFont *)aIntrgerFont decimalFont:(UIFont *)aDecimalFont {
    if (self.length <= 0) {
        return nil;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    [string addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:aSymbolFont range:NSMakeRange(0, 1)];
    NSRange range = [self rangeOfString:@"."];
    if (range.location != NSNotFound) {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, range.location)];
        [string addAttribute:NSFontAttributeName value:aDecimalFont range:NSMakeRange(range.location, string.length - range.location)];
    } else {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, string.length - 1)];
    }

    return string;
}

/**
 *  功能:是否浮点型
 */
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
