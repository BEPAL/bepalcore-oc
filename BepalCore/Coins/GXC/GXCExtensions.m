//
//  GXCExtensions.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCExtensions.h"
#import "Categories.h"

@implementation GXCExtensions

- (instancetype)init
{
    self = [super init];
    if (self) {
        extensions = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray*)arr
{
    self = [super init];
    if (self) {
        [self fromJson:arr];
    }
    return self;
}

- (id)toJson {
    return extensions;
}

- (void)fromJson:(NSArray*)arr {
    extensions = [arr mutableCopy];
}

- (NSData*)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt8:0];
    return data;
}

- (NSUInteger)size {
    return extensions.count;
}

@end
