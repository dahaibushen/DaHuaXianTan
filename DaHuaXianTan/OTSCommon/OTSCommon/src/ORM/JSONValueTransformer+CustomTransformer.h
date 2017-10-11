//
//  JSONValueTransformer+CustomTransformer.h
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString *)string;

- (NSNumber *)JSONObjectFromNSDate:(NSDate *)date;

@end
