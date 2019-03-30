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
