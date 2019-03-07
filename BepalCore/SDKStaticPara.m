//
//  SDKStaticPara.m
//  BepalSdk
//
//  Created by Hyq on 2018/7/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "SDKStaticPara.h"

@interface SDKStaticPara () {
    NSString *synchronizedDeterministicKey;
}

@end

@implementation SDKStaticPara

+ (SDKStaticPara*)getOrCreate {
    static SDKStaticPara *sdkStaticPara = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sdkStaticPara == nil) {
            sdkStaticPara = [[SDKStaticPara alloc] init];
        }
    });
    return sdkStaticPara;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        synchronizedDeterministicKey = @"";
    }
    return self;
}

- (id)getSynchronizedDeterministicKey {
    return synchronizedDeterministicKey;
}

@end
