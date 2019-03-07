//
//  BitECKey.m
//  ectest
//
//  Created by 潘孝钦 on 2018/3/20.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "BitECKey.h"
#include "memzero.h"
#import "Categories.h"
#import "SDKStaticPara.h"
#import "ErrorTool.h"
#import "secp256k1.h"

@interface BitECKey() {
    const ecdsa_curve *curve;
}

@end

@implementation BitECKey

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

+ (NSData*)prvKeyToPubKey:(NSData*)prvKey {
    const ecdsa_curve *curve = &secp256k1;
    uint8_t priv[32];
    memcpy(priv, prvKey.bytes, 32);
    uint8_t pub[33];
    
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        ecdsa_get_public_key33(curve, priv, pub);
    }
    NSData* publicKey = [[NSData alloc] initWithBytes:pub length:33];
    memzero(priv, sizeof(priv));
    memzero(pub, sizeof(pub));
    return publicKey;
}

- (ECSign*)sign:(NSData*)mess {
    uint8_t sig[64];
    uint8_t hash[32];
    memcpy(hash, mess.bytes, 32);
    uint8_t pby = 0;
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        ecdsa_sign_digest(curve, privateKey.bytes, hash, sig, &pby, NULL);
    }
    memzero(hash, sizeof(hash));
    ECSign *sign = [[ECSign alloc] initWithBytes:sig V:0xFF];
    sign.V = pby;
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

+ (NSData*)recoverPublicKey:(NSData*)mess Sign:(ECSign*)sig {
    return [BitECKey recoverPublicKey:sig.V Hash:mess Sign:sig];
}

+ (NSData*)recoverPublicKey:(uint8_t)recid Hash:(NSData*)hashdata Sign:(ECSign*)sig {
    const uint8_t *msg = (const uint8_t *)hashdata.bytes;
    uint8_t hash[32];
    memcpy(hash, hashdata.bytes, 32);
    uint8_t pub[65] = {};
    uint8_t sigdata[64];
    memcpy(sigdata, sig.toDataNoV.bytes, 64);
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        ecdsa_verify_digest_recover(&secp256k1, pub, sigdata, msg, recid);
    }
    NSData *datapub = [[NSData alloc] initWithBytes:pub length:65];
    NSData *datax = [datapub subdataWithRange:NSMakeRange(1, 32)];
    NSData *datay = [datapub subdataWithRange:NSMakeRange(33, 32)];
    bignum256 y = {};
    bn_read_be(datay.bytes, &y);
    uint8_t val = 0x02 | (y.val[0] & 0x01);
    NSMutableData *pubkey = [NSMutableData new];
    [pubkey appendUInt8:val];
    [pubkey appendData:datax];
    return pubkey;
}

- (NSArray*)getKeyLength {
    return @[@32,@33];
}

- (NSString*)getPrivateKeyAsWiF:(int)version {
    NSMutableData *bversion = [NSMutableData new];
    if (version <= 255) {
        [bversion appendUInt8:version];
    } else {
        [bversion appendUInt8:version >> 8 & 0xFF];
        [bversion appendUInt8:version & 0xFF];
    }
    [ErrorTool checkArgument:privateKey.length == 32 Mess:@"私钥长度错误"];
    NSMutableData *data = [NSMutableData new];
    [data appendData:bversion];
    [data appendData:privateKey];
    [data appendUInt8:1];//表示公钥被压缩
    [data appendData:[[SHAHash sha2256:[SHAHash sha2256:data]] subdataWithRange:NSMakeRange(0, 4)]];
    return [NSString base58WithData:data]; //Base58.encode(data.toBytes());
}

@end
