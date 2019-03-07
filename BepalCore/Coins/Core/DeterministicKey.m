//
//  DeterministicKey.m
//  ectest
//
//  Created by 潘孝钦 on 2018/5/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "DeterministicKey.h"
#import "Security.h"
#import <CommonCrypto/CommonCrypto.h>
#import "SDKStaticPara.h"
#import "Categories.h"
#import "ErrorTool.h"

@interface DeterministicKey ()

@property(assign,nonatomic) uint32_t Depth;
@property(assign,nonatomic) uint32_t ParentFingerprint;
@property(assign,nonatomic) uint32_t KeyPath;

@end

@implementation DeterministicKey

- (instancetype)initWithXPri:(NSData*)xpri
{
    self = [self initWithPri:[xpri subdataWithRange:NSMakeRange(4, 33)] Pub:nil Code:[xpri subdataWithRange:NSMakeRange(4 + 33, 33)]];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithXPub:(NSData*)xpub
{
    self = [self initWithPri:nil Pub:[xpub subdataWithRange:NSMakeRange(4, 33)] Code:[xpub subdataWithRange:NSMakeRange(4 + 33, 33)]];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithPri:(NSData*)pri Pub:(NSData*)pub Code:(NSData*)code
{
    self = [super init];
    if (self) {
        if (pri != nil && [pri UInt8AtOffset:0] == 0 && pri.length > 32) {
            pri = [pri subdataWithRange:NSMakeRange(1, 32)];
        }
        if (pub != nil && [pub UInt8AtOffset:0] == 0 && pub.length > 32) {
            pub = [pub subdataWithRange:NSMakeRange(1, 32)];
        }
        if (code != nil && [code UInt8AtOffset:0] == 0 && code.length > 32) {
            code = [code subdataWithRange:NSMakeRange(1, 32)];
        }
        privateKey = pri;
        publicKey = pub;
        chainCode = code;
        NSArray *len = [self getKeyLength];
        [ErrorTool checkArgument:
         privateKey == nil || privateKey.length == [len[0] intValue]
                            Mess:@"privateKey parent error"
                             Log:[NSString stringWithFormat:@"%@  %lu  %@",privateKey.hexString,(unsigned long)privateKey.length,len[0]]];
        [ErrorTool checkArgument:
         publicKey == nil || publicKey.length == [len[1] intValue]
                            Mess:@"publicKey parent error"
                             Log:[NSString stringWithFormat:@"%@  %lu  %@",publicKey.hexString,(unsigned long)publicKey.length,len[1]]];
        [ErrorTool checkArgument:
         chainCode != nil && chainCode.length == [len[2] intValue]
                            Mess:@"chainCode error"
                             Log:[NSString stringWithFormat:@"%@  %lu  %@",chainCode.hexString,(unsigned long)chainCode.length,len[2]]];
    }
    return self;
}

- (instancetype)initWithSeed:(NSData*)seed {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithStandardKey:(NSData*)key XPrvHead:(uint32_t)xprvhead {
    self = [super init];
    if (self) {
        [ErrorTool checkArgument:key != nil && key.length >= 78 Mess:@"XKey Error"];
        uint32_t head = [key UInt32AtOffset:0];
        int start = 4 + 1 + 4 + 4;
        NSData *code = [key subdataWithRange:NSMakeRange(start, 32)];
        if (head == xprvhead) {
            NSData *priKey = [key subdataWithRange:NSMakeRange(start + 32, 32)];
            return [self initWithPri:priKey Pub:nil Code:code];
        } else {
            NSData *pubKey = [key subdataWithRange:NSMakeRange(start + 32, 33)];
            return [self initWithPri:nil Pub:pubKey Code:code];
        }
    }
    return self;
}

- (NSString*)toXPriv:(int)prefix {
    return [Security toHexString:[self toXPrivive:prefix]];
}

- (NSString*)toXPub:(int)prefix {
    return [Security toHexString:[self toXPublic:prefix]];
}

- (NSData*)toXPrivive:(int)prefix {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt32LE:prefix];
    if (privateKey.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:privateKey];
    if (chainCode.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:chainCode];
    return data;
}

- (NSData*)toXPublic:(int)prefix {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt32LE:prefix];
    if (publicKey.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:publicKey];
    if (chainCode.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:chainCode];
    return data;
}

- (NSData*)toXPrivive {
    return [self toXPrivive:1];
}

- (NSData*)toXPublic {
    return [self toXPublic:2];
}

- (NSData*)toStandardXPrivate:(int)prefix {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt32LE:prefix];
    [data appendUInt8:_Depth];
    [data appendUInt32LE:_ParentFingerprint];
    [data appendUInt32LE:_KeyPath];
    [data appendData:chainCode];
    if (privateKey.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:privateKey];
    return data;
}

- (NSData*)toStandardXPublic:(int)prefix {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt32LE:prefix];
    [data appendUInt8:_Depth];
    [data appendUInt32LE:_ParentFingerprint];
    [data appendUInt32LE:_KeyPath];
    [data appendData:chainCode];
    if (publicKey.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:publicKey];
    return data;
}

- (NSString*)toStandardXPrv:(int)prefix {
    return [NSString base58checkWithData:[self toStandardXPrivate:prefix]];
}

- (NSString*)toStandardXPub:(int)prefix {
    return [NSString base58checkWithData:[self toStandardXPublic:prefix]];
}

- (Boolean)hasPrivateKey {
    return privateKey != nil;
}

- (NSData*)getPrivKeyBytes33 {
    NSMutableData *data = [NSMutableData new];
    if (privateKey.length == 32) {
        [data appendUInt8:0];
    }
    [data appendData:privateKey];
    return data;
}

- (NSData*)getPrivKey {
    return privateKey;
}

- (DeterministicKey*)derive:(NSArray*)childNumbers {
    @synchronized([[SDKStaticPara getOrCreate] getSynchronizedDeterministicKey]) {
        DeterministicKey *temp = self;
        for (int i = 0; i < childNumbers.count; i++) {
            DeterministicKey *temp1 = temp;
            if ([temp hasPrivateKey]) {
                temp = [temp privChild:childNumbers[i]];
            } else {
                temp = [temp pubChild:childNumbers[i]];
            }
            temp.Depth = temp1.Depth + 1;
            temp.KeyPath = [childNumbers[i] getKeyPath];
            temp.ParentFingerprint = temp1.getFingerprint;
        }
        return temp;
    }
}

- (uint32_t)getFingerprint {
    NSData *hash = [publicKey.SHA256_2 subdataWithRange:NSMakeRange(0, 4)];
    return CFSwapInt32LittleToHost(*(const uint32_t *) ((const uint8_t *) hash.bytes));
}

- (DeterministicKey*)privChild:(ChildNumber*)childNumber {
    return nil;
}

- (DeterministicKey*)pubChild:(ChildNumber*)childNumber {
    return nil;
}

- (id)toECKey {
    return nil;
}

- (NSArray*)getKeyLength {
    [ErrorTool unimplementedMethod];
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nprivateKey:%@ \npublicKey:%@ \nchainCode:%@", [Security toHexString:privateKey],[Security toHexString:publicKey],[Security toHexString:chainCode]];
}

@end
