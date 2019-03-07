//
//  BigInteger.h
//  BigInteger
//
//  Created by Jānis Kiršteins on 5/21/13.
//  Copyright (c) 2013 Jānis Kiršteins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigInteger : NSObject <NSCoding>

/**
 数字转大数
 */
- (id)initWithUnsignedLongLong:(uint64_t)ul;
//32位
//- (id)initWithUnsignedLong:(unsigned long)ul;

/**
 文本转化为大数

 @param string 文本内容为10进制
 */
- (id)initWithString:(NSString *)string;

/**
  文本转化为大数

 @param string 文本内容
 @param radix 进制数
 */
- (id)initWithString:(NSString *)string andRadix:(int)radix;
//- (id)initWithCString:(char *)cString;
//- (id)initWithCString:(char *)cString andRadix:(int)radix;
/**
 NSData转大数

 @param data 内容
 @param signum 1 为正数 -1 为负数
 */
- (id)initWithData:(NSData*)data Signum:(int)signum;
/**
  NSData转大数

 @param data 内容 获取第一个字节为符号
 */
- (id)initWithSigData:(NSData*)data;

- (id)add:(BigInteger *)bigInteger;
- (id)subtract:(BigInteger *)bigInteger;
- (id)multiply:(BigInteger *)bigInteger;
- (id)divide:(BigInteger *)bigInteger;
- (id)mod:(BigInteger *)bigInteger;

- (id)remainder:(BigInteger *)bigInteger;
- (NSArray *)divideAndRemainder:(BigInteger *)bigInteger;

- (id)pow:(unsigned int)exponent;
- (id)pow:(BigInteger*)exponent andMod:(BigInteger*)modulus;
- (id)negate;
- (id)abs;

- (id)bitwiseXor:(BigInteger *)bigInteger;
- (id)bitwiseOr:(BigInteger *)bigInteger;
- (id)bitwiseAnd:(BigInteger *)bigInteger;
- (id)shiftLeft:(unsigned int)n;
- (id)shiftRight:(unsigned int)n;

- (id)gcd:(BigInteger *)bigInteger;

- (NSComparisonResult) compare:(BigInteger *)bigInteger;

- (unsigned long)unsignedIntValue;
- (uint64_t)unsignedInt64Value;
- (NSString *)stringValue;
- (NSString *)stringValueWithRadix:(int)radix;

- (NSString *)description;

//- (BigNumber*)toBignum;
- (unsigned int)countBytes;
- (unsigned int)countBits;
- (void)toByteArraySigned: (unsigned char*) byteArray;
- (void)toByteArrayUnsigned: (unsigned char*) byteArray;
- (NSData*)toSignedData;
- (NSData*)toUnSignedData;
- (int)signum;
- (BOOL)isZero;

+ (BigInteger*)constantZero;
- (NSDecimalNumber*)decimalNumber;

- (NSString*)hexString;
- (NSUInteger)unsignedIntegerValue;
- (NSInteger)integerValue;
- (uint8_t)byteValue;
- (BOOL)isSafeUnsignedIntegerValue;
- (BOOL)isSafeIntegerValue;

@end
