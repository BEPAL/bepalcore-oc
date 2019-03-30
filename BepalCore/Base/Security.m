/*
 * Copyright (c) 2016-2019, BEPAL
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the University of California, Berkeley nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "Security.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation Security

/**
 * Rsa加密 使用public_key.der文件
 */
+(NSString*)RsaEncrypt:(NSString*)content PublicKey:(NSString*)publickey {
    NSData *certificateData = [[NSData alloc] initWithBase64EncodedString:publickey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *encryptedData = [Security RsaEncryptByData:[content dataUsingEncoding:NSUTF8StringEncoding] PublicKey:certificateData];
    NSString *base64Encoded = [encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64Encoded;
}

+(NSData*)RsaEncryptByData:(NSData*)content PublicKey:(NSData*)publickey {
    
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publickey);
    SecPolicyRef SecPolicyRefmyPolicy = SecPolicyCreateBasicX509();
    
    SecTrustRef trust = nil;
    
    OSStatus returnCode = SecTrustCreateWithCertificates(myCertificate, SecPolicyRefmyPolicy, &trust);
    if (returnCode != 0) {
        return nil;
    }
    SecTrustRef myTrust = trust;
    SecTrustResultType trustResult;
    OSStatus returnCodeEvaluate = SecTrustEvaluate(myTrust, &trustResult);
    if (returnCodeEvaluate != 0) {
        return nil;
    }
    SecKeyRef publicKeyInfo = SecTrustCopyPublicKey(myTrust);
    uint8_t *plainBuffer = (uint8_t *)content.bytes;
    size_t cipherBufferSize=SecKeyGetBlockSize(publicKeyInfo);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    OSStatus status = SecKeyEncrypt(publicKeyInfo,
                                    kSecPaddingOAEP,
                                    plainBuffer,
                                    strlen((char*)plainBuffer),
                                    cipherBuffer,
                                    &cipherBufferSize);
    if (status != 0) {
        return nil;
    }
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    return encryptedData;
}
/**
 * Rsa解密 使用private_key.p12文件
 */
+(NSString*)RsaDecrypt:(NSString*)content PrivateKey:(NSString*)privatekey Password:(NSString*)pwd {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    SecKeyRef privateKeyInfo = [Security RsaGetPrivateKey:privatekey Password:pwd];
    const void *cipherBuffer = data.bytes;
    size_t plaintextBufferSize = SecKeyGetBlockSize(privateKeyInfo);
    void *plaintextBuffer = malloc(plaintextBufferSize);
    OSStatus returnCode = SecKeyDecrypt(privateKeyInfo,
                                        kSecPaddingOAEP,
                                        cipherBuffer,
                                        data.length,
                                        plaintextBuffer,
                                        &plaintextBufferSize);
    if (returnCode != errSecSuccess) {
        return nil;
    }
    NSData *result = [NSData dataWithBytes:plaintextBuffer length:plaintextBufferSize];
    return [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
}
/**
 * 获取Rsa私钥
 */
+(SecKeyRef)RsaGetPrivateKey:(NSString *)privatekey Password:(NSString *)pwd {
    NSData *pkcs12key = [[NSData alloc] initWithBase64EncodedString:privatekey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: pwd, kSecImportExportPassphrase, nil];
    CFArrayRef citems = NULL;
    OSStatus returnCode = SecPKCS12Import((__bridge CFDataRef) pkcs12key, (__bridge CFDictionaryRef) options, &citems);
    if (returnCode != 0) {
        return nil;
    }
    NSArray *items = (__bridge NSArray *)(citems);
    NSDictionary *myIdentityAndTrust = items[0];
    SecIdentityRef  identity = (__bridge SecIdentityRef) [myIdentityAndTrust objectForKey:(__bridge NSString *) kSecImportItemIdentity];
    SecKeyRef privateKey;
    returnCode = SecIdentityCopyPrivateKey(identity, &privateKey);
    if (returnCode != 0) {
        return nil;
    }
    return privateKey;
}
/**
 * 获取MD5
 */
+(NSString*)GetMD5:(NSString*)content {
    const char *str = [content cStringUsingEncoding:NSUTF8StringEncoding];
    CC_LONG strLen = (CC_LONG)[content lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strLen, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

+(NSData*)GetMD5Data:(NSData*)content {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(content.bytes, content.length, result);
    NSMutableData *hash = [NSMutableData new];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendBytes:&result[i] length:1];
    }
    return hash;
}

+ (NSData *)GetSHA1Data:(NSData*)content {
    NSMutableData *d = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(content.bytes, (CC_LONG) content.length, d.mutableBytes);
    return d;
}
/**
 * Des加密
 */
+(NSString*)DesEncrypt:(NSString*)content Key:(NSString*)key {
    return [Security DesEncrypt:content Key:key IV:nil];
}
/**
 * Des加密
 */
+(NSString*)DesEncrypt:(NSString*)content Key:(NSString*)key IV:(Byte[])iv {
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *result = [Security DesEncryptData:data Key:keyData IV:iv];
    if (result != nil) {
        return [result base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        return nil;
    }
}

+(NSData*)DesEncryptData:(NSData*)data Key:(NSData*)keyData IV:(Byte[])iv {
    const void *keyBytes = keyData.bytes;
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + kCCBlockSizeDES];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted  = 0;
    CCCryptorStatus cryptStatus;
    if(iv == nil) {
        cryptStatus = CCCrypt(kCCEncrypt,
                              kCCAlgorithmDES,
                              kCCOptionPKCS7Padding,
                              keyBytes,
                              kCCKeySizeDES,
                              nil,
                              dataBytes,
                              dataLength,
                              cryptPointer,
                              cryptLength,
                              &numBytesEncrypted);
    } else {
        cryptStatus = CCCrypt(kCCEncrypt,
                              kCCAlgorithmDES,
                              kCCOptionPKCS7Padding,
                              keyBytes,
                              kCCKeySizeDES,
                              iv,
                              dataBytes,
                              dataLength,
                              cryptPointer,
                              cryptLength,
                              &numBytesEncrypted);
    }
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}

/**
 * Des解密
 */
+(NSString*)DesDecrypt:(NSString*)content Key:(NSString*)key {
    return [Security DesDecrypt:content Key:key IV:nil];
}
/**
 * Des解密
 */
+(NSString*)DesDecrypt:(NSString*)content Key:(NSString*)key IV:(Byte[])iv {
    NSData *keyData  = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *result = [Security DesDecryptData:data Key:keyData IV:iv];
    if (result != nil) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+(NSData*)DesDecryptData:(NSData*)data Key:(NSData*)keyData IV:(Byte[])iv {
    const void *keyBytes = keyData.bytes;
    
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + kCCKeySizeDES];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus;
    if(iv == nil) {
        cryptStatus = CCCrypt(kCCDecrypt,
                              kCCAlgorithmDES,
                              kCCOptionPKCS7Padding,
                              keyBytes,
                              kCCKeySizeDES,
                              nil,
                              dataBytes,
                              dataLength,
                              cryptPointer,
                              cryptLength,
                              &numBytesEncrypted);
    } else {
        cryptStatus = CCCrypt(kCCDecrypt,
                              kCCAlgorithmDES,
                              kCCOptionPKCS7Padding,
                              keyBytes,
                              kCCKeySizeDES,
                              iv,
                              dataBytes,
                              dataLength,
                              cryptPointer,
                              cryptLength,
                              &numBytesEncrypted);
    }
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}
/**
 * Aes加密
 */
+(NSString*)AesEncrypt:(NSString*)content Key:(NSString*)key {
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *result = [Security AesEncryptData:data Key:keyData];
    if (result != nil) {
        return [result base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        return nil;
    }
}

+(NSData*)AesEncryptData:(NSData*)data Key:(NSData*)key {
    const void *keyBytes = [key subdataWithRange:NSMakeRange(0, 16)].bytes;
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + kCCBlockSizeAES128];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted  = 0;
    CCCryptorStatus cryptStatus;
    cryptStatus = CCCrypt(kCCEncrypt,
                          kCCAlgorithmAES,
                          kCCOptionPKCS7Padding,
                          keyBytes,
                          kCCKeySizeAES128,
                          nil,
                          dataBytes,
                          dataLength,
                          cryptPointer,
                          cryptLength,
                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}

+(NSData*)AesEncryptCBCData:(NSData*)data Key:(NSData*)key IV:(NSData*)iv {
    const void *sksBytes = [key subdataWithRange:NSMakeRange(0, 32)].bytes;
    const void *ivBytes = [iv subdataWithRange:NSMakeRange(0, 16)].bytes;
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + 32];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted  = 0;
    CCCryptorStatus cryptStatus;
    cryptStatus = CCCrypt(kCCEncrypt,
                          kCCAlgorithmAES,
                          kCCOptionPKCS7Padding,
                          sksBytes,
                          kCCKeySizeAES256,
                          ivBytes,
                          dataBytes,
                          dataLength,
                          cryptPointer,
                          cryptLength,
                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}

+(NSData*)AesDecrypCBCData:(NSData*)data Key:(NSData*)key IV:(NSData*)iv {
    const void *sksBytes = [key subdataWithRange:NSMakeRange(0, 32)].bytes;
    const void *ivBytes = [iv subdataWithRange:NSMakeRange(0, 16)].bytes;
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + 32];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted  = 0;
    CCCryptorStatus cryptStatus;
    cryptStatus = CCCrypt(kCCDecrypt,
                          kCCAlgorithmAES,
                          kCCOptionPKCS7Padding,
                          sksBytes,
                          kCCKeySizeAES256,
                          ivBytes,
                          dataBytes,
                          dataLength,
                          cryptPointer,
                          cryptLength,
                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}

/**
 * Aes解密
 */
+(NSString*)AesDecrypt:(NSString*)content Key:(NSString*)key {
    NSData *keyData  = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *result = [Security AesDecrypData:data Key:keyData];
    if (result != nil) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+(NSData*)AesDecrypData:(NSData*)data Key:(NSData*)key {
    const void *keyBytes = [key subdataWithRange:NSMakeRange(0, 16)].bytes;
    NSUInteger dataLength = data.length;
    const void *dataBytes = data.bytes;
    NSMutableData *cryptData = [[NSMutableData alloc]initWithLength:dataLength + kCCBlockSizeAES128];
    void *cryptPointer = cryptData.mutableBytes;
    size_t cryptLength = cryptData.length;
    
    size_t numBytesEncrypted  = 0;
    CCCryptorStatus cryptStatus;
    cryptStatus = CCCrypt(kCCDecrypt,
                          kCCAlgorithmAES,
                          kCCOptionPKCS7Padding,
                          keyBytes,
                          kCCKeySizeAES128,
                          nil,
                          dataBytes,
                          dataLength,
                          cryptPointer,
                          cryptLength,
                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        cryptData.length = numBytesEncrypted;
        return cryptData;
    } else {
        return nil;
    }
}
/**
 * 字符串转Base64
 */
+(NSString*)toBase64FromString:(NSString*)content {
    NSData *data  = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
}
/**
 * NSData转Base64
 */
+(NSString*)toBase64FromNSData:(NSData*)content {
    return [content base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}
/**
 * Base64转字符串
 */
+(NSString*)fromBase64ToString:(NSString*)content {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if(data == nil) {
        return nil;
    }
    return  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
/**
 * Base64转NSData
 */
+(NSData*)fromBase64ToNSData:(NSString*)content {
    return [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSString*)toHexString:(NSData*)data {
    NSUInteger bytesCount = data.length;
    if (bytesCount) {
        const char *hexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = data.bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = hexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return [hexString lowercaseString];
    }
    return @"";
}

+ (NSData*)fromHexString:(NSString*)str {
    NSMutableData *data = [NSMutableData new];
    for (int i = 0; i < str.length; i+=2) {
        NSString *hexChar = [str substringWithRange:NSMakeRange(i, 2)];
        uint8_t value1 = strtoul([hexChar UTF8String], nil, 16);
        [data appendBytes:&value1 length:sizeof(value1)];
    }
    return data;
}
@end

