//
//  EOSDelegatebwMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSDelegatebwMessageData.h"

@implementation EOSDelegatebwMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_from.accountData];
    [stream appendData:_receiver.accountData];
    [_stakeNetQuantity toByte:stream];
    [_stakeCpuQuantity toByte:stream];
    [stream appendUVar:_transfer];
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _from = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _receiver = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _stakeNetQuantity = [EOSAsset toAsset:data :&index];
    _stakeCpuQuantity = [EOSAsset toAsset:data :&index];
    NSUInteger len = 0;
    _transfer = [data eosVarIntAtOffset:index length:&len];
    index += len;
}

@end
