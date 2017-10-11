//
//  NSString+AES.m
//  OTSKit
//
//  Created by Jerry on 2017/5/23.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (AES)

- (NSString *)decryptByAESKey:(NSString *)key {
    NSParameterAssert(key);
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *plainData = [self transform:kCCDecrypt
                                   data:data
                                  byKey:key];

    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

- (NSString *)encryptByAESKey:(NSString *)key {
    NSParameterAssert(key);
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainData = [self transform:kCCEncrypt
                                   data:data
                                  byKey:key];

    return [plainData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions) 0];
}

- (NSData *)transform:(CCOperation)encryptOrDecrypt
                 data:(NSData *)inputData
                byKey:(NSString *)key {
    NSData *secretKey = [self getAESKey:key];

    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;

    uint8_t iv[kCCBlockSizeAES128 + 1];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));

    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
            [secretKey bytes], kCCKeySizeAES128, iv, &cryptor);

    if (status != kCCSuccess) {
        return nil;
    }

    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t) [inputData length], true);

    void *buf = malloc(bufsize * sizeof(uint8_t));
    memset(buf, 0x0, bufsize);

    size_t bufused = 0;
    size_t bytesTotal = 0;

    status = CCCryptorUpdate(cryptor, [inputData bytes], (size_t) [inputData length],
            buf, bufsize, &bufused);

    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }

    bytesTotal += bufused;

    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);

    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }

    bytesTotal += bufused;

    CCCryptorRelease(cryptor);

    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

- (NSData *)getAESKey:(NSString *)passport {
    char key[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    NSData *keyData = [passport dataUsingEncoding:NSUTF8StringEncoding];
    char *keyBytes = (char *) [keyData bytes];

    NSInteger len = keyData.length < 16 ? keyData.length : 16;
    for (int i = 0; i < len; i++) {
        key[i] = keyBytes[i];
    }
    return [NSData dataWithBytes:key length:16];
}

@end
