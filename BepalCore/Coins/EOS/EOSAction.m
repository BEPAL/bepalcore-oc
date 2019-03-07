//
//  EOSMessage.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAction.h"
#import "Security.h"
#import "EOSNewMessageData.h"
#import "EOSTxMessageData.h"
#import "EOSVoteProducerMessageData.h"

@implementation EOSAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authorization = [NSMutableArray new];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_account.accountData];
    [stream appendData:_name.accountData];
    [stream appendUVar:_authorization.count];
    for (int i = 0; i < _authorization.count; i++) {
        [stream appendData:[_authorization[i] toByte]];
    }
    NSData *data = _data.toByte;
    [stream appendUVar:data.length];
    [stream appendData:data];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _account = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(*index, 8)]];
    *index = *index + 8;
    _name = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(*index, 8)]];
    *index = *index + 8;
    NSUInteger len = 0;
    uint64_t count = [data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    for (int i = 0; i < count; i++) {
        EOSAccountPermission *permission = [EOSAccountPermission new];
        [permission parse:data :index];
        [_authorization addObject:permission];
    }
    if ([@"transfer" isEqualToString:_name.accountName]) {
        _data = [EOSTxMessageData new];
    } else if ([@"newaccount" isEqualToString:_name.accountName]) {
        _data = [EOSNewMessageData new];
    } else if ([@"voteproducer" isEqualToString:_name.accountName]) {
        _data = [EOSVoteProducerMessageData new];
    }
    count = [data eosVarIntAtOffset:*index length:&len];
    *index = *index + len;
    [_data parse:[data subdataWithRange:NSMakeRange(*index, count)]];
    *index = *index + count;
}

@end
