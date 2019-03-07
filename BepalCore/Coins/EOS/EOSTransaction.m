//
//  EOSTransaction.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSTransaction.h"
#import "Security.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"

@implementation EOSTransaction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contextFreeActions = [NSMutableArray new];
        _actions = [NSMutableArray new];
        _signature = [NSMutableArray new];
        _extensionsType = [NSMutableDictionary new];
    }
    return self;
}

+ (void)sortAccountName:(NSMutableArray<EOSAccountName*>*)accountNames {
    for (NSUInteger i = accountNames.count - 1; i > 0; --i) {
        for (NSUInteger j = 0; j < i; ++j) {
            if (accountNames[j + 1].accountValue < accountNames[j].accountValue) {
                EOSAccountName *temp = accountNames[j];
                accountNames[j] = accountNames[j + 1];
                accountNames[j + 1] = temp;
            }
        }
    }
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendUInt32:_expiration];
    [stream appendUInt16:_blockNum];
    [stream appendUInt32:_blockPrefix];
    [stream appendUVar:_netUsageWords];
    [stream appendUInt8:_kcpuUsage];
    [stream appendUVar:_delaySec];
    
    [stream appendUVar:_contextFreeActions.count];
    for (int i = 0; i < _contextFreeActions.count; i++) {
        [stream appendData:[_contextFreeActions[i] toByte]];
    }
    [stream appendUVar:_actions.count];
    for (int i = 0; i < _actions.count; i++) {
        [stream appendData:[_actions[i] toByte]];
    }
    
    [stream appendUVar:_extensionsType.count];
    NSArray *keysArray = [_extensionsType allKeys];//获取所有键存到数组
    NSArray *sortedArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        int a = [obj1 intValue];
        int b = [obj1 intValue];
        if (a == b) {
            return NSOrderedSame;
        }
        if (a > b) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    for (NSNumber *key in sortedArray) {
        NSString *value = [_extensionsType objectForKey: key];
        [stream appendUInt16:key.intValue];
        [stream appendString:value];
    }
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _expiration = [data UInt32AtOffset:index];
    index+=4;
    _blockNum = [data UInt16AtOffset:index];
    index+=2;
    _blockPrefix = [data UInt32AtOffset:index];
    index+=4;
    NSUInteger len = 0;
    _netUsageWords = (uint32_t)[data eosVarIntAtOffset:index length:&len];
    index+=len;
    _kcpuUsage = (uint32_t)[data UInt8AtOffset:index];
    index+=1;
    _delaySec = (uint32_t)[data eosVarIntAtOffset:index length:&len];
    index+=len;
    
    uint64_t count = [data eosVarIntAtOffset:index length:&len];
    index = index + len;
    for (int i = 0; i < count; i++) {
        EOSAction *action = [[EOSAction alloc] init];
        [action parse:data :&index];
        [_contextFreeActions addObject:action];
    }
    count = [data eosVarIntAtOffset:index length:&len];
    index = index + len;
    for (int i = 0; i < count; i++) {
        EOSAction *action = [EOSAction new];
        [action parse:data :&index];
        [_actions addObject:action];
    }
    count = [data eosVarIntAtOffset:index length:&len];
    index = index + len;
    for (int i = 0; i < count; i++) {
        int key = [data UInt16AtOffset:index];
        index = index + 2;
        NSString *value = [data stringAtOffset:index length:&len];
         index = index + len;
        [_extensionsType setObject:value forKey:@(key)];
    }
}

- (NSData*)toSignData {
    if (_chainID == nil) {
        return nil;
    }
    NSMutableData *stream = [NSMutableData new];
    //pack chain_id
    [stream appendData:_chainID];
    [stream appendData:[self toByte]];
    [stream appendData:[Security fromHexString:@"0000000000000000000000000000000000000000000000000000000000000000"]];
    return stream;
}

- (NSData*)getSignHash {
    return [self toSignData].SHA256;
}

- (NSDictionary*)toJson {
    NSMutableDictionary *jstx = [NSMutableDictionary new];

    NSMutableArray *signature = [NSMutableArray new];
    if (_signature.count != 0) {
        for (int i = 0; i < _signature.count; i++) {
            [signature addObject:[EOSTransaction toEOSSignature:_signature[i]]];
        }
    }
    jstx[@"compression"] = @"none";
    jstx[@"signatures"] = signature;
    jstx[@"packed_trx"] = [Security toHexString:self.toByte];
    return jstx;
}

+ (NSString*)toEOSSignature:(NSData*)data {
    NSString *EOS_PREFIX = @"SIG_K1_";
    NSMutableData *temp = [NSMutableData new];
    [temp appendData:data];
    [temp appendData:[@"K1" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:data];
    [stream appendData:[temp.RMD160 subdataWithRange:NSMakeRange(0, 4)]];
    return [EOS_PREFIX stringByAppendingString:[NSString base58WithData:stream]];
}

- (EOSAccountName*)getOtherScope:(EOSAccountName*)name {
    return nil;
}

- (NSData*)getTxID {
    return [self toByte].SHA256;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
