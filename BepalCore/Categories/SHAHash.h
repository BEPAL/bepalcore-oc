//
//  Hasher.h
//  ectest
//
//  Created by 潘孝钦 on 2018/5/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHAHash : NSObject

+ (NSData*)hmac512:(NSData *)key Data:(NSData*)data;
+ (NSData*)sha1:(NSData*)data;
+ (NSData*)ripemd160:(NSData*)data;
+ (NSData*)keccak256:(NSData*)data;
+ (NSData*)keccak512:(NSData*)data;
+ (NSData*)sha3512:(NSData*)data;
+ (NSData*)sha3256:(NSData*)data;
+ (NSData*)sha2512:(NSData*)data;
+ (NSData*)sha2256:(NSData*)data;
+ (NSData*)md5:(NSData*)data;

@end
