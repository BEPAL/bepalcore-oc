//
//  EOSWaitWeight.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/5/15.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSWaitWeight.h"

@implementation EOSWaitWeight

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendUInt32:_waitSec];
    [stream appendUInt16:_weight];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _waitSec = [data UInt32AtOffset:*index];
    _weight = [data UInt16AtOffset:*index];
}

@end
