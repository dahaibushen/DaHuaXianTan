//
//  NSDictionary+CaseInsensitive.m
//  OTSCore
//
//  Created by liuwei7 on 2017/8/25.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "NSDictionary+CaseInsensitive.h"

@implementation NSDictionary (CaseInsensitive)

- (id)objectForCaseInsensitiveKey:(NSString *)aKey {
    if (!aKey) {
        return nil;
    }

    __block id returnObj = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *tempKey = key;
        if ([tempKey compare:aKey options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            returnObj = obj;
            *stop = YES;
        }
    }];

    return returnObj;
}

@end
