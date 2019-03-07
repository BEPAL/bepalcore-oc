/**
 *  MIT License
 *
 *  Copyright (c) 2017 Richard Moore <me@ricmoo.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the
 *  "Software"), to deal in the Software without restriction, including
 *  without limitation the rights to use, copy, modify, merge, publish,
 *  distribute, sublicense, and/or sell copies of the Software, and to
 *  permit persons to whom the Software is furnished to do so, subject to
 *  the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */


#import "SecureData.h"
#import "Categories.h"
#import <CommonCrypto/CommonCrypto.h>
#include "sha3.h"
#import "RegEx.h"

#pragma mark - SecureData

@interface SecureData () {
    
}

@property (nonatomic, strong) NSMutableData *secureData;

@end


@implementation SecureData {
    
}

#pragma mark - Life Cycle

static RegEx *RegExHex = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RegExHex = [RegEx regExWithPattern:@"^0x([0-9A-Fa-f][0-9A-Fa-f])*$"];
    });
}

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity: (NSUInteger)capacity {
    self = [super init];
    if (self) {
        _secureData = CFBridgingRelease(CFDataCreateMutable(SecureAllocator(), capacity));
    }
    return self;
}

- (instancetype)initWithData: (NSData*)data {
    self = [super init];
    if (self) {
        _secureData = CFBridgingRelease(CFDataCreateMutableCopy(SecureAllocator(), 0, (__bridge CFDataRef)data));
    }
    return self;
}


+ (instancetype)secureData {
    return [self secureDataWithCapacity:0];
}

+ (instancetype)secureDataWithLength:(NSUInteger)length {
    SecureData *secureData = [self secureDataWithCapacity:length];
    secureData.secureData.length = length;
    return secureData;
}

+ (instancetype)secureDataWithCapacity:(NSUInteger)capacity {
    return [[self alloc] initWithCapacity:capacity];
}

+ (instancetype)secureDataWithHexString:(NSString*)hexString {
    
    // Make sure we are a valid hex string
    if (![RegExHex matchesExactly:hexString]) { return nil; }
    
    SecureData *secureData = [SecureData secureDataWithCapacity:hexString.length / 2 - 1];

    uint8_t b = 0;
    unichar c;
    
    for (NSUInteger i = 2; i < hexString.length; i++) {
        c = [hexString characterAtIndex:i];
        
        switch (c) {
            case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
                b += c - '0';
                break;
                
            case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
                b += c + 10 - 'A';
                break;
                
            case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
                b += c + 10 - 'a';
                break;
                
            default:
                // Cannot happen as we passed the above regular expression
                NSLog(@"This should not happen!");
                return nil;
        }
        
        if (i % 2) {
            [secureData.secureData appendBytes:&b length:1];
            b = 0;
        } else {
            b <<= 4;
        }
    }

    b = 0;
    CC_XZEROMEM(&c, sizeof(c));

    return secureData;
}

+ (instancetype)secureDataWithData:(NSData*)data {
    return [[self alloc] initWithData:data];
}


#pragma mark - Convenience Functions

+ (NSData*)hexStringToData: (NSString*)hexString {
    if (![hexString hasPrefix:@"0x"]) {
        if (hexString.length % 2 == 1) {
            hexString = [@"0x0" stringByAppendingString:hexString];
        } else {
            hexString = [@"0x" stringByAppendingString:hexString];
        }
    }
    return [SecureData secureDataWithHexString:hexString].data;
}

+ (NSString*)dataToHexString: (NSData*)data {
    return [[SecureData secureDataWithData:data] hexString];
}

+ (NSData*)SHA256: (NSData*)data {
    return [[SecureData secureDataWithData:data] SHA256].data;
}

+ (NSData*)KECCAK256: (NSData*)data {
    return [[SecureData secureDataWithData:data] KECCAK256].data;
}


#pragma mark - Access Operations

- (NSUInteger)length {
    return _secureData.length;
}

- (const void*)bytes {
    return _secureData.bytes;
}

- (void*)mutableBytes {
    return _secureData.mutableBytes;
}


#pragma mark - Mutable Operations

- (void)append:(SecureData *)secureData {
    [_secureData appendData:secureData.secureData];
}

- (void)appendByte:(unsigned char)byte {
    [_secureData appendBytes:&byte length:1];
}

- (void)appendData:(NSData *)data {
    [_secureData appendData:data];
}

#pragma mark - Slicing

- (SecureData*)subdataWithRange: (NSRange)range {
    return [SecureData secureDataWithData:[_secureData subdataWithRange:range]];
}

- (SecureData*)subdataFromIndex: (NSUInteger)fromIndex {
    return [self subdataWithRange:NSMakeRange(fromIndex, self.length - fromIndex)];
    
}

- (SecureData*)subdataToIndex: (NSUInteger)toIndex {
    return [self subdataWithRange:NSMakeRange(0, toIndex)];
}

#pragma mark - Crypto Operations

- (SecureData*)SHA1 {
    SecureData *secureData = [SecureData secureDataWithLength:CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, secureData.mutableBytes);
    return secureData;
}

- (SecureData*)SHA256 {
    SecureData *secureData = [SecureData secureDataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, secureData.mutableBytes);
    return secureData;
}

- (SecureData*)KECCAK256 {
    SecureData *secureData = [SecureData secureDataWithLength:(256 / 8)];
    
    SHA3_CTX context;
    keccak_256_Init(&context);
    keccak_Update(&context, self.bytes, (size_t)self.length);
    keccak_Final(&context, secureData.mutableBytes);
    
    CC_XZEROMEM(&context, sizeof(SHA3_CTX));
    
    return secureData;
}

#pragma mark -

- (NSString*)hexString {
    const uint8_t *bytes = self.bytes;
    
    NSMutableString *hex = CFBridgingRelease(CFStringCreateMutable(SecureAllocator(), self.length * 2 + 2));
    [hex appendString:@"0x"];
    
    for (NSUInteger i = 0; i < self.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    
    return hex;
}

- (NSData*)data {
    return CFBridgingRelease(CFDataCreateCopy(SecureAllocator(), (__bridge CFDataRef)_secureData));
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [SecureData secureDataWithData:_secureData];
}


#pragma mark - NSObject

- (NSUInteger)hash {
    return [[self KECCAK256] hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SecureData class]]) {
        return [_secureData isEqualToData:((SecureData*)object).secureData];
    } else if ([object isKindOfClass:[NSData class]]) {
        return [_secureData isEqualToData:(NSData*)object];
    }
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<SecureMutableData data=%@>", [self hexString]];
}

@end
