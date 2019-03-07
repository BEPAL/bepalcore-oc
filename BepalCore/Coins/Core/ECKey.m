//
//  ECKey.m
//  ectest
//
//  Created by 潘孝钦 on 2018/3/20.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ECKey.h"
#import "Security.h"
#import "ErrorTool.h"

@implementation ECKey

- (instancetype)initWithPriKey:(NSData*)priKey {
    return [self initWithKey:priKey Pub:nil];
}

- (instancetype)initWithPubKey:(NSData*)pubKey {
    return [self initWithKey:nil Pub:pubKey];
}

- (instancetype)initWithKey:(NSData*)priKey Pub:(NSData*)pubKey {
    [ErrorTool unimplementedMethod];
    return nil;
}

- (NSData*)privateKeyAsData {
    return privateKey;
}

- (NSData*)publicKeyAsData {
    return publicKey;
}

- (NSString*)privateKeyAsHex {
    return [Security toHexString:privateKey];
}

- (NSString*)publicKeyAsHex {
    return [Security toHexString:publicKey];
}

- (ECSign*)sign:(NSData *)mess {
    [ErrorTool unimplementedMethod];
    return nil;
}

- (NSString*)signAsHex:(NSData*)mess {
    return [self sign:mess].toHex;
}

- (Boolean)verify:(NSData *)mess :(ECSign *)sig {
    [ErrorTool unimplementedMethod];
    return false;
}

- (NSArray*)getKeyLength {
    [ErrorTool unimplementedMethod];
    return nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"\nprivateKey:%@ \npublicKey:%@", [Security toHexString:privateKey],[Security toHexString:publicKey]];
}

@end
