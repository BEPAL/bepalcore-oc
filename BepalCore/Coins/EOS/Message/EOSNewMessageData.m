//
//  EOSNewMessageData.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSNewMessageData.h"

@implementation EOSNewMessageData

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_creator.accountData];
    [stream appendData:_name.accountData];
    [stream appendData:_owner.toByte];
    [stream appendData:_active.toByte];
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _creator = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _name = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _owner = [EOSAuthority new];
    [_owner parse:data :&index];
    _active = [EOSAuthority new];
    [_active parse:data :&index];
}

@end
