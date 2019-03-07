//
//  EOSByteMessageData.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSByteMessageData.h"

@implementation EOSByteMessageData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSData*)toByte {
    return _data;
}

- (void)parse:(NSData *)data {
    _data = data;
}

@end
