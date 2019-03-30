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

#import "GXCAssetAmount.h"
#import "Categories.h"

@implementation GXCAssetAmount

- (instancetype)initWithJson:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        [self fromJson:dic];
    }
    return self;
}

- (instancetype)initWithAmount:(uint64_t)amount Asset:(NSString*)assetId
{
    self = [super init];
    if (self) {
        _amount = amount;
        _asset = [[GXCAsset alloc] initWithId:assetId];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt64:_amount];
    [data appendUVar:_asset.instance];
    return data;
}

- (id)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(_amount) forKey:GXC_KEY_AMOUNT];
    [dic setValue:_asset.getId forKey:GXC_KEY_ASSET_ID];
    return dic;
}

- (void)fromJson:(NSDictionary*)dic {
    _amount = [dic[GXC_KEY_AMOUNT] longLongValue];
    _asset = [[GXCAsset alloc] initWithId:dic[GXC_KEY_ASSET_ID]];
}

@end
