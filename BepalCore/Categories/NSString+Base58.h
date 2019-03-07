//
//  NSString+Base58.h
//  ectest
//
//  Created by 潘孝钦 on 2018/5/16.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base58)

+ (NSString *)base58WithData:(NSData *)d;
+ (NSString *)base58checkWithData:(NSData *)d;
- (NSData *)base58ToData;
- (NSData *)base58checkToData;
+ (NSString *)hexWithData:(NSData *)d;
- (NSData *)hexToData;
- (NSData *)addressToHash160;

@end
