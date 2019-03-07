//
//  GXCECKey.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ECKey.h"

@interface GXCECKey : ECKey {
}
- (instancetype)initWithPubKeyString:(NSString *)pubKey;
- (NSString*)toPubblicKeyString;
- (NSString*)toWif;
+ (NSData*)multiplyPubKey:(NSData*)pubKey PriKey:(NSData*)priKey;

@end
