//
//  BigDecimal.h
//  BigInteger
//
//  Created by Midfar Sun on 5/4/15.
//  Copyright (c) 2015 Midfar Sun. All rights reserved.
//

#import "BigInteger.h"

@interface BigDecimal : NSObject <NSCoding>

@property(nonatomic, retain)BigInteger *bigInteger;
@property(nonatomic, assign)NSUInteger figure;//小数位数

+ (id)decimalWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (id)initWithBigInt:(BigInteger *)bigint;
- (id)initWithDouble:(double)value;

- (id)add:(BigDecimal *)bigDecimal;
- (id)subtract:(BigDecimal *)bigDecimal;
- (id)multiply:(BigDecimal *)bigDecimal;
- (id)divide:(BigDecimal *)bigDecimal;

- (id)remainder:(BigDecimal *)bigInteger;
//- (NSArray *)divideAndRemainder:(BigDecimal *)bigInteger;

- (NSComparisonResult) compare:(BigDecimal *)other;
- (id)pow:(unsigned int)exponent;

- (id)negate;
- (id)abs;

- (NSString *)stringValue;
- (NSString *)description;
- (double)toDouble;
- (BigInteger*)toBigInt;
- (NSDecimalNumber*)decimalNumber;

@end
