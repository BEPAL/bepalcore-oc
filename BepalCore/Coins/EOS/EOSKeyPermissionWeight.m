//
//  EOSKeyPermissionWeight.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSKeyPermissionWeight.h"

@implementation EOSKeyPermissionWeight

- (instancetype)init
{
    self = [super init];
    if (self) {
        _weight = 1;
    }
    return self;
}

- (instancetype)init:(NSData*)pubKey
{
    self = [self init];
    if (self) {
        _pubKey = [[EOSKeyPermissionWeightPubKey alloc] init:pubKey];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:[_pubKey toByte]];
    [stream appendUInt16:_weight];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _pubKey = [[EOSKeyPermissionWeightPubKey alloc] init];
    [_pubKey parse:data :index];
    _weight = [data UInt16AtOffset:*index];
    *index = *index + 2;
}

@end

@implementation EOSKeyPermissionWeightPubKey

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)init:(NSData*)data
{
    self = [super init];
    if (self) {
        self.Type = 0;
        self.PubKey = data;
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendUVar:_Type];
    [stream appendData:_PubKey];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    NSUInteger len = 0;
    _Type = (uint32_t)[data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    _PubKey = [data subdataWithRange:NSMakeRange(*index, 33)];
    *index = *index + 33;
  
}

@end
