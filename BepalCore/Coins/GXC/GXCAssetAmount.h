//
//  GXCAssetAmount.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXCSerializable.h"
#import "GXCAsset.h"

static NSString *GXC_KEY_AMOUNT = @"amount";
static NSString *GXC_KEY_ASSET_ID = @"asset_id";

@interface GXCAssetAmount : NSObject<GXCSerializable>

@property (assign, nonatomic) uint64_t amount;
@property (strong, nonatomic) GXCAsset *asset;

- (instancetype)initWithJson:(NSDictionary*)dic;

- (instancetype)initWithAmount:(uint64_t)amount Asset:(NSString*)assetId;

@end
