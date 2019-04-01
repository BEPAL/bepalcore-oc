/*
 * Copyright (c) 2018-2019, BEPAL
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
        [data appendUVar:_enMessage.length];
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
