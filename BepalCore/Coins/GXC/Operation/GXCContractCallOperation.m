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

#import "GXCContractCallOperation.h"
#import "GXCOperationType.h"
#import "Categories.h"
#import "EOSAccountName.h"

@implementation GXCContractCallOperation

- (instancetype)init
{
    self = [super initWithType:GXC_OP_CONTRACT_CALL_OPERATION];
    if (self) {
        
    }
    return self;
}

- (id)toJson {
    NSMutableDictionary *dic = [super toJson];
    [dic setValue:_account.getId forKey:GXC_KEY_ACCOUNT];
    [dic setValue:_amount.toJson forKey:GXC_KEY_AMOUNT];
    [dic setValue:_contractAccount.getId forKey:GXC_KEY_CONTRACT_ID];
    [dic setValue:_methodName forKey:GXC_KEY_METHOD_NAME];
    [dic setValue:_data.hexString forKey:GXC_KEY_DATA];
    return dic;
}

- (void)formJsonDic:(NSDictionary *)dic {
    [super formJsonDic:dic];
    _account = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_ACCOUNT]];
    _amount = [[GXCOptional alloc] initWithField:[[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_AMOUNT]]];
    _contractAccount = [[GXCUserAccount alloc] initWithId:dic[GXC_KEY_CONTRACT_ID]];
    _methodName = dic[GXC_KEY_METHOD_NAME];
    _data = [dic[GXC_KEY_DATA] hexToData];
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendData:self.fee.toByte];
    [data appendData:self.account.toByte];
    [data appendData:self.contractAccount.toByte];
    [data appendData:self.amount.toByte];
    [data appendData:[EOSAccountName getData:_methodName]];
    [data appendUVar:_data.length];
    [data appendData:_data];
    [data appendData:self.extensions.toByte];
    return data;
}

@end
