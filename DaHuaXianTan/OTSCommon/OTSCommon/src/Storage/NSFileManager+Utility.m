//
//  NSFileManager+Utility.m
//  OTSCore
//
//  Created by derick on 2016/11/29.
//  Copyright © 2016年 OneStoreBase. All rights reserved.
//

#import "NSFileManager+Utility.h"
#import <sys/stat.h>
#import "OTSCoreMacros.h"

@implementation NSFileManager (Utility)

BOOL _createDirectoryForFilePath(NSString *path, BOOL isOverwrite) {
    NSString *lastComponent = [path lastPathComponent];
    NSString *toFolder = path;
    if (lastComponent.length > 0) {
        toFolder = [path substringWithRange:NSMakeRange(0, [path length] - [lastComponent length])];
    }

    return _createDirectory(toFolder, isOverwrite);
}

BOOL _createDirectory(NSString *dirPath, BOOL isOverwrite) {
    if (dirPath.length == 0) {
        return NO;
    }

    NSFileManager *fileMng = [NSFileManager defaultManager];

    BOOL ret = YES;
    NSError *error = nil;
    BOOL isDir = YES;
    if ([fileMng fileExistsAtPath:dirPath isDirectory:&isDir]) {
        if (!isDir) {
            remove([dirPath UTF8String]);
        }
        if (isOverwrite) {
            ret = [fileMng removeItemAtPath:dirPath error:&error];
            ret &= (error == nil);
            OTSLog(@"%s, %@", __FUNCTION__, error);
        }
    }

    if (ret) {
        ret = [fileMng createDirectoryAtPath:dirPath
                 withIntermediateDirectories:YES
                                  attributes:nil
                                       error:&error];
        ret &= (error == NULL);
        OTSLog(@"%s, %@", __FUNCTION__, error);
    }

    return ret;
}

BOOL _copyFile(NSString *from, NSString *to, BOOL isRemove) {
    if (access([from UTF8String], 0) != 0 || to.length == 0) {
        return NO;
    }

    BOOL ret = _createDirectoryForFilePath(to, NO);
    if (ret) {
        NSError *error = NULL;
        remove([to UTF8String]);

        if (isRemove) {
            remove([to UTF8String]);
            ret = [[NSFileManager defaultManager] moveItemAtPath:from toPath:to error:&error];
        } else {
            ret = [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:&error];
        }
        ret &= (error == NULL);
        OTSLog(@"%s, %@", __FUNCTION__, error);
    }

    return ret;
}

BOOL _copyDirectory(NSString *from, NSString *to, BOOL isRemove) {
    if (access([from UTF8String], 0) != 0 || to.length == 0) {
        return NO;
    }

    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSString *fromDirName = [from lastPathComponent];
    to = [to stringByAppendingPathComponent:fromDirName];

    BOOL ret = [NSFileManager createDirectory:to];
    if (ret) {
        NSError *error = nil;
        NSArray *allFiles = [fileMng contentsOfDirectoryAtPath:from error:&error];
        if (error) {
            ret = NO;
        } else {
            for (NSString *fileName in allFiles) {
                NSString *fromPath = [from stringByAppendingPathComponent:fileName];
                NSString *toPath = [to stringByAppendingPathComponent:fileName];
                BOOL tmpRet;

                if (isRemove) {
                    remove([toPath UTF8String]);
                    tmpRet = [fileMng moveItemAtPath:fromPath toPath:toPath error:&error];
                } else {
                    tmpRet = [fileMng copyItemAtPath:fromPath toPath:toPath error:&error];
                }

                if (error && !tmpRet) {
                    ret = NO;
                    break;
                }
            }
        }
    }

    return ret;
}

+ (BOOL)createDirectory:(NSString *)path {
    return _createDirectory(path, NO);
}

+ (BOOL)copyFileFrom:(NSString *)from to:(NSString *)to {
    return _copyFile(from, to, NO);
}

+ (BOOL)moveFileFrom:(NSString *)from to:(NSString *)to {
    return _copyFile(from, to, YES);
}

+ (BOOL)copyDirectoryFrom:(NSString *)from to:(NSString *)to {
    return _copyDirectory(from, to, NO);
}

+ (BOOL)moveDirectoryFrom:(NSString *)from to:(NSString *)to {
    return _copyDirectory(from, to, YES);
}

+ (long long)fileSize:(NSString *)path {
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSError *error = NULL;
    NSDictionary *attribute = [fileMng attributesOfItemAtPath:path error:&error];
    long long fileLen = 0;
    if (error) {
        OTSLog(@"%s, %@", __FUNCTION__, error);
    } else {
        fileLen = [[attribute objectForKey:NSFileSize] longLongValue];
    }

    return fileLen;
}

+ (NSDate *)fileModifyTimestamp:(NSString *)path {
    struct stat st;
    if (lstat([path cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
        return [NSDate dateWithTimeIntervalSince1970:st.st_mtimespec.tv_sec];
    }
    return nil;
}

long long internal_fileSize(NSString *filePath) {
    struct stat st;
    if (lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
        return st.st_size;
    }
    return 0;
}

+ (long long)directorySize:(NSString *)dirPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:dirPath]) {
        return 0;
    }

    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:dirPath] objectEnumerator];
    NSString *fileName = NULL;

    long long dirFileSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [dirPath stringByAppendingPathComponent:fileName];
        dirFileSize += internal_fileSize(fileAbsolutePath);
    }

    return dirFileSize;
}

+ (NSDate *)directoryModifyTimestamp:(NSString *)path {
    return [NSFileManager fileModifyTimestamp:path];
}

+ (BOOL)removeDirectory:(NSString *)dir {
    if (dir.length == 0) {
        return NO;
    }

    NSFileManager *fileMng = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [fileMng fileExistsAtPath:dir isDirectory:&isDirectory];
    if (isExist && isDirectory) {
        NSError *error = NULL;
        BOOL ret = [fileMng removeItemAtPath:dir error:&error];
        ret &= (error == NULL);
        return ret;
    }

    return YES;
}

+ (NSString *)appDocPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)appLibPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)appCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


@end
