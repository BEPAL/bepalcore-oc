//
//  EOSAccountName.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAccountName.h"

@implementation EOSAccountName

- (instancetype)initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        _accountName = name;
        _accountData = [self accountNameToHex:name];
        uint64_t temp = 0;
        [_accountData getBytes:&temp length:sizeof(temp)];
        _accountValue = temp;
    }
    return self;
}

- (instancetype)initWithHex:(NSData*)name
{
    self = [super init];
    if (self) {
        _accountName = [self hexToAccountName: name];
        _accountData = name;
        uint64_t temp = 0;
        [_accountData getBytes:&temp length:sizeof(temp)];
        _accountValue = temp;
    }
    return self;
}

- (NSData*)accountNameToHex:(NSString*)name {
    static const char* charmap = ".12345abcdefghijklmnopqrstuvwxyz";
    uint32_t len = 0;
    const char* str = name.UTF8String;
    while(str[len]) ++len;
    uint64_t value = 0;
    for( uint32_t i = 0; i <= 12; ++i ) {
        uint64_t c = 0;
        if( i < len && i <= 12 ) c = [self charIndexOf:charmap :str[i]];
        if( i < 12 ) {
            c &= 0x1f;
            c <<= 64-5*(i+1);
        }
        else {
            c &= 0x0f;
        }
        value |= c;
    }
    return [[NSData alloc] initWithBytes:&value length:sizeof(value)];
}

- (NSString*)hexToAccountName:(NSData*)hex {
    static const char* charmap = ".12345abcdefghijklmnopqrstuvwxyz";
    char str[13];
    uint64_t tmp;
    [hex getBytes:&tmp length:sizeof(tmp)];
    for( uint32_t i = 0; i <= 12; ++i ) {
        char c = charmap[tmp & (i == 0 ? 0x0f : 0x1f)];
        str[12-i] = c;
        tmp >>= (i == 0 ? 4 : 5);
    }
    int count = 0;
    for (int i = 12; i >= 0; i--) {
        if (str[i] != 46) {
            break;
        }
        count = i;
    }
    NSMutableString *name = [NSMutableString new];
    for (int i = 0; i < count; i++) {
        if (str[i] == 46) {
            break;
        }
        [name appendFormat:@"%c",str[i]];
    }
    return name;
}

- (int)charIndexOf:(const char*)map :(char)data {
    for (int i = 0; i < 32; i++) {
        if (map[i] == data) {
            return i;
        }
    }
    return 0;
}

+ (int)charIndexOfNoZero:(const char*)map :(char)data {
    for (int i = 0; i < 32; i++) {
        if (map[i] == data) {
            return i;
        }
    }
    return -1;
}

+ (NSData*)getData:(NSString*)name {
    return [[EOSAccountName alloc] initWithName:name].accountData;
}

+ (uint64_t)getValue:(NSString*)name {
    return [[EOSAccountName alloc] initWithName:name].accountValue;
}

+ (BOOL)isAccountName:(NSString*)name {
    static const char* charmap = ".12345abcdefghijklmnopqrstuvwxyz";
    const char* str = name.UTF8String;
    for (int i = 0; i < name.length; i++) {
        if ([self charIndexOfNoZero:charmap :str[i]] < 0) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)description
{
    return _accountName;
}

@end
