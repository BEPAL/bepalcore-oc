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
