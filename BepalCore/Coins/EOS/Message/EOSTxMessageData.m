//
//  EOSTxMessageData.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSTxMessageData.h"


@implementation EOSTxMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_from.accountData];
    [stream appendData:_to.accountData];
    [_amount toByte:stream];
    if (_data != nil) {
        [stream appendUVar:_data.length];
        [stream appendData:_data];
    } else {
        [stream appendUInt8:0];
    }
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _from = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _to = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _amount = [EOSAsset toAsset:data :&index];
    if (data.length > index) {
        NSUInteger len = 0;
        _data = [data dataAtOffset:index length:&len];
        index += len;
    }
}

@end
