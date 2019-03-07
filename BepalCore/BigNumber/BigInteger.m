//
//  BigInteger.m
//  BigInteger
//
//  Created by Jānis Kiršteins on 5/21/13.
//  Copyright (c) 2013 Jānis Kiršteins. All rights reserved.
//
#import "BigInteger.h"
#import "Security.h"
#import "BigNumber.h"
#include "tommath.h"
#import "SecureData.h"

@implementation BigInteger {
@private
    mp_int m_value;
}

- (id)initWithValue:(mp_int *)value {

    self = [super init];
	
    if (self) {
        mp_init_copy(&m_value, value);
    }
    
    return self;
}

- (mp_int *)value {
    return &m_value;
}

- (id)initWithUnsignedLongLong:(uint64_t)ul {
    return [self initWithString:@(ul).description];
}

- (id)initWithUnsignedLong:(unsigned long)unsignedLong {

    self = [super init];
    
    if (self) {
        mp_set_int(&m_value, unsignedLong);
    }
    
    return self;
}

- (id)initWithBignum:(BigNumber*)num {
    return [self initWithData:num.toData Signum:1];
}

- (id)init {
    return [self initWithUnsignedLong:0];
}

- (id)initWithCString:(char *)cString andRadix:(int)radix {

    if (radix < 2 || radix > 64) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        mp_init(&m_value);
        int result;
        result = mp_read_radix(&m_value, cString, radix);
        
        if (result != MP_OKAY) {
            mp_clear(&m_value);
            return nil;
        }
    }
    
    return self;
}
- (id)initWithCString:(char *)cString {
    int radix = 10;
    return [self initWithCString:cString andRadix:radix];
}

- (id)initWithString:(NSString *)string andRadix:(int)radix {
    if (string == nil) {
        return [self initWithUnsignedLongLong:0];
    }
    if ([string hasPrefix:@"0x"]) {
        string = [string substringFromIndex:2];
    }
    return [self initWithCString:(char *)[string UTF8String] andRadix:radix];
}

- (id)initWithString:(NSString *)string {
    if (string == nil) {
        return [self initWithUnsignedLongLong:0];
    }
    if ([string hasPrefix:@"0x"]) {
        string = [string substringFromIndex:2];
    }
    int radix = 10;
    return [self initWithCString:(char *)[string UTF8String] andRadix:radix];
}

- (id)initWithData:(NSData*)data Signum:(int)signum {
    if (data == nil) {
        return [self initWithUnsignedLongLong:0];
    }
    NSString *strhex = [Security toHexString:data];
    NSMutableString *str = [NSMutableString new];
    if (signum < 0) {
        [str appendString:@"-"];
    }
    [str appendString:strhex];
    return [self initWithString:str andRadix:16];
}

- (id)initWithSigData:(NSData*)data {
    if (data == nil) {
        return [self initWithUnsignedLong:0];
    }
    Byte *temp = (Byte *)[data bytes];
    int signum = temp[0] == 0 ? 1 : -1;
    return [self initWithData:[data subdataWithRange:NSMakeRange(1, data.length - 1)] Signum:signum];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSData *value = [decoder decodeObjectForKey:@"BigInteger"];
    self = [self initWithSigData:value];
    
    if (self) {
       
        
//        int sign = [decoder decodeInt32ForKey:@"BigIntegerSign"];
//        int alloc = [decoder decodeInt32ForKey:@"BigIntegerAlloc"];
//
//        mp_init_size(&m_value, alloc);
//
//        NSData *data = (NSData *)[decoder decodeObjectForKey:@"BigIntegerDP"];
//        mp_digit *temp = (mp_digit *)[data bytes];
//
//        for (unsigned int i = 0; i < alloc; ++i) {
//            m_value.dp[i] = temp[i];
//        }
//
//        m_value.used = alloc;
//        m_value.sign = sign;
        
        
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
//    mp_clamp(&m_value);
//
//    NSData *data = [NSData dataWithBytes:(const void *)m_value.dp
//                                  length:m_value.alloc * sizeof(mp_digit)];
//
//    [encoder encodeObject:data forKey:@"BigIntegerDP"];
//    [encoder encodeInteger:m_value.alloc forKey:@"BigIntegerAlloc"];
//    [encoder encodeInteger:m_value.sign forKey:@"BigIntegerSign"];
    [encoder encodeObject:self.toSignedData forKey:@"BigInteger"];
}

- (id)add:(BigInteger *)bigInteger {

    mp_int sum;
    mp_init(&sum);
    
    mp_add(&m_value, [bigInteger value], &sum);
    
    id newBigInteger = [[BigInteger alloc] initWithValue:&sum];
    mp_clear(&sum);
    
    return newBigInteger;
}

- (id)subtract:(BigInteger *)bigInteger {

    mp_int difference;
    mp_init(&difference);
    
    mp_sub(&m_value, [bigInteger value], &difference);
    
    id newBigInteger = [[BigInteger alloc] initWithValue:&difference];
    mp_clear(&difference);
    
    return newBigInteger;
}

- (id)multiply:(BigInteger *)bigInteger {

    mp_int product;
    mp_init(&product);
    
    mp_mul(&m_value, [bigInteger value], &product);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&product];
    mp_clear(&product);
    
    return newBigInteger;
}

