//
//  UIColor+Convenience.m
//  OTSCore
//
//  Created by liuwei7 on 2017/8/28.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "UIColor+Convenience.h"

@implementation UIColor (Convenience)

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithRGB:(NSUInteger)aRGB {
    return [UIColor colorWithRed:((float) ((aRGB & 0xFF0000) >> 16)) / 255.0 green:((float) ((aRGB & 0xFF00)
            >> 8)) / 255.0  blue:((float) (aRGB & 0xFF)) / 255.0 alpha:1.0];
}

+ (UIColor *)hex:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

UIColor *rgb(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

UIColor *rgbA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

UIColor *hex(NSInteger hex) {
    return [UIColor colorWithRed:((float) ((hex & 0xFF0000) >> 16)) / 255.0 green:((float) ((hex & 0xFF00)
            >> 8)) / 255.0  blue:((float) (hex & 0xFF)) / 255.0 alpha:1.0];
}


UIColor *hexA(NSInteger hex, CGFloat alpha) {
    return [UIColor colorWithRed:((float) ((hex & 0xFF0000) >> 16)) / 255.0 green:((float) ((hex & 0xFF00)
            >> 8)) / 255.0  blue:((float) (hex & 0xFF)) / 255.0 alpha:(alpha >= 0) ? ((alpha > 1) ? 1 : alpha) : 0];
}


UIColor *shex(NSString *hexString) {
    NSString *colorString = hexString;
    if ([colorString rangeOfString:@"#"].length) {
        colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    }
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 2: // #grey
            alpha = 1.0f;
            red = [UIColor colorComponentFrom:colorString start:0 length:2];
            green = [UIColor colorComponentFrom:colorString start:0 length:2];
            blue = [UIColor colorComponentFrom:colorString start:0 length:2];
            break;
        case 3: // #RGB
            alpha = 1.0f;
            red = [UIColor colorComponentFrom:colorString start:0 length:1];
            green = [UIColor colorComponentFrom:colorString start:1 length:1];
            blue = [UIColor colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [UIColor colorComponentFrom:colorString start:0 length:1];
            red = [UIColor colorComponentFrom:colorString start:1 length:1];
            green = [UIColor colorComponentFrom:colorString start:2 length:1];
            blue = [UIColor colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [UIColor colorComponentFrom:colorString start:0 length:2];
            green = [UIColor colorComponentFrom:colorString start:2 length:2];
            blue = [UIColor colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [UIColor colorComponentFrom:colorString start:0 length:2];
            red = [UIColor colorComponentFrom:colorString start:2 length:2];
            green = [UIColor colorComponentFrom:colorString start:4 length:2];
            blue = [UIColor colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
            break;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIColor *rgbGrey(CGFloat grey) {
    return [UIColor colorWithRed:grey / 255.0 green:grey / 255.0 blue:grey / 255.0 alpha:1];
}

UIColor *rgbGreyA(CGFloat grey, CGFloat alpha) {
    return [UIColor colorWithRed:grey / 255.0 green:grey / 255.0 blue:grey / 255.0 alpha:alpha];
}

