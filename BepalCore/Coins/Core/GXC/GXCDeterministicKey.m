//
//  GXCDeterministicKey.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCDeterministicKey.h"
#import "GXCECKey.h"

@implementation GXCDeterministicKey

- (id)toECKey {
    return [[GXCECKey alloc] initWithKey:privateKey Pub:publicKey];
}

@end
