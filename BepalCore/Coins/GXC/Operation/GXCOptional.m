//
//  GXCOptional.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2019/2/19.
//  Copyright © 2019 潘孝钦. All rights reserved.
//

#import "GXCOptional.h"
#import "Categories.h"

@interface GXCOptional() {
    id optionalField;
}
@end

@implementation GXCOptional

- (instancetype)init
{
    self = [super init];
    if (self) {
        optionalField = nil;
    }
    return self;
}

- (instancetype)initWithField:(id)field
{
    self = [super init];
    if (self) {
        optionalField = field;
    }
    return self;
}

- (NSData *)toByte {
    NSMutableData *data = [NSMutableData new];
    if (optionalField == nil) {
        [data appendUInt8:0];
    } else {
        [data appendUInt8:1];
        [data appendData:[optionalField toByte]];
    }
    return data;
}

- (Boolean)isSet {
    return optionalField != nil;
}

- (id)toJson {
    return [optionalField toJson];
}

@end
