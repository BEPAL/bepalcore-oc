//
//  GXCAsset.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCAsset.h"

@implementation GXCAsset

- (instancetype)initWithId:(NSString*)aId
{
    self = [super init];
    if (self) {
        _assetId = aId;
        NSArray *parts = [aId componentsSeparatedByString:@"."];
        if (parts.count == 3) {
            _space = [parts[0] intValue];
            _type = [parts[1] intValue];
            _instance = [parts[2] longLongValue];
        }
    }
    return self;
}

- (NSString*)getId {
    return _assetId;
}

@end
