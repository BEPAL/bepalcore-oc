//
//  GXCAssetAmount.m
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import "GXCAssetAmount.h"
#import "Categories.h"

@implementation GXCAssetAmount

- (instancetype)initWithJson:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        [self fromJson:dic];
    }
    return self;
}

- (instancetype)initWithAmount:(uint64_t)amount Asset:(NSString*)assetId
{
    self = [super init];
    if (self) {
        _amount = amount;
        _asset = [[GXCAsset alloc] initWithId:assetId];
    }
    return self;
}

- (NSData*)toByte {
    NSMutableData *data = [NSMutableData new];
    [data appendUInt64:_amount];
    [data appendUVar:_asset.instance];
    return data;
}

- (id)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@(_amount) forKey:GXC_KEY_AMOUNT];
    [dic setValue:_asset.getId forKey:GXC_KEY_ASSET_ID];
    return dic;
}

- (void)fromJson:(NSDictionary*)dic {
    _amount = [dic[GXC_KEY_AMOUNT] longLongValue];
    _asset = [[GXCAsset alloc] initWithId:dic[GXC_KEY_ASSET_ID]];
}

@end
