//
//  GXCTransaction.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCTransaction.h"
#import "Categories.h"

@implementation GXCTransaction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operations = [NSMutableArray new];
        _extensions = [GXCExtensions new];
        _signature = [NSMutableArray new];
    }
    return self;
}

- (NSData*)toBaseByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt16:_blockNum];
    [data appendUInt32:_blockPrefix];
    [data appendUInt32:_expiration];
    [data appendUInt8:_operations.count];
    for (int i = 0; i < _operations.count; i++) {
        [data appendData:_operations[i].toOpByte];
    }
    [data appendData:_extensions.toByte];
    return data;
}

- (NSData*)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendData:_chainID];
    [data appendData:[self toBaseByte]];
    return data;
}

- (NSData*)getSignHash {
    return [SHAHash sha2256:[self toByte]];
}

- (NSDictionary*)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(_blockNum) forKey:GXC_KEY_REF_BLOCK_NUM];
    [dic setValue:@(_blockPrefix) forKey:GXC_KEY_REF_BLOCK_PREFIX];
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSString *time = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:_expiration]];
    [dic setValue:time forKey:GXC_KEY_EXPIRATION];
    NSMutableArray *operationsArray = [NSMutableArray new];
    for (int i = 0; i < _operations.count; i++) {
        [operationsArray addObject:_operations[i].toJsonArray];
    }
    [dic setValue:operationsArray forKey:GXC_KEY_OPERATIONS];
    
    NSMutableArray *signature = [NSMutableArray new];
    for (int i = 0; i < _signature.count; i++) {
        [signature addObject:[_signature[i] hexString]];
    }
    [dic setValue:signature forKey:GXC_KEY_SIGNATURES];
    [dic setValue:_extensions.toJson forKey:GXC_KEY_EXTENSIONS];
    return dic;
}

- (void)fromJson:(NSString*)json {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _blockNum = [dic[GXC_KEY_REF_BLOCK_NUM] unsignedShortValue];
    _blockPrefix = [dic[GXC_KEY_REF_BLOCK_PREFIX] unsignedIntegerValue];
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *date = [format dateFromString:dic[GXC_KEY_EXPIRATION]];
    _expiration = [date timeIntervalSince1970];
    NSArray *array = dic[GXC_KEY_SIGNATURES];
    for (int i = 0; i < array.count; i++) {
         [_signature addObject:[array[i] hexToData]];
    }
}

- (NSData*)sign:(GXCECKey*)key {
    NSData *sigData = nil;
    while (true) {
        NSData *hash = [self getSignHash];
        sigData = [[key sign:hash] encoding:YES];
        if ((([sigData UInt8AtOffset:1] & 0x80) != 0) || ([sigData UInt8AtOffset:1] == 0) || (([sigData UInt8AtOffset:2] & 0x80) != 0) || (([sigData UInt8AtOffset:33] & 0x80) != 0) || ([sigData UInt8AtOffset:33] == 0) || (([sigData UInt8AtOffset:34] & 0x80) != 0)) {
            _expiration++;
        } else {
            break;
        }
    }
    [_signature addObject:sigData];
    return sigData;
}

- (NSData*)getTxID {
    return [[SHAHash sha2256:[self toBaseByte]] subdataWithRange:NSMakeRange(0, 20)];
}

@end
