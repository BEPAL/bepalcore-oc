//
//  Hasher.m
//  ectest
//
//  Created by 潘孝钦 on 2018/5/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "SHAHash.h"
#import "hmac.h"
#import "options.h"
#import "ripemd160.h"
#import "sha3.h"
#import "sha2.h"
#import <CommonCrypto/CommonCrypto.h>
#import "Security.h"

@implementation SHAHash

+ (NSData*)hmac512:(NSData *)key Data:(NSData*)data {
    static CONFIDENTIAL uint8_t I[32 + 32];
    static CONFIDENTIAL HMAC_SHA512_CTX ctx;
    hmac_sha512_Init(&ctx, key.bytes, (uint32_t)key.length);
    hmac_sha512_Update(&ctx, data.bytes, (uint32_t)data.length);
    hmac_sha512_Final(&ctx, I);
    return [[NSData alloc] initWithBytes:I length:64];
}

+ (NSData*)hmacSha1:(NSData *)key Data:(NSData *)data {
    const char *cKey  = key.bytes;
    const char *cData = data.bytes;
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return HMAC;
}

+ (NSData*)hmacSha512:(NSData *)key Data:(NSData *)data {
    const char *cKey  = key.bytes;
    const char *cData = data.bytes;
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return HMAC;
}

+ (NSData*)sha1:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG) data.length, d.mutableBytes);
    return d;
}

+ (NSData*)ripemd160:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:20];
    ripemd160(data.bytes, (uint32_t) data.length, d.mutableBytes);
    return d;
}

+ (NSData*)keccak256:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    keccak_256(data.bytes, data.length, d.mutableBytes);
    return d;
}

+ (NSData*)keccak512:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    keccak_512(data.bytes, data.length, d.mutableBytes);
    return d;
}

+ (NSData*)sha3512:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    sha3_512(data.bytes, data.length, d.mutableBytes);
    return d;
}

+ (NSData*)sha3256:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    sha3_256(data.bytes, data.length, d.mutableBytes);
    return d;
}

+ (NSData*)sha2512:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    sha512_Raw(data.bytes, data.length, d.mutableBytes);
    return d;
}

+ (NSData *)sha2256:(NSData*)data {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG) data.length, d.mutableBytes);
    return d;
}

+ (NSData*)md5:(NSData*)data {
    return [Security GetMD5Data:data];
}

@end
