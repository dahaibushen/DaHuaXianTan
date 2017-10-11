//
//  NSObject+safe.m
//  OneStoreFramework
//
//  Created by Aimy on 14/11/26.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSObject+safe.h"

#import <objc/runtime.h>

@implementation NSObject (safe)

- (NSNumber *)toNumberIfNeeded {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) self;
    }

    if ([self isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *myNumber = [f numberFromString:(NSString *) self];
        return myNumber;
    }

    return nil;
}

- (nullable id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
