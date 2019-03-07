//
//  EosDeterministicKey.m
//  ectest
//
//  Created by 潘孝钦 on 2018/5/9.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EosDeterministicKey.h"
#import "EosECKey.h"

@implementation EosDeterministicKey

- (id)toECKey {
    return [[EosECKey alloc] initWithKey:privateKey Pub:publicKey];
}

@end
