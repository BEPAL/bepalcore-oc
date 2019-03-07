//
//  GXCAddress.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCECKey.h"

@interface GXCAddress : NSObject {
    GXCECKey *ecKey;
}

- (instancetype)initWithKey:(GXCECKey*)key;
- (instancetype)initWithString:(NSString*)pubKey;
- (GXCECKey*)getKey;
+ (NSString*)toAddress:(NSData*)pubKey;
+ (NSData*)toPubKey:(NSString*)base58Data;

@end
