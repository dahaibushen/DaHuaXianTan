//
//  UIColor+Convenience.h
//  OTSCore
//
//  Created by liuwei7 on 2017/8/28.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  功能:通过RGB创建颜色
 *
 *  @param red <CGFloat> <范围:0~255.0>
 *  @param green <CGFloat> <范围:0~255.0>
 *  @param blue <CGFloat> <范围:0~255.0>
 *
 *  @return UIColor
 *
 *  example: rgb(173.0,23.0,11.0)
 */
FOUNDATION_EXPORT UIColor *rgb(CGFloat red, CGFloat green, CGFloat blue);

/**
 *  功能:通过RGB以及alpha创建颜色
 *
 *  @param red <CGFloat> <范围:0~255.0>
 *  @param green <CGFloat> <范围:0~255.0>
 *  @param blue <CGFloat> <范围:0~255.0>
 *  @param alpha <CGFloat> <范围:0~1.0>
 *
 *  @return UIColor
 *
 *  example: rgbA(173.0,23.0,11.0,0.5)
 */
FOUNDATION_EXPORT UIColor *rgbA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 *  功能:通过16进制整型创建颜色
 *
 *  @param hex  <NSInteger>
 *
 *  @return UIColor
 *
 *  example: hex:(0x123456)
 */
FOUNDATION_EXPORT UIColor *hex(NSInteger hex);//0x123456

/**
 *  功能:通过16进制整型创建颜色
 *
 *  @param hex  <NSInteger>
 *  @param alpha  <CGFloat> 透明度
 *
 *  @return UIColor
 *
 *  example: hex:(0x123456)
 */
FOUNDATION_EXPORT UIColor *hexA(NSInteger hex, CGFloat alpha);//0x123456,1.0

/**
 *  功能:通过16进制字符串类型创建颜色
 *
 *  @param hexString  <NSInteger>
 *
 *  @return UIColor
 *
 *  example: shex:(@"#123456")
 */
FOUNDATION_EXPORT UIColor *shex(NSString *hexString);//@"#123456"/@"#12"

/**
 *  功能:通过RGB创建颜色,RGB三者的值相同
 *
 *  @param grey <CGFloat> <三个相同的RGB值>
 *
 *  @return UIColor
 *
 *  example: rgbGrey:(173.0)
 */

FOUNDATION_EXPORT UIColor *rgbGrey(CGFloat grey);

/**
 *  功能:通过RGB,以及alpha创建颜色,RGB三者的值相同
 *
 *  @param grey  <CGFloat> <三个相同的RGB值>
 *  @param alpha  <CGFloat> <透明度>
 *  @return UIColor
 *
 *  example: rgbGreyA:(173.0,0.5)
 */
FOUNDATION_EXPORT UIColor *rgbGreyA(CGFloat grey, CGFloat alpha);

@interface UIColor (Convenience)

/**
 *  Create a color from a HEX string.
 *  It supports the following type:
 *  - #RGB
 *  - #ARGB
 *  - #RRGGBB
 *  - #AARRGGBB
 *
 *  @param hexString NSString
 *
 *  @return Returns the UIColor instance
 */
+ (UIColor *)hex:(NSString *)hexString;

/**
 *  通过0xffffff的16进制数字创建颜色
 *
 *  @param aRGB 0xffffff
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithRGB:(NSUInteger)aRGB;
+(UIColor*)mycolor;

@end
