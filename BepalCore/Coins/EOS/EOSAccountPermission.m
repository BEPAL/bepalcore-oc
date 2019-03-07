//
//  EOSAccountPermission.m
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSAccountPermission.h"

@implementation EOSAccountPermission

- (instancetype)initWithString:(NSString*)account Permission:(NSString*)permission
{
    self = [super init];
    if (self) {
        _account = [[EOSAccountName alloc] initWithName:account];
        _permission = [[EOSAccountName alloc] initWithName:permission];
    }
    return self;
}

- (instancetype)initWithData:(NSData*)account Permission:(NSString*)permission
{
    self = [super init];
    if (self) {
        _account = [[EOSAccountName alloc] initWithHex:account];
        _permission = [[EOSAccountName alloc] initWithName:permission];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_account.accountData];
    [stream appendData:_permission.accountData];
    return stream;
}

- (void)parse:(NSData*)data :(NSUInteger*)index {
    _account = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(*index, 8)]];
    *index = *index + 8;
    _permission = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(*index, 8)]];
    *index = *index + 8;
}

- (NSDictionary*)toJson {
    NSMutableDictionary *jsaccper = [NSMutableDictionary new];
    jsaccper[@"account"] = _account.accountName;
    jsaccper[@"permission"] = _permission.accountName;
    return jsaccper;
}

@end
