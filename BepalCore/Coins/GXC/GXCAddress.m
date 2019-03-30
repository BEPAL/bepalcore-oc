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

#import "GXCAddress.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"

@implementation GXCAddress

- (instancetype)initWithKey:(GXCECKey*)key
{
    self = [super init];
    if (self) {
        ecKey = key;
    }
    return self;
}

- (instancetype)initWithString:(NSString*)pubKey
{
    self = [super init];
    if (self) {
        ecKey = [[GXCECKey alloc] initWithPubKey:[GXCAddress toPubKey:pubKey]];
    }
    return self;
}

- (NSString *)description
{
    return [GXCAddress toAddress:ecKey.publicKeyAsData];
}

- (GXCECKey*)getKey {
    return ecKey;
}

+ (NSData*)toPubKey:(NSString*)base58Data {
    NSString *naddr = [base58Data substringWithRange:NSMakeRange(3, base58Data.length - 3)];
    NSData* daddr = naddr.base58ToData;
    return [daddr subdataWithRange:NSMakeRange(0, daddr.length - 4)];
}

+ (NSString*)toAddress:(NSData*)pubKey {    
    NSString *EOS_PREFIX = @"GXC";
    NSMutableData *pub = [NSMutableData new];
    [pub appendData:pubKey];
    [pub appendData:[pubKey.RMD160 subdataWithRange:NSMakeRange(0, 4)]];
    NSMutableString *address = [NSMutableString new];
    [address appendString:EOS_PREFIX];
    [address appendString:[NSString base58WithData:pub]];

    return address;
}

@end
