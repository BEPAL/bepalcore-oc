//
//  DeterministicKey.h
//  ectest
//
//  Created by 潘孝钦 on 2018/5/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildNumber.h"

@interface DeterministicKey : NSObject {
    NSData *privateKey;
    NSData *publicKey;
    NSData *chainCode;
}

- (instancetype)initWithXPri:(NSData*)xpri;
- (instancetype)initWithXPub:(NSData*)xpub;
- (instancetype)initWithPri:(NSData*)pri Pub:(NSData*)pub Code:(NSData*)code;
- (instancetype)initWithSeed:(NSData*)seed;
- (instancetype)initWithStandardKey:(NSData*)key XPrvHead:(uint32_t)xprvhead;
- (NSString*)toXPriv:(int)prefix;
- (NSString*)toXPub:(int)prefix;
- (NSData*)toXPrivive:(int)prefix;
- (NSData*)toXPublic:(int)prefix;
- (NSData*)toXPrivive;
- (NSData*)toXPublic;
- (NSData*)toStandardXPrivate:(int)prefix;
- (NSData*)toStandardXPublic:(int)prefix;
- (NSString*)toStandardXPrv:(int)prefix;
- (NSString*)toStandardXPub:(int)prefix;
- (Boolean)hasPrivateKey;
- (DeterministicKey*)derive:(NSArray*)childNumbers;
- (DeterministicKey*)privChild:(ChildNumber*)childNumber;
- (DeterministicKey*)pubChild:(ChildNumber*)childNumber;
- (id)toECKey;
- (NSArray*)getKeyLength;

@end
