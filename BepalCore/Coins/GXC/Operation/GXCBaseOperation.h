//
//  BaseOperation.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/12/22.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXCSerializable.h"
#import "GXCAssetAmount.h"
#import "GXCExtensions.h"

static NSString *GXC_KEY_FEE = @"fee";

@interface GXCBaseOperation : NSObject<GXCSerializable>

@property (strong, nonatomic) GXCAssetAmount *fee;
@property (assign, nonatomic) uint32_t opType;
@property (strong, nonatomic) GXCExtensions *extensions;

- (instancetype)initWithType:(uint32_t)type;
- (NSMutableArray*)toJsonArray;
- (void)formJsonDic:(NSDictionary*)dic;
+ (GXCBaseOperation*)formJsonArray:(NSArray*)array;
- (NSData*)toOpByte;

@end
