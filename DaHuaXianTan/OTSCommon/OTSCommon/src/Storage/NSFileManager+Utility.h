//
//  NSFileManager+Utility.h
//  OTSCore
//
//  Created by derick on 2016/11/29.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Utility)

@property(nonatomic, class, readonly) NSString *appDocPath;
@property(nonatomic, class, readonly) NSString *appCachePath;
@property(nonatomic, class, readonly) NSString *appLibPath;

+ (BOOL)copyFileFrom:(NSString *)from to:(NSString *)to;

+ (BOOL)copyDirectoryFrom:(NSString *)from to:(NSString *)to;

+ (BOOL)moveFileFrom:(NSString *)from to:(NSString *)to;

+ (BOOL)moveDirectoryFrom:(NSString *)from to:(NSString *)to;

+ (BOOL)createDirectory:(NSString *)path;


+ (long long)fileSize:(NSString *)path;

+ (long long)directorySize:(NSString *)path;

+ (BOOL)removeDirectory:(NSString *)dir;

+ (nullable NSDate *)fileModifyTimestamp:(NSString *)path;

+ (nullable NSDate *)directoryModifyTimestamp:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
