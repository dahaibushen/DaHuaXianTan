//
//  OTSValueObject.m
//  OneStoreFramework
//
//  Created by Aimy on 9/15/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <OTSCore/OTSValueObject.h>

@implementation OTSValueObject

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"nid": @"id"}];
}

/**
 *  重写父类方法，默认可选
 *
 *  @param propertyName 属性名称
 *
 *  @return bool
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (instancetype)voWithDict:(NSDictionary *)aDict {
    if (![aDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    return [[self alloc] initWithDictionary:aDict error:nil];
}

@end
