//
//  BitECKey.h
//  ectest
//
//  Created by 潘孝钦 on 2018/3/20.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "ECKey.h"

@interface BitECKey : ECKey {
}

+ (NSData*)recoverPublicKey:(NSData*)mess Sign:(ECSign*)sig;
+ (NSData*)prvKeyToPubKey:(NSData*)prvKey;
+ (NSData*)recoverPublicKey:(uint8_t)recid Hash:(NSData*)hashdata Sign:(ECSign*)sig;
- (NSString*)getPrivateKeyAsWiF:(int)version;

@end