- (id)divide:(BigInteger *)bigInteger {

    int result;
    mp_int quotient;
    mp_init(&quotient);
    
    result = mp_div(&m_value, [bigInteger value], &quotient, NULL);
    if (result == MP_VAL) {
        mp_clear(&quotient);
        return nil;
    }
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&quotient];
    mp_clear(&quotient);
    
    return newBigInteger;
}

- (id)mod:(BigInteger *)bigInteger {
    BigInteger *result = [[BigInteger alloc] init];
    mp_div(&m_value, [bigInteger value], NULL, [result value]);
    return result;
}

- (id)remainder:(BigInteger *)bigInteger {

    int result;
    mp_int remainder;
    mp_init(&remainder);
    
    result = mp_div(&m_value, [bigInteger value], NULL, &remainder);
    if (result == MP_VAL) {
        mp_clear(&remainder);
        return nil;
    }
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&remainder];
    mp_clear(&remainder);
    
    return newBigInteger;
}

- (NSArray *)divideAndRemainder:(BigInteger *)bigInteger {

    int result;
    mp_int quotient, remainder;
    mp_init_multi(&quotient, &remainder, NULL);
    
    result = mp_div(&m_value, [bigInteger value], &quotient, &remainder);
    if (result == MP_VAL) {
        mp_clear_multi(&quotient, &remainder, NULL);
        return nil;
    }
    
    BigInteger *quotientBigInteger = [[BigInteger alloc] initWithValue:&quotient];
    BigInteger *remainderBigInteger = [[BigInteger alloc] initWithValue:&remainder];
    mp_clear_multi(&quotient, &remainder, NULL);
    
    return @[quotientBigInteger, remainderBigInteger];
}

- (id)pow:(unsigned int)exponent {

    int result;
    mp_int power;
    mp_init(&power);
    
    result = mp_expt_d(&m_value, (mp_digit)exponent, &power);
    if (result == MP_VAL) {
        mp_clear(&power);
        return nil;
    }
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&power];
    mp_clear(&power);
    
    return newBigInteger;
}

- (id)pow:(BigInteger*)exponent andMod: (BigInteger*)modulus {

    int result;
    mp_int output;
    mp_init(&output);
    
    result = mp_exptmod(&m_value, &exponent->m_value, &modulus->m_value, &output);
    if (result == MP_VAL) {
        mp_clear(&output);
        return nil;
    }
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&output];
    mp_clear(&output);
    
    return newBigInteger;
}

- (id)negate {

    mp_int negate;
    mp_init(&negate);
    mp_neg(&m_value, &negate);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&negate];
    mp_clear(&negate);
    
    return newBigInteger;
}

- (id)abs {

    mp_int absolute;
    mp_init(&absolute);
    mp_abs(&m_value, &absolute);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&absolute];
    mp_clear(&absolute);
    
    return newBigInteger;
}

- (id)bitwiseXor:(BigInteger *)bigInteger {

    mp_int xor;
    mp_init(&xor);
    mp_xor(&m_value, [bigInteger value], &xor);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&xor];
    mp_clear(&xor);
    
    return newBigInteger;
}

- (id)bitwiseOr:(BigInteger *)bigInteger {

    mp_int or;
    mp_init(&or);
    mp_or(&m_value, [bigInteger value], &or);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&or];
    mp_clear(&or);
    
    return newBigInteger;
}

- (id)bitwiseAnd:(BigInteger *)bigInteger {

    mp_int and;
    mp_init(&and);
    mp_and(&m_value, [bigInteger value], &and);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&and];
    mp_clear(&and);
    
    return newBigInteger;
}

- (id)shiftLeft:(unsigned int)n {

    mp_int lShift;
    mp_init(&lShift);
	mp_mul_2d(&m_value, n, &lShift);
	
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&lShift];
    mp_clear(&lShift);
    
    return newBigInteger;
}

- (id)shiftRight:(unsigned int)n {

    mp_int rShift;
    mp_init(&rShift);
    mp_div_2d(&m_value, n, &rShift, NULL);
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&rShift];
    mp_clear(&rShift);
    
    return newBigInteger;
}
- (id)gcd:(BigInteger *)bigInteger {

    int result;
    mp_int gcd;
    mp_init(&gcd);
    
    result = mp_gcd(&m_value, [bigInteger value], &gcd);
    if (result == MP_VAL) {
        mp_clear(&gcd);
        return nil;
    }
    
    BigInteger *newBigInteger = [[BigInteger alloc] initWithValue:&gcd];
    mp_clear(&gcd);
    
    return newBigInteger;
}

- (NSComparisonResult) compare:(BigInteger *)bigInteger {

    NSComparisonResult comparisonResult;
    comparisonResult = mp_cmp([bigInteger value], &m_value);
    
    switch (comparisonResult) {
        case MP_GT:
            return NSOrderedAscending;
        case MP_EQ:
            return NSOrderedSame;
        case MP_LT:
            return NSOrderedDescending;
        default:
            return 0;
    }
}

