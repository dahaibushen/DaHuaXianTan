//
//  NSString+MandarinLatin.h
//  OTSKit
//
//  Created by Jerry on 2017/7/19.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MandarinLatin)

@property(nonatomic, strong, readonly, nullable) NSString *mandarinLatinString;
@property(nonatomic, strong, readonly, nullable) NSString *initialCharacterString;

@property(nonatomic, assign, readonly) BOOL containsChineseCharacter;

@end

NS_ASSUME_NONNULL_END
