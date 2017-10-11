//
//  NSString+AES.h
//  OTSKit
//
//  Created by Jerry on 2017/5/23.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)

/**
 *  AES解密。
 *  解密流程：Base64 decode --> AES decrypt --> to string (NSUTF8StringEncoding)
 *
 */
- (NSString *)decryptByAESKey:(NSString *)key;


/**
 *  AES加密。
 *  加密流程：AES encrypt --> Base64 encode
 *
 */
- (NSString *)encryptByAESKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
