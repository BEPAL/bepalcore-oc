//
//  EosECKey.h
//  ectest
//
//  Created by 潘孝钦 on 2018/3/20.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ECKey.h"

@interface EosECKey : ECKey {
//    secp256k1_context_t *ctx;
}

- (NSString*)toPubblicKeyString;
- (NSString*)toWif;

@end
