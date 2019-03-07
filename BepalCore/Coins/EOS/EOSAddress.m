//
//  EOSAddress.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/10.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAddress.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"

@implementation EOSAddress

- (instancetype)init:(NSData*)pubKey
{
    self = [super init];
    if (self) {
        pubkey = pubKey;
    }
    return self;
}

- (NSString*)toAddress {
    NSString *EOS_PREFIX = @"EOS";
    NSMutableData *pub = [NSMutableData new];
    [pub appendData:pubkey];
    [pub appendData:[pubkey.RMD160 subdataWithRange:NSMakeRange(0, 4)]];
    NSMutableString *address = [NSMutableString new];
    [address appendString:EOS_PREFIX];
    [address appendString:[NSString base58WithData:pub]];
    return address;
}

+ (NSData*)toPubKey:(NSString*)address {
    NSString *naddr = [address substringWithRange:NSMakeRange(3, address.length - 3)];
    NSData* daddr = naddr.base58ToData;
    return [daddr subdataWithRange:NSMakeRange(0, daddr.length - 4)];
}

@end
