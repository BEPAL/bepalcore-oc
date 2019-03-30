//
//  GXCMemo.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCMemo.h"
#import "Categories.h"
#import "Security.h"

@implementation GXCMemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _from = nil;
        _to = nil;
        _message = nil;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary*)json
{
    self = [super init];
    if (self) {
        [self formJson:json];
    }
    return self;
}

- (instancetype)initWithAddressFrom:(GXCAddress*)from To:(GXCAddress*)to Nonce:(NSData*)nonce
{
    self = [super init];
    if (self) {
        _from = from;
        _to = to;
        _nonce = nonce;
    }
    return self;
}

- (instancetype)initWithKeyFrom:(GXCECKey*)from To:(GXCECKey*)to Nonce:(NSData*)nonce
{
    self = [super init];
    if (self) {
        _from = [[GXCAddress alloc] initWithKey:from];
        _to = [[GXCAddress alloc] initWithKey:to];
        _nonce = nonce;
    }
    return self;
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    if (_from == nil || _to == nil) {
        [data appendUInt8:0];
    } else {
        [data appendUInt8:1];
        [data appendData:_from.getKey.publicKeyAsData];
        [data appendData:_to.getKey.publicKeyAsData];
        [data appendData:_nonce];
        [data appendUInt8:_enMessage.length];
        [data appendData:_enMessage];
    }
    return data;
}

- (void)formJson:(NSDictionary*)dic {
    _from = [[GXCAddress alloc] initWithString:dic[GXC_KEY_FROM]];
    _to = [[GXCAddress alloc] initWithString:dic[GXC_KEY_TO]];
    NSMutableData *data = [NSMutableData new];
    [data appendUInt64:[dic[GXC_KEY_NONCE] unsignedLongLongValue]];
    _nonce = data;
    _enMessage = [dic[GXC_KEY_MESSAGE] hexToData];
}

- (id)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_from.description forKey:GXC_KEY_FROM];
    [dic setValue:_to.description forKey:GXC_KEY_TO];
    [dic setValue:[NSString stringWithFormat:@"%llu",[_nonce UInt64AtOffset:0]] forKey:GXC_KEY_NONCE];
    [dic setValue:[_enMessage hexString] forKey:GXC_KEY_MESSAGE];
    return dic;
}

- (NSData*)encryptWithKey:(GXCECKey*)key Message:(NSData*)message {
    _message = message;
    if (key == nil) {
        return message;
    }
    _enMessage = [GXCMemo encryptWithSend:key Recipient:_to.getKey Nonce:_nonce Message:message];
    return _enMessage;
}

- (NSData*)decryptMessage:(GXCECKey*)key {
    if (key == nil) {
        return _message;
    }
    _message = [GXCMemo decryptWithRecipient:key Send:_from.getKey Nonce:_nonce Message:_enMessage];
    return _message;
}

+ (NSData*)encryptWithSend:(GXCECKey*)senderKey Recipient:(GXCECKey*)recipientKey Nonce:(NSData*)nonce Message:(NSData*)message {
    NSString *stringNonce = [NSString stringWithFormat:@"%llu",[nonce UInt64AtOffset:0]];
    NSData *nonceBytes = [stringNonce dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *secret = [GXCECKey multiplyPubKey:recipientKey.publicKeyAsData PriKey:senderKey.privateKeyAsData];

    NSData *ss = [SHAHash sha2512:secret];
    
    NSMutableData *seed = [NSMutableData new];
    [seed appendData:nonceBytes];
    [seed appendData:[ss.hexString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *sha256Msg = [SHAHash sha2256:message];
    NSData *checksum = [sha256Msg subdataWithRange:NSMakeRange(0, 4)];
    
    NSMutableData *msgFinal = [NSMutableData new];
    [msgFinal appendData:checksum];
    [msgFinal appendData:message];
    
    return [self encryptAES:msgFinal Key:seed];
}

+ (NSData*)decryptWithRecipient:(GXCECKey*)recipientKey Send:(GXCECKey*)senderKey Nonce:(NSData*)nonce Message:(NSData*)message {
    NSString *stringNonce = [NSString stringWithFormat:@"%llu",[nonce UInt64AtOffset:0]];
    NSData *nonceBytes = [stringNonce dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *secret = [GXCECKey multiplyPubKey:senderKey.publicKeyAsData PriKey:recipientKey.privateKeyAsData];
    
    NSData *ss = [SHAHash sha2512:secret];
    
    NSMutableData *seed = [NSMutableData new];
    [seed appendData:nonceBytes];
    [seed appendData:[ss.hexString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *temp = [self decryptAES:message Key:seed];
    
    NSData *checksum = [temp subdataWithRange:NSMakeRange(0, 4)];
    NSData *decrypted = [temp subdataWithRange:NSMakeRange(4, temp.length - 4)];

    NSData *checksumConfirmation = [[SHAHash sha2256:decrypted] subdataWithRange:NSMakeRange(0, 4)];
    
    if (![checksum isEqualToData:checksumConfirmation]) {
        return nil;
    }
    return decrypted;
}

+ (NSData*)encryptAES:(NSData*)input Key:(NSData*)key {
    NSData *result = [SHAHash sha2512:key];
    NSData *ivBytes = [result subdataWithRange:NSMakeRange(32, 16)];
    NSData *sksBytes = [result subdataWithRange:NSMakeRange(0, 32)];
    return [Security AesEncryptCBCData:input Key:sksBytes IV:ivBytes];
}

+ (NSData*)decryptAES:(NSData*)input Key:(NSData*)key {
    NSData *result = [SHAHash sha2512:key];
    NSData *ivBytes = [result subdataWithRange:NSMakeRange(32, 16)];
    NSData *sksBytes = [result subdataWithRange:NSMakeRange(0, 32)];
    return [Security AesDecrypCBCData:input Key:sksBytes IV:ivBytes];
}

@end
