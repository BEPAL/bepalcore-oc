//
//  EOSAccountPermissionWeight.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAccountPermissionWeight.h"

@implementation EOSAccountPermissionWeight

- (instancetype)init
{
    self = [super init];
    if (self) {
        _weight = 1;
    }
    return self;
}

- (instancetype)init:(NSString*)account :(NSString*)permission
{
    self = [self init];
    if (self) {
        _permission = [[EOSAccountPermission alloc] initWithString:account Permission:permission];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_permission.toByte];
    [stream appendUInt16:_weight];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _permission = [EOSAccountPermission new];
    [_permission parse:data :index];
    _weight = [data UInt16AtOffset:*index];
    *index = *index + 2;
}

@end
