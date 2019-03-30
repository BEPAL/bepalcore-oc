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

#import "GXCECKey.h"
#import "BitECKey.h"
#import "SDKStaticPara.h"
#import "Categories.h"
#import "GXCAddress.h"
#import "BigNumber.h"
#import "ErrorTool.h"
#import "secp256k1.h"

@interface GXCECKey() {
    const ecdsa_curve *curve;
}

@end

@implementation GXCECKey

- (instancetype)init
{
    self = [super init];
    if (self) {
        curve = &secp256k1;
    }
    return self;
}

- (instancetype)initWithKey:(NSData*)priKey Pub:(NSData*)pubKey {
    self = [self init];
    if (self) {
        privateKey = priKey;
        if (pubKey == nil && privateKey != nil) {
            publicKey = [BitECKey prvKeyToPubKey:priKey];
        } else {
            publicKey = pubKey;
        }
        
        NSArray *len = [self getKeyLength];
        [ErrorTool checkArgument:
         privateKey == nil || privateKey.length == [len[0] intValue]
                            Mess:@"privateKey error"
                             Log:[NSString stringWithFormat:@"%@  %lu  %@",privateKey.hexString,(unsigned long)privateKey.length,len[0]]];
        [ErrorTool checkArgument:
         publicKey == nil || publicKey.length == [len[1] intValue]
                            Mess:@"publicKey error"
                             Log:[NSString stringWithFormat:@"%@  %lu  %@",publicKey.hexString,(unsigned long)publicKey.length,len[1]]];
    }
    return self;
}

- (instancetype)initWithPubKeyString:(NSString *)pubKey {
    NSData *data = [GXCAddress toPubKey:pubKey];
    return [self initWithPubKey:data];
}

- (NSString*)toPubblicKeyString {
    return [GXCAddress toAddress:publicKey];
}

- (NSString*)toWif {
    NSMutableData *resultWIFBytes = [NSMutableData new];
    [resultWIFBytes appendUInt8:0x80];
    [resultWIFBytes appendData:privateKey];
    [resultWIFBytes appendData:[resultWIFBytes.SHA256_2 subdataWithRange:NSMakeRange(0, 4)]];
    return [NSString base58WithData:resultWIFBytes];
}

- (ECSign*)sign:(NSData*)mess {
    uint8_t sig[64];
    uint8_t hash[32];
    memcpy(hash, mess.bytes, 32);
    uint8_t pub[33];
    memcpy(pub, publicKey.bytes, 33);
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        ecdsa_sign_digest(curve, privateKey.bytes, hash, sig, pub, NULL);
    }
    memzero(hash, sizeof(hash));
    memzero(pub, sizeof(pub));
    ECSign *sign = [[ECSign alloc] initWithBytes:sig V:0xFF];
    for (int i = 0; i < 4; i++) {
        NSData *key = [BitECKey recoverPublicKey:i Hash:mess Sign:sign];
        if (strncmp(publicKey.bytes, key.bytes, publicKey.length) == 0) {
            sign.V = i;
            break;
        }
    }
    if (sign.V == 0xFF) {
        [ErrorTool throwMessage:@"recid error"];
        return nil;
    }
    return sign;
}

- (Boolean)verify:(NSData*)mess :(ECSign*)sig {
    uint8_t hash[32];
    memcpy(hash, mess.bytes, 32);
    uint8_t pub[33];
    memcpy(pub, publicKey.bytes, 33);
    int result = 0;
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        result = ecdsa_verify_digest(curve, pub, sig.toDataNoV.bytes, hash);
    }
    memzero(hash, sizeof(hash));
    memzero(pub, sizeof(pub));
    return result == 0;
}

- (NSArray*)getKeyLength {
    return @[@32,@33];
}

+ (NSData*)multiplyPubKey:(NSData*)pubKey PriKey:(NSData*)priKey {
    ecdsa_curve curve = secp256k1;
    curve_point pub;
    ecdsa_read_pubkey(&curve, pubKey.bytes, &pub);
    curve_point res;
    bignum256 pri;
    bn_read_be(priKey.bytes, &pri);
    point_multiply(&curve, &pri, &pub, &res);
    BigNumber *bignum = [[BigNumber alloc] initWithBigNumBE:res.x];
    return [bignum toData];
}

@end
