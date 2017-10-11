//
//  NSDictionary+CaseInsensitive.h
//  OTSCore
//
//  Created by liuwei7 on 2017/8/25.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CaseInsensitive)

//忽略 key 大小写，如果有多个满足条件则会去遍历时第一个满足条件的，尽量慎用。
- (nullable id)objectForCaseInsensitiveKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
