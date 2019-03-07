//
//  EOSAsset.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

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
