//
//  EOSVoteProducerMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSVoteProducerMessageData.h"
#import "EOSTransaction.h"

@implementation EOSVoteProducerMessageData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _producers = [NSMutableArray new];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_voter.accountData];
    [stream appendData:_proxy.accountData];
    [stream appendUVar:_producers.count];
    [EOSTransaction sortAccountName:_producers];
    for (int i = 0; i < _producers.count; i++) {
        [stream appendData:_producers[i].accountData];
    }
    return stream;
}

- (void)parse:(NSData *)data {
    NSUInteger index = 0;
    _voter = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    _proxy = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
    index = index + 8;
    
    NSUInteger len = 0;
    uint64_t count = [data eosVarIntAtOffset:index length:&len];
    index = index + len;
    for (int i = 0; i < count; i++) {
        EOSAccountName *temp = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(index, 8)]];
        index = index + 8;
        [_producers addObject:temp];
    }
}

@end
