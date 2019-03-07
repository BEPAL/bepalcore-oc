//
//  ChildNumber.m
//  ectest
//
//  Created by 潘孝钦 on 2018/5/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ChildNumber.h"

@implementation ChildNumber

- (instancetype)initWithPath:(uint32_t)path {
    self = [self initWithPath:path Hardened:false];
    if (self) {

    }
    return self;
}

- (instancetype)initWithPath:(uint32_t)path Hardened:(BOOL)isHardened {
    self = [super init];
    if (self) {
        intPath = path;
        _hardened = isHardened;
    }
    return self;
}

- (NSData *)getPath {
    uint32_t temp = intPath;
    if (_hardened) {
        temp += 0x80000000;
    }
    temp = CFSwapInt32HostToBig(temp);
    return [NSData dataWithBytes:&temp length:sizeof(uint32_t)];
}

- (uint32_t)getKeyPath {
    uint32_t temp = intPath;
    if (_hardened) {
        temp += 0x80000000;
    }
    return temp;
}

- (NSData *)getPathNem {
    uint32_t temp = intPath;
    temp = CFSwapInt32HostToLittle(temp);
    return [NSData dataWithBytes:&temp length:sizeof(uint32_t)];
}

- (NSData *)getPathBtm {
    uint64_t temp = intPath;
    temp = CFSwapInt64HostToLittle(temp);
    return [NSData dataWithBytes:&temp length:sizeof(uint64_t)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d%@", intPath, _hardened ? @"H" : @""];
}

@end
