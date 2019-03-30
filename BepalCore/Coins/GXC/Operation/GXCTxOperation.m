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

#import "GXCTxOperation.h"
#import "GXCOperationType.h"
#import "Categories.h"

@implementation GXCTxOperation

- (instancetype)init
{
    self = [super initWithType:GXC_OP_TRANSFER_OPERATION];
    if (self) {
        
    }
    return self;
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendData:self.fee.toByte];
    [data appendData:self.from.toByte];
    [data appendData:self.to.toByte];
    [data appendData:self.amount.toByte];
    if (_memo != nil) {
        [data appendData:_memo.toByte];
    } else {
        [data appendUInt8:0];
    }
    [data appendData:self.extensions.toByte];
    return data;
}

- (void)formJsonDic:(NSDictionary *)dic {
    [super formJsonDic:dic];
    _from = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_FROM]];
    _to = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_TO]];
    _amount = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_AMOUNT]];
    if (dic[GXC_KEY_MEMO]) {
        _memo = [[GXCMemo alloc] initWithJson:dic[GXC_KEY_MEMO]];
    }
}

- (id)toJson {
    NSMutableDictionary *dic = [super toJson];
    [dic setValue:_from.getId forKey:GXC_KEY_FROM];
    [dic setValue:_to.getId forKey:GXC_KEY_TO];
    [dic setValue:_amount.toJson forKey:GXC_KEY_AMOUNT];
    if (_memo != nil) {
        [dic setValue:_memo.toJson forKey:GXC_KEY_MEMO];
    }
    return dic;
}

@end
