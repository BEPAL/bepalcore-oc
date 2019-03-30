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