- (unsigned long)unsignedIntValue {
    return mp_get_int(&m_value);
}

- (uint64_t)unsignedInt64Value {
    return [self.stringValue longLongValue];
}

- (NSString *)stringValue {
    int radix = 10;
    return [self stringValueWithRadix:radix];
}

- (NSString *)stringValueWithRadix:(int)radix {
    int stringSize;
    mp_radix_size(&m_value, radix, &stringSize);
    char cString[stringSize];
    mp_toradix(&m_value, cString, radix);
    
    for (int i = 0; i < stringSize; ++i) {
        cString[i] = (char)tolower(cString[i]);
    }
    
    return [NSString stringWithUTF8String:cString];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[BigInteger alloc] initWithValue:&m_value];
}

- (NSString *)description {
    return [self stringValue];
}

- (void)dealloc {
    mp_clear(&m_value);
}

- (NSDecimalNumber*)decimalNumber {
    return [[NSDecimalNumber alloc] initWithString:self.stringValue];
}

- (BigNumber*)toBignum {
    return [[BigNumber alloc] initWithBigInt:self];
}

/* Returns the number of bytes required to store this BigInteger as binary */
- (unsigned int)countBytes {
    return (unsigned int) mp_unsigned_bin_size(&m_value);
}

- (unsigned int)countBits {
    return (unsigned int) mp_count_bits(&m_value);
}

/* Retrieves the signed [big endian] format of this BigInteger */
- (void)toByteArraySigned: (unsigned char*) byteArray {
    mp_to_signed_bin(&m_value, byteArray);
}

/* Retrieves the unsigned [big endian] format of this BigInteger */
- (void)toByteArrayUnsigned: (unsigned char*) byteArray {
    mp_to_unsigned_bin(&m_value, byteArray);
}

- (NSData*)toSignedData {
    unsigned int value = [self countBytes];
    unsigned int numBytesInt = value + 1;
    unsigned char bytes[numBytesInt];
    [self toByteArraySigned:bytes];
    return [[NSData alloc] initWithBytes:&bytes length:numBytesInt];
}

- (NSData*)toUnSignedData {
    unsigned int value = [self countBytes];
    unsigned int numBytesInt = value;
    unsigned char bytes[numBytesInt];
    [self toByteArrayUnsigned:bytes];
    return [[NSData alloc] initWithBytes:&bytes length:numBytesInt];
}

- (NSString*)hexString {
    NSData *data = [self toUnSignedData];
    if (self.signum == -1) {
        return [@"-0x" stringByAppendingString:[Security toHexString:data]];
    }
    return [@"0x" stringByAppendingString:[Security toHexString:data]];
}

- (int)signum {
    int value = m_value.sign == MP_ZPOS ? 1 : -1;
    value = [self isZero] ? 0 : value;
    return value;
}

- (BOOL)isZero {
    return (mp_cmp([[[BigInteger alloc] initWithUnsignedLong:0] value], &m_value) == MP_EQ);
}

+ (BigInteger*)constantZero {
    return [[BigInteger alloc] initWithUnsignedLong:0];
}

// @TODO: there are certainly better ways to do this
- (NSUInteger)unsignedIntegerValue {
    int radixSize;
    mp_radix_size(&m_value, 16, &radixSize);
    
    char hexString[radixSize];
    mp_toradix(&m_value, hexString, 16);
    
    NSUInteger result = 0;
    
    // Skip null-termination
    for (int i = 0; i < radixSize - 1; i++) {
        result <<= 4;
        unsigned char c = hexString[i];
        if (c <= '9') {
            result += (c - '0');
        } else if (c <= 'F') {
            result += 10 + (c - 'A');
        } else if (c <= 'f') {
            result += 10 + (c - 'a');
        }
    }
    
    return result;
}

- (BOOL)isNegative {
    return (m_value.sign == MP_NEG);
}

- (NSInteger)integerValue {
    NSInteger multiplier = 1;
    BigInteger *value = self;
    if (self.isNegative) {
        multiplier = -1;
        BigInteger *constantNegativeOne = [[BigInteger alloc] initWithString:@"-1"];
        value = [value multiply:constantNegativeOne];
    }
    return multiplier * [value unsignedIntegerValue];
}

- (uint8_t)byteValue {
    return (uint8_t)self.integerValue;
}

- (BOOL)isSafeUnsignedIntegerValue {
    BigInteger *ConstantMaxSafeUnsignedInteger = [[BigInteger alloc] initWithString:@"ffffffffffffffff" andRadix:16];
    return (mp_cmp(&m_value, [ConstantMaxSafeUnsignedInteger value]) == MP_LT && ![self isNegative]);
}

- (BOOL)isSafeIntegerValue {
    BigInteger *ConstantMaxSafeSignedInteger = [[BigInteger alloc] initWithString:@"7fffffffffffffff" andRadix:16];
    return mp_cmp(&m_value, [ConstantMaxSafeSignedInteger value]) == MP_LT;
}

@end
