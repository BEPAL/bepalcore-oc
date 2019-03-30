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

#import "GXCBaseOperation.h"
#import "Categories.h"
#import "GXCOperationType.h"

@implementation GXCBaseOperation

- (instancetype)initWithType:(uint32_t)type
{
    self = [super init];
    if (self) {
        _opType = type;
        _extensions = [GXCExtensions new];
    }
    return self;
}

- (void)fromJson:(NSDictionary*)dic {
    _fee = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_FEE]];
    _extensions = [[GXCExtensions alloc] initWithArray:dic[GXC_KEY_EXTENSIONS]];
}

- (id)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_fee.toJson forKey:GXC_KEY_FEE];
    [dic setValue:_extensions.toJson forKey:GXC_KEY_EXTENSIONS];
    return dic;
}

- (NSData *)toByte {
    return nil;
}


- (NSMutableArray*)toJsonArray {
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:@(_opType)];
    [arr addObject:self.toJson];
    return arr;
}

- (NSData*)toOpByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt8:_opType];
    [data appendData:self.toByte];
    return data;
}

- (void)formJsonDic:(NSDictionary*)dic {
    _fee = [[GXCAssetAmount alloc] initWithJson:dic[GXC_KEY_FEE]];
    _extensions = [[GXCExtensions alloc] initWithArray:dic[GXC_KEY_EXTENSIONS]];
}

+ (GXCBaseOperation*)formJsonArray:(NSArray*)array {
    GXCBaseOperation *operation = nil;
    @try {
        int type = [array[0] intValue];
        if (type == GXC_OP_TRANSFER_OPERATION) {
//            operation = new TxOperation();
//            operation.fromJson(array.getJSONObject(1));
        } else if (type == GXC_OP_ACCOUNT_CREATE_OPERATION) {
//            operation = new CreateAccountOperation();
//            operation.fromJson(array.getJSONObject(1));
        }
    } @catch (NSException *ex) {
    }
    return operation;
}

@end
