//
//  ECKey.h
//  ectest
//
//  Created by 潘孝钦 on 2018/3/20.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSign.h"

@interface ECKey : NSObject  {
    NSData *privateKey;
    NSData *publicKey;
}

- (instancetype)initWithPriKey:(NSData*)priKey;
- (instancetype)initWithPubKey:(NSData*)pubKey;
- (instancetype)initWithKey:(NSData*)priKey Pub:(NSData*)pubKey;
- (ECSign*)sign:(NSData*)mess;
- (Boolean)verify:(NSData*)mess :(ECSign*)sig;
- (NSData*)privateKeyAsData;
- (NSData*)publicKeyAsData;
- (NSString*)privateKeyAsHex;
- (NSString*)publicKeyAsHex;
- (NSString*)signAsHex:(NSData*)mess;
- (NSArray*)getKeyLength;

@end
