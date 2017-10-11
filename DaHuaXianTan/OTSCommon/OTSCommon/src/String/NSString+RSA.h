//
//  NSString+RSA.h
//  OTSKit
//
//  Created by Jerry on 2017/5/23.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RSA)

//Private Key: PKCS#8
//openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in privkey.pem -out privkey.pkcs8.pem

//Public Key:X509
// openssl rsa -pubout -in privkey.pem -out pubkey.x509.pem

- (nullable NSString *)encryptByRSAPrivateKey:(NSString *)privateKey;

- (nullable NSString *)encryptByRSAPublicKey:(NSString *)publicKey;

- (nullable NSString *)decryptByRSAPrivateKey:(NSString *)privateKey;

- (nullable NSString *)decryptByRSAPublicKey:(NSString *)publicKey;

@end

NS_ASSUME_NONNULL_END
