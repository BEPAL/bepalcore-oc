//
//  EOSSellRamMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSSellRamMessageData.h"

@implementation EOSSellRamMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_account.accountData];
    [stream appendUInt64:_bytes];
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _account = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _bytes = [data UInt64AtOffset:index];
    index = index + 8;
}

@end
