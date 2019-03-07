//
//  GXCAddress.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCAddress.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"

@implementation GXCAddress

- (instancetype)initWithKey:(GXCECKey*)key
{
    self = [super init];
    if (self) {
        ecKey = key;
    }
    return self;
}

- (instancetype)initWithString:(NSString*)pubKey
{
    self = [super init];
    if (self) {
        ecKey = [[GXCECKey alloc] initWithPubKey:[GXCAddress toPubKey:pubKey]];
    }
    return self;
}

- (NSString *)description
{
    return [GXCAddress toAddress:ecKey.publicKeyAsData];
}

- (GXCECKey*)getKey {
    return ecKey;
}

+ (NSData*)toPubKey:(NSString*)base58Data {
    NSString *naddr = [base58Data substringWithRange:NSMakeRange(3, base58Data.length - 3)];
    NSData* daddr = naddr.base58ToData;
    return [daddr subdataWithRange:NSMakeRange(0, daddr.length - 4)];
}

+ (NSString*)toAddress:(NSData*)pubKey {    
    NSString *EOS_PREFIX = @"GXC";
    NSMutableData *pub = [NSMutableData new];
    [pub appendData:pubKey];
    [pub appendData:[pubKey.RMD160 subdataWithRange:NSMakeRange(0, 4)]];
    NSMutableString *address = [NSMutableString new];
    [address appendString:EOS_PREFIX];
    [address appendString:[NSString base58WithData:pub]];

    return address;
}

@end
