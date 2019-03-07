//
//  EOSAuthority.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAuthority.h"

@implementation EOSAuthority

- (instancetype)init
{
    self = [super init];
    if (self) {
        _threshold = 1;
        _keys = [NSMutableArray new];
        _accounts = [NSMutableArray new];
        _weights = [NSMutableArray new];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendUInt32:_threshold];
    [stream appendUVar:_keys.count];
    for (int i = 0; i < _keys.count; i++) {
        [stream appendData:[_keys[i] toByte]];
    }
    [stream appendUVar:_accounts.count];
    for (int i = 0; i < _accounts.count; i++) {
        [stream appendData:[_accounts[i] toByte]];
    }
    [stream appendUVar:_weights.count];
    for (int i = 0; i < _weights.count; i++) {
        [stream appendData:[_weights[i] toByte]];
    }
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _threshold = [data UInt32AtOffset:*index];
    *index = *index + 4;
    NSUInteger len = 0;
    uint64_t count = [data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    for (int i = 0; i < count; i++) {
        EOSKeyPermissionWeight *weight = [EOSKeyPermissionWeight new];
        [weight parse:data :index];
        [_keys addObject:weight];
    }
    count = [data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    for (int i = 0; i < count; i++) {
        EOSAccountPermissionWeight *weight = [EOSAccountPermissionWeight new];
        [weight parse:data :index];
        [_accounts addObject:weight];
    }
    count = [data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    for (int i = 0; i < count; i++) {
        EOSWaitWeight *weight = [EOSWaitWeight new];
        [weight parse:data :index];
        [_weights addObject:weight];
    }
}

- (void)addKey:(EOSKeyPermissionWeight*)key {
    [_keys addObject:key];
}

- (void)addAccount:(EOSAccountPermissionWeight*)account {
    [_accounts addObject:account];
}

@end
