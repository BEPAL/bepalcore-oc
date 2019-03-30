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

#import "EOSAsset.h"
#import "NSMutableData+Extend.h"
#import "NSData+Extend.h"

@implementation EOSAsset

- (instancetype)initWithString:(NSString*)value
{
    self = [super init];
    if (self) {
        NSArray *arr = [value componentsSeparatedByString:@" "];
        NSUInteger index = [arr[0] rangeOfString:@"."].location;
        _decimal = (uint32_t)([arr[0] length]- index - 1);
        _amount = (uint64_t)([arr[0] doubleValue] * pow(10,_decimal));
        _unit = arr[1];
    }
    return self;
}

- (instancetype)initWithAmount:(uint64_t)amount Decimal:(uint32_t)decimal Unit:(NSString*)unit
{
    self = [super init];
    if (self) {
        _amount = amount;
        _decimal = decimal;
        _unit = unit;
    }
    return self;
}

- (void)toByte:(NSMutableData*)stream {
    [stream appendUInt64:_amount];
    [stream appendUInt8:_decimal];
    [stream appendData:[self getStringToData:_unit]];
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _amount = [data UInt64AtOffset:*index];
    *index = *index + 8;
    _decimal = [data UInt8AtOffset:*index];
    *index = *index + 1;
    _unit = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(*index, 7)] encoding:NSUTF8StringEncoding];
    _unit = [_unit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    *index = *index + 7;
}

- (NSData*)getStringToData:(NSString*) str {
    NSMutableData *stream = [NSMutableData new];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [stream appendData:data];
    for (int i = data.length; i < 7; i++) {
        [stream appendUInt8:0];
    }
    return stream;
}

- (NSString*)description {
    double value = _amount / pow(10, _decimal);
    return [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%d%%lf %%@",_decimal],value,_unit];
}

+ (EOSAsset*)toAsset:(NSData*)data :(NSUInteger*)index {
    EOSAsset *asset = [EOSAsset new];
    [asset parse:data :index];
    return asset;
}

- (double)getValue {
    return _amount / pow(10, _decimal);
}

@end
