//
//  EOSClaimrewardsMessageData.m
//  BepalSdk
//
//  Created by Hyq on 2018/7/7.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "EOSClaimrewardsMessageData.h"

@implementation EOSClaimrewardsMessageData

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *stream = [NSMutableData new];
    [stream appendData:_owner.accountData];
    return stream;
}

- (void)parse:(NSData *)data {
    _owner = [[EOSAccountName alloc] initWithHex:[data subdataWithRange:NSMakeRange(0, 8)]];
}

@end
