//
//  EOSBuyRamMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSBuyRamMessageData.h"

@implementation EOSBuyRamMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_payer.accountData];
    [stream appendData:_receiver.accountData];
    [_quant toByte:stream];
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _payer = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _receiver = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _quant = [EOSAsset toAsset:data :&index];
}

@end
