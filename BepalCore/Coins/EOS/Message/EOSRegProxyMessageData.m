//
//  EOSRegProxyMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSRegProxyMessageData.h"

@implementation EOSRegProxyMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_proxy.accountData];
    [stream appendUInt8:_isProxy ? 1 : 0];
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _proxy = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _isProxy = [data UInt8AtOffset:index] == 1;
    index = index + 1;
}

@end
