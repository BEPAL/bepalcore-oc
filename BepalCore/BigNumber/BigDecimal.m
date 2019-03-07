//
//  BigDecimal.m
//  BigInteger
//
//  Created by Midfar Sun on 5/4/15.
//  Copyright (c) 2015 Midfar Sun. All rights reserved.
//

#import "BigDecimal.h"

@implementation BigDecimal
@synthesize bigInteger, figure;

- (id)init
{
    return [self initWithString:@"0"];
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        figure = 0;
        if ([string containsString:@"."]) {
            NSRange range = [string rangeOfString:@"."];
            figure = string.length-range.location-range.length;
            string = [string stringByReplacingCharactersInRange:range withString:@""];
        }
        bigInteger = [[BigInteger alloc] initWithString:string];
    }
    return self;
}

+ (id)decimalWithString:(NSString *)string
{
    return [[BigDecimal alloc] initWithString:string];
}

- (id)initWithBigInt:(BigInteger *)bigint {
    return [self initWithBigInteger:bigint figure:0];
}

-(id)initWithBigInteger:(BigInteger *)i figure:(NSInteger)f
{
    self = [super init];
    if (self) {
        bigInteger = i;
        figure = f;
    }
    return self;
}

- (id)initWithDouble:(double)value {
    NSDecimalNumber *resDecimal = [[NSDecimalNumber alloc] initWithDouble:value];
    return [self initWithString:resDecimal.description];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        bigInteger = [[BigInteger alloc] initWithCoder:decoder];
        figure = [decoder decodeInt32ForKey:@"BigDecimalFigure"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [bigInteger encodeWithCoder:encoder];
    [encoder encodeInteger:figure forKey:@"BigDecimalFigure"];
}

- (id)add:(BigDecimal *)bigDecimal
{
    NSInteger maxFigure = 0;
    if (figure>=bigDecimal.figure) {
        maxFigure = figure;
        NSInteger exponent = maxFigure-bigDecimal.figure;
        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
        bigDecimal.bigInteger = [bigDecimal.bigInteger multiply:newInteger];
        bigDecimal.figure = maxFigure;
        
    }else{
        maxFigure = bigDecimal.figure;
        NSInteger exponent = maxFigure-figure;
        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
        bigInteger = [bigInteger multiply:newInteger];
        figure = maxFigure;
        
    }
    BigInteger *newBigInteger = [bigInteger add:bigDecimal.bigInteger];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:maxFigure];
    return newBigDecimal;
}

- (id)subtract:(BigDecimal *)bigDecimal
{
    NSInteger maxFigure = 0;
    if (figure>=bigDecimal.figure) {
        maxFigure = figure;
        NSInteger exponent = maxFigure-bigDecimal.figure;
        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
        bigDecimal.bigInteger = [bigDecimal.bigInteger multiply:newInteger];
        bigDecimal.figure = maxFigure;
    } else{
        maxFigure = bigDecimal.figure;
        NSInteger exponent = maxFigure-figure;
        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
        bigInteger = [bigInteger multiply:newInteger];
        figure = maxFigure;
    }
    BigInteger *newBigInteger = [bigInteger subtract:bigDecimal.bigInteger];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:maxFigure];
    return newBigDecimal;
}

- (id)multiply:(BigDecimal *)bigDecimal
{
    NSInteger totalFigure = figure+bigDecimal.figure;
    BigInteger *newBigInteger = [bigInteger multiply:bigDecimal.bigInteger];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:totalFigure];
    return newBigDecimal;
}

- (id)divide:(BigDecimal *)bigDecimal
{
//    NSInteger totalFigure = figure-bigDecimal.figure;
//    if (totalFigure<0) {
//        NSInteger exponent = -totalFigure;
//        totalFigure=0;
//        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
//        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
//        bigInteger = [bigInteger multiply:newInteger];
//    }
//    BigInteger *newBigInteger = [bigInteger divide:bigDecimal.bigInteger];
//    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:totalFigure];
//    return newBigDecimal;
    NSDecimalNumber *resDecimal = [self.decimalNumber decimalNumberByDividingBy:bigDecimal.decimalNumber];
    return [[BigDecimal alloc] initWithString:resDecimal.description];
}

- (id)remainder:(BigDecimal *)bigDecimal
{
    NSInteger totalFigure = figure-bigDecimal.figure;
    if (totalFigure<0) {
        NSInteger exponent = -totalFigure;
        totalFigure=0;
        BigInteger *mInteger = [[BigInteger alloc] initWithString:@"10"];
        BigInteger *newInteger = [mInteger pow:(unsigned int)exponent];
        bigInteger = [bigInteger multiply:newInteger];
    }
    BigInteger *newBigInteger = [bigInteger remainder:bigDecimal.bigInteger];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:bigDecimal.figure];
    return newBigDecimal;
}

//- (NSArray *)divideAndRemainder:(BigDecimal *)bigInteger
//{
//    
//}

-(NSComparisonResult) compare:(BigDecimal *)other {
    BigDecimal *tens = [[BigDecimal alloc] initWithString:@"10"];
    BigInteger *scaledNum;
    BigInteger *scaledCompareTo;
    
    if (figure > other.figure){
        tens = [tens pow:(int)figure];
    } else {
        tens = [tens pow:(int)other.figure];
    }
    //scale my value to integer value
    scaledNum = [[BigInteger alloc] initWithString:[[self multiply:tens] stringValue]];
    //scale other value to integer
    scaledCompareTo = [[BigInteger alloc] initWithString:[[other multiply:tens] stringValue]];
    NSComparisonResult compareBigInteger = [scaledNum compare:scaledCompareTo];
    return compareBigInteger;
}

- (id)pow:(unsigned int)exponent
{
    NSInteger totalFigure = figure*exponent;
    BigInteger *newBigInteger = [bigInteger pow:exponent];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:totalFigure];
    return newBigDecimal;
}

- (id)negate
{
    BigInteger *newBigInteger = [bigInteger negate];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:figure];
    return newBigDecimal;
}

- (id)abs
{
    BigInteger *newBigInteger = [bigInteger abs];
    BigDecimal *newBigDecimal = [[BigDecimal alloc] initWithBigInteger:newBigInteger figure:figure];
    return newBigDecimal;
}

- (NSString *)stringValue
{
    NSString *string = [bigInteger stringValue];
    if (figure == 0) {
        return string;
    }
    NSMutableString *mString = [NSMutableString stringWithString:string];
    NSInteger newFigure = string.length-figure;
    while (newFigure<=0) {
        [mString insertString:@"0" atIndex:0];
        newFigure++;
    }
    [mString insertString:@"." atIndex:newFigure];
    return mString;
}

- (NSString *)description
{
    return [self stringValue];
}

- (double)toDouble {
    return [self.stringValue doubleValue];
}

- (BigInteger*)toBigInt {
    NSString *string = [bigInteger stringValue];
    if (figure == 0) {
        return [bigInteger copy];
    }
    NSInteger newFigure = string.length-figure;
    if (newFigure < 0) {
        return [[BigInteger alloc] initWithUnsignedLongLong:0];
    }
    return [[BigInteger alloc] initWithString:[string substringWithRange:NSMakeRange(0, newFigure)]];
}

- (NSDecimalNumber*)decimalNumber {
    return [[NSDecimalNumber alloc] initWithString:self.stringValue];
}

@end
