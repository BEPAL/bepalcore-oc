//
//  UserAccount.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCUserAccount.h"
#import "Categories.h"

@implementation GXCUserAccount

+ (NSString*)PROXY_TO_SELF {
    return @"1.2.5";
}

- (instancetype)initWithId:(NSString*)aId
{
    self = [super init];
    if (self) {
        accountId = aId;
        NSArray *parts = [aId componentsSeparatedByString:@"."];
        if (parts.count == 3) {
            space = [parts[0] intValue];
            type = [parts[1] intValue];
            instance = [parts[2] longLongValue];
        }
    }
    return self;
}

- (NSString*)getId {
    return accountId;
}

- (NSData*)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUVar:instance];
    return data;
}

- (NSString*)getObjectId {
    return [NSString stringWithFormat:@"%d.%d.%llu",space,type,instance];
}

- (NSString *)description
{
    return [self getId];
}

@end
