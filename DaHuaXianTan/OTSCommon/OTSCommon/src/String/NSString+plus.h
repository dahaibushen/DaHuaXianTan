//
//  NSString+plus.h
//  OneStoreFramework
//
//  Created by Aimy on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (plus)

/**
 *  NSString转为NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber *)toNumber;

/**
 *  urlencoding
 *
 *  @return NSString
 */
- (NSString *)urlEncoding;

/**
 *  url encoding所有字符
 *
 *  @return NSString
 */
- (NSString *)urlEncodingAllCharacter;

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength;

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength;

//计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp;

//是否是纯int
- (BOOL)isPureInt;

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor
                                    symbolFont:(UIFont *)aSymbolFont
                                   integerFont:(UIFont *)aIntrgerFont
                                   decimalFont:(UIFont *)aDecimalFont;

/**
 *  功能:是否浮点型
 */
- (BOOL)isPureFloat;

@end
