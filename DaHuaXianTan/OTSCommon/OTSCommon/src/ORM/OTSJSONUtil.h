//
//  OTSJSONUtil.h
//  OneStoreFramework
//
//  Created by huang jiming on 14-8-7.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSJSONUtil : NSObject

/**
 *  功能:将dictionary转成字符串
 */
+ (NSString *)stringFromDict:(NSDictionary *)aDict;

/**
 *  json对象转字符串
 *
 *
 */
+ (NSString *)stringFromJSONObject:(id)aObj options:(NSJSONWritingOptions)option;

/**
 *  功能:将字符串转成dictionary
 */
+ (NSDictionary *)dictFromString:(NSString *)aString;

/**
 *  功能:将字符串转成array
 */
+ (NSArray *)arrayFromString:(NSString *)aString;

@end
